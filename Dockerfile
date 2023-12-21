FROM ghcr.io/celestiaorg/celestia-app:v1.4.0 AS celestia-app

FROM ghcr.io/rollkit/celestia-da:2e785c0

USER root

# hadolint ignore=DL3018
RUN apk --no-cache add \
        curl \
        jq \
        openssl \
    && mkdir /bridge \
    && chown celestia:celestia /bridge

USER celestia

COPY --from=celestia-app /bin/celestia-appd /bin/

COPY entrypoint.sh /opt/entrypoint.sh

EXPOSE 26650 26657 26658 26659 9090

ENTRYPOINT [ "/bin/bash", "/opt/entrypoint.sh" ]
