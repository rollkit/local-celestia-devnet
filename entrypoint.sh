#!/usr/bin/env bash

CHAINID="test"

# App & node has a celestia user with home dir /home/celestia
APP_PATH="/home/celestia/.celestia-app"
NODE_PATH="/home/celestia/bridge/"
GENESIS_FILE="/home/celestia/.celestia-app/config/genesis.json"

# Check if the folder exists
if [ -d "$APP_PATH" ]; then
  # If it exists, delete it
  echo "The folder $APP_PATH exists. Deleting it..."
  rm -rf "$APP_PATH"
  echo "Folder deleted."
else
  # If it doesn't exist, print a message
  echo "The folder $APP_PATH does not exist."
fi

# Build genesis file incl account for passed address
coins="1000000000000000utia"
celestia-appd init $CHAINID --chain-id $CHAINID
celestia-appd keys add validator --keyring-backend="test"
# this won't work because some proto types are declared twice and the logs output to stdout (dependency hell involving iavl)
celestia-appd add-genesis-account $(celestia-appd keys show validator -a --keyring-backend="test") $coins
celestia-appd gentx validator 5000000000utia \
  --keyring-backend="test" \
  --chain-id $CHAINID

celestia-appd collect-gentxs

# Set proper defaults and change ports
# If you encounter: `sed: -I or -i may not be used with stdin` on MacOS you can mitigate by installing gnu-sed
# https://gist.github.com/andre3k1/e3a1a7133fded5de5a9ee99c87c6fa0d?permalink_comment_id=3082272#gistcomment-3082272
sed -i'.bak' 's#"tcp://127.0.0.1:26657"#"tcp://0.0.0.0:26657"#g' ~/.celestia-app/config/config.toml
sed -i'.bak' 's/timeout_commit = "11s"/timeout_commit = "300ms"/g' ~/.celestia-app/config/config.toml
sed -i'.bak' 's/timeout_propose = "10s"/timeout_propose = "500ms"/g' ~/.celestia-app/config/config.toml
sed -i'.bak' 's/timeout_propose_delta = "500ms"/timeout_propose_delta = "5ms"/g' ~/.celestia-app/config/config.toml
sed -i'.bak' 's/timeout_prevote = "1s"/timeout_prevote = "50ms"/g' ~/.celestia-app/config/config.toml
sed -i'.bak' 's/timeout_prevote_delta = "500ms"/timeout_prevote_delta = "1ms"/g' ~/.celestia-app/config/config.toml
sed -i'.bak' 's/timeout_precommit = "1s"/timeout_precommit = "50ms"/g' ~/.celestia-app/config/config.toml
sed -i'.bak' 's/timeout_precommit_delta = "500ms"/timeout_precommit_delta = "1ms"/g' ~/.celestia-app/config/config.toml
sed -i'.bak' 's/timeout_commit = "11s"/timeout_commit = "300ms"/g' ~/.celestia-app/config/config.toml
sed -i'.bak' 's/index_all_keys = false/index_all_keys = true/g' ~/.celestia-app/config/config.toml
sed -i'.bak' 's/mode = "full"/mode = "validator"/g' ~/.celestia-app/config/config.toml



# Update data commitment window
jq '.app_state.qgb.params.data_commitment_window = "101"' "$GENESIS_FILE" | sponge "$GENESIS_FILE"

echo "Updated data_commitment_window to 101 in $GENESIS_FILE"

echo $(cat ${GENESIS_FILE})

# Register the validator EVM address
{
  # wait for block 1
  sleep 5

  echo "Showing valoper address"
  celestia-appd keys show validator --home "${APP_PATH}" --bech val -a

  echo "Checking registered EVM address"
  celestia-appd query qgb evm "$(celestia-appd keys show validator --home "${APP_PATH}" --bech val -a)"

  # private key: da6ed55cb2894ac2c9c10209c09de8e8b9d109b910338d5bf3d747a7e1fc9eb9
  celestia-appd tx qgb register \
    "$(celestia-appd keys show validator --home "${APP_PATH}" --bech val -a)" \
    0x966e6f22781EF6a6A82BBB4DB3df8E225DfD9488 \
    --from validator \
    --home "${APP_PATH}" \
    --fees "30000utia" \
    -b block \
    --chain-id="test" \
    --yes

  echo "Checking registered EVM address"
  celestia-appd query qgb evm "$(celestia-appd keys show validator --home "${APP_PATH}" --bech val -a)"
} &

mkdir -p $NODE_PATH/keys
cp -r $APP_PATH/keyring-test/ $NODE_PATH/keys/keyring-test/

# Start the celestia-app
celestia-appd start --grpc.enable &

# Try to get the genesis hash. Usually first request returns an empty string (port is not open, curl fails), later attempts
# returns "null" if block was not yet produced.
GENESIS=
CNT=0
MAX=30
while [ "${#GENESIS}" -le 4 -a $CNT -ne $MAX ]; do
	GENESIS=$(curl -s http://127.0.0.1:26657/block?height=1 | jq '.result.block_id.hash' | tr -d '"')
	((CNT++))
	sleep 1
done

export CELESTIA_CUSTOM=test:$GENESIS
echo $CELESTIA_CUSTOM

celestia bridge init --node.store /home/celestia/bridge
export CELESTIA_NODE_AUTH_TOKEN=$(celestia bridge auth admin --node.store ${NODE_PATH})
echo "Auth Token $CELESTIA_NODE_AUTH_TOKEN"
echo "WARNING: Keep this auth token secret **DO NOT** log this auth token outside of development. CELESTIA_NODE_AUTH_TOKEN=$CELESTIA_NODE_AUTH_TOKEN"
celestia bridge start \
  --node.store $NODE_PATH --gateway \
  --core.ip 127.0.0.1 \
  --keyring.accname validator