# Local Celestia Devnet

This repo provides a Docker image that allows developers to spin up a local
Celestia devnet composed of:

- 1 x celestia-app validator node
- 1 x celestia-node bridge node

For information about the different node types, see
[here](https://docs.celestia.org/nodes/overview/).

## To run the Docker image from ghcr.io

```bash
docker run \
    -p 26657:26657 -p 26658:26658 -p 26659:26659 -p 9090:9090 \
    ghcr.io/rollkit/local-celestia-devnet:latest
```

## To build and run the Docker image

First, clone the repository:

```bash
git clone https://github.com/rollkit/local-celestia-devnet.git
```

Change into the directory:

```bash
cd local-celestia-devnet/
```

To build the Docker image:

```bash
docker build . -t celestia-local-devnet
```

To run the Docker container:

```bash
docker run \
    -p 26657:26657 -p 26658:26658 -p 26659:26659 -p 9090:9090 \
    celestia-local-devnet
```

Test that the HTTP gateway server is up:

```bash
curl -X GET http://127.0.0.1:26659/head
```

## Exposed Ports

| Port  | Protocol | Address   | Description | Node Type                               |
|-------|----------|-----------|-------------|-----------------------------------------|
| 26657 | HTTP     | 127.0.0.1 | RPC         | Consensus (e.g `celestia-app`)          |
| 26658 | HTTP     | 127.0.0.1 | RPC         | Data Availability (e.g `celestia-node`) |
| 26659 | HTTP     | 127.0.0.1 | REST        | Data Availability (e.g `celestia-node`) |
| 9090  | HTTP     | 0.0.0.0   | gRPC        | Consensus (e.g `celestia-app`)          |

You may also find these docs helpful:

- [celestia-app ports](https://docs.celestia.org/nodes/celestia-app/#ports)
- [celestia-node ports](https://docs.celestia.org/nodes/celestia-node-troubleshooting/#ports)
