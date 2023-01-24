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
for i in {1..30}; do
	run get_second_block_id
	if [ $status == 0 ]; then
		break
	fi
	sleep 1
done
}

@test "celestia-node is processing blocks" {
for i in {1..30}; do
    run curl -s GET http://127.0.0.1:26659/head 2>&1
	if [ $status == 0 ]; then
		break
	fi
	sleep 1
done
}
