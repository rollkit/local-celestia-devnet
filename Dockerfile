FROM ghcr.io/celestiaorg/celestia-node:v0.8.0-rc1 AS celestia-node

FROM ghcr.io/celestiaorg/celestia-app:v0.12.1

COPY --from=celestia-node /bin/celestia /

RUN apk update && apk --no-cache add curl jq libc6-compat

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh 

EXPOSE 26657 26659 9090

ENTRYPOINT ["/entrypoint.sh"]
