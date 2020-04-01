FROM debian:10-slim
ARG AKAMAI_CLI_VERSION=1.1.5
ARG AKAMAI_CLI_PACKAGES=https://raw.githubusercontent.com/ducksify/docker-akamai-cli/master/packages.json

ENV DEBIAN_FRONTEND=noninteractive
ENV GOROOT=/usr/lib/go GOPATH=/gopath GOBIN=/gopath/bin AKAMAI_CLI_HOME=/cli AKAMAI_CLI_PACKAGES="$AKAMAI_CLI_PACKAGES" AKAMAI_CLI_VERSION="$AKAMAI_CLI_VERSION"

RUN mkdir -p /cli/.akamai-cli \
    && apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get install --no-install-recommends -y git python2 python3 python-dev python3-dev python-setuptools python3-setuptools python-pip python3-pip openssl nodejs npm golang jq curl \
    && pip2 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir --upgrade pip \
    && curl -sL -o /usr/local/bin/akamai $(curl -s "https://api.github.com/repos/akamai/cli/releases/tags/$AKAMAI_CLI_VERSION" | jq -r '.assets[].browser_download_url' | grep linuxamd64 | grep -v sig) \
    && chmod +x /usr/local/bin/akamai \
    && curl -s "$AKAMAI_CLI_PACKAGES" | jq -r '.packages[].name' | xargs /usr/local/bin/akamai install --force \
    && apt-get remove -y --purge python-dev python3-dev python-setuptools python3-setuptools python-pip python3-pip npm \
    && apt-get clean

RUN echo "[cli]" > /cli/.akamai-cli/config && \
    echo "cache-path            = /cli/.akamai-cli/cache" >> /cli/.akamai-cli/config && \
    echo "config-version        = 1.1" >> /cli/.akamai-cli/config && \
    echo "enable-cli-statistics = false" >> /cli/.akamai-cli/config && \
    echo "last-ping             = $(date --utc +%FT%TZ)" >> /cli/.akamai-cli/config && \
    echo "client-id             =" >> /cli/.akamai-cli/config && \
    echo "install-in-path       =" >> /cli/.akamai-cli/config && \
    echo "last-upgrade-check    = ignore" >> /cli/.akamai-cli/config


ENTRYPOINT ["/usr/local/bin/akamai"]
CMD ["--daemon"]
#CMD ["/bin/sh"]
