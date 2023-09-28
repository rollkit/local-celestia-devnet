# Local Celestia Devnet

This repo provides a Docker image that allows developers to spin up a local
devnet node for testing without depending on the network or service.

## To run the Docker image from ghcr.io

```bash
docker run -t -i \
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
docker run -t -i \
    -p 26657:26657 -p 26658:26658 -p 26659:26659 -p 9090:9090 \
    celestia-local-devnet
```

Test that the HTTP gateway server is up:

```bash
curl -X GET http://127.0.0.1:26659/head
```

## Running a Detached Container

If you would like the run the container in the background, you can use the
`-d` flag:

```bash
docker run -d -t -i \
    -p 26657:26657 -p 26658:26658 -p 26659:26659 -p 9090:9090 \
    celestia-local-devnet
```

## Stopping the Container

To stop the container when you are attached to the container, you can use
`Ctrl+C` to stop the container.

To stop the container when you are detached from the container, you can use the
`docker ps` command to find the container ID:

```bash
docker ps
```

Then, use the `docker stop` command to stop the container:

```bash
docker stop <container-id>
```

To remove the container, use the `docker rm` command to remove the container:

```bash
docker rm <container-id>
```

## Exposed Ports

| Port  | Protocol | Address   | Description | Node Type                               |
|-------|----------|-----------|-------------|-----------------------------------------|
| 26657 | HTTP     | 127.0.0.1 | RPC         | Consensus (e.g `celestia-app`)          |
| 26658 | HTTP     | 127.0.0.1 | RPC         | Data Availability (e.g `celestia-node`) |
| 26659 | HTTP     | 127.0.0.1 | REST        | Data Availability (e.g `celestia-node`) |
| 9090  | HTTP     | 0.0.0.0   | gRPC        | Consensus (e.g `celestia-app`)          |

You can also find a section on port usage in the
[`celestia-app` tutorial](https://docs.celestia.org/nodes/celestia-app/#ports)
and the node
[troubleshooting section](https://docs.celestia.org/nodes/celestia-node-troubleshooting/#ports).

For information about the different node types, see
[here](https://docs.celestia.org/nodes/overview/).
