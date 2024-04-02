#!/usr/bin/env bats

setup_file() {
    docker build . -t celestia-devnet-local
	CONTAINER=$(docker run -d -p 26657:26657 -p 26659:26659 celestia-devnet-local)
}

teardown_file() {
	docker stop $CONTAINER
	docker rm $CONTAINER
}

get_second_block_id() {
	curl -s http://127.0.0.1:26657/block?height=2 | grep block_id
}

@test "celestia-appd is producing blocks" {
ok="false"
for i in {1..30}; do
	run get_second_block_id
	if [ $status == 0 ]; then
		ok="true"
		break
	fi
	sleep 1
done
$($ok)
}

get_head_proposer_address() {
	curl -s http://127.0.0.1:26659/head | grep proposer_address
}


@test "celestia-node is processing blocks" {
ok="false"
for i in {1..30}; do
    run get_head_proposer_address
	if [ $status == 0 ]; then
		ok="true"
		break
	fi
	sleep 1
done
$($ok)
}
