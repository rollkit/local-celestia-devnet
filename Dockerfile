FROM ghcr.io/celestiaorg/celestia-app:0.12.2 AS celestia-app

FROM ghcr.io/celestiaorg/celestia-node:v0.8.2

USER root

# hadolint ignore=DL3018
RUN apk --no-cache add \
        curl \
        jq \
        libc6-compat

USER celestia

COPY --from=celestia-app /bin/celestia-appd /bin/

COPY entrypoint.sh /opt/entrypoint.sh

EXPOSE 26657 26659 9090

ENTRYPOINT [ "/bin/bash", "/opt/entrypoint.sh" ]
