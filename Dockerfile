FROM alpine
ARG AKAMAI_CLI_VERSION=1.1.3
ARG AKAMAI_CLI_PACKAGES=https://raw.githubusercontent.com/ducksify/docker-akamai-cli/master/packages.json
ENV GOROOT=/usr/lib/go GOPATH=/gopath GOBIN=/gopath/bin AKAMAI_CLI_HOME=/cli AKAMAI_CLI_PACKAGES="$AKAMAI_CLI_PACKAGES" AKAMAI_CLI_VERSION="$AKAMAI_CLI_VERSION"
RUN mkdir -p /cli/.akamai-cli && \
    apk add --no-cache python2 python3 openssl nodejs libffi go libc6-compat && \
    apk add --no-cache -t .build-deps git python2-dev py2-pip python3-dev jq openssl-dev curl build-base libffi-dev npm && \
    curl -s -L -o /usr/local/bin/akamai `curl "https://api.github.com/repos/akamai/cli/releases/tags/$AKAMAI_CLI_VERSION" | jq -r '.assets[].browser_download_url' | grep linuxamd64 | grep -v sig` && \
    chmod +x /usr/local/bin/akamai && \
    pip2 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir --upgrade pip && \
    curl -s "$AKAMAI_CLI_PACKAGES" | jq -r .packages[].name | xargs /usr/local/bin/akamai install --force && \
    apk del .build-deps

RUN echo "[cli]" > /cli/.akamai-cli/config && \
    echo "cache-path            = /cli/.akamai-cli/cache" >> /cli/.akamai-cli/config && \
    echo "config-version        = 1" >> /cli/.akamai-cli/config && \
    echo "enable-cli-statistics = false" >> /cli/.akamai-cli/config && \
    echo "last-ping             = $(date --utc +%FT%TZ)" >> /cli/.akamai-cli/config && \
    echo "client-id             =" >> /cli/.akamai-cli/config && \
    echo "install-in-path       =" >> /cli/.akamai-cli/config && \
    echo "last-upgrade-check    = ignore" >> /cli/.akamai-cli/config

VOLUME /root/.edgerc
VOLUME /cli
ENTRYPOINT ["/usr/local/bin/akamai"]
CMD ["--daemon"]
