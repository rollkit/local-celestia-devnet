Local Celestia Devnet:
======================

This repo provides a docker image that allows developers to spin up a local
devnet node for testing without depending on the network or service.

To build the docker image:

    docker build . -t celestia-local-devnet

To run the docker container:

    docker  run -p 26657:26657 -p 26659:26659 celestia-local-devnet

Test that the RPC server is up:

    curl -X GET http://127.0.0.1:26659/head
