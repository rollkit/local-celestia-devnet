FROM ghcr.io/celestiaorg/celestia-app:v1.0.0-rc9 AS celestia-app

FROM ghcr.io/celestiaorg/celestia-node:v0.11.0-rc8

USER root

# hadolint ignore=DL3018
RUN apk --no-cache add \
        curl \
        jq \
    && mkdir /bridge \
    && chown celestia:celestia /bridge

USER celestia

COPY --from=celestia-app /bin/celestia-appd /bin/

COPY entrypoint.sh /opt/entrypoint.sh

EXPOSE 26657 26658 26659 9090

ENTRYPOINT [ "/bin/bash", "/opt/entrypoint.sh" ]
