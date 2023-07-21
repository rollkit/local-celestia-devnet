# Local Celestia Devnet

This repo provides a docker image that allows developers to spin up a local
devnet node for testing without depending on the network or service.

## To run the docker image from ghcr.io

```bash
docker run --platform linux/amd64 \
    -p 26657:26657 -p 26658:26658 -p 26659:26659 -p 9090:9090 \
    ghcr.io/rollkit/local-celestia-devnet:latest
```

## To build and run the docker image

First, clone the repository:

```bash
git clone https://github.com/rollkit/local-celestia-devnet.git
```

Change into the directory:

```bash
cd local-celestia-devnet/
```

To build the docker image:

```bash
docker build . -t celestia-local-devnet
```

To run the docker container:

```bash
docker run --platform linux/amd64 \
    -p 26657:26657 -p 26658:26658 -p 26659:26659 -p 9090:9090 \
    celestia-local-devnet
```

Test that the RPC server is up:

```bash
curl -X GET http://127.0.0.1:26659/head
```
