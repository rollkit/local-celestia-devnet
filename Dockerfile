FROM ghcr.io/celestiaorg/celestia-app:v0.13.0 AS celestia-app

FROM ghcr.io/celestiaorg/celestia-node:v0.9.2

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

EXPOSE 26657 26659 9090

ENTRYPOINT [ "/bin/bash", "/opt/entrypoint.sh" ]
