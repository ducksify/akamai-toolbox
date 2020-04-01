FROM debian:10-slim
ARG AKAMAI_CLI_VERSION="1.1.5"
ARG AKAMAI_CLI_PACKAGES="https://raw.githubusercontent.com/ducksify/docker-akamai-toolbox/master/packages.json"

ENV DEBIAN_FRONTEND=noninteractive
ENV GOROOT="/usr/lib/go" GOPATH="/gopath" GOBIN="/gopath/bin" AKAMAI_USER="akamaiuser" AKAMAI_USER_HOME="/home/akamaiuser" AKAMAI_CLI_HOME="/home/akamaiuser/cli" AKAMAI_CLI_PACKAGES="$AKAMAI_CLI_PACKAGES" AKAMAI_CLI_VERSION="$AKAMAI_CLI_VERSION"

RUN useradd -m -d ${AKAMAI_USER_HOME} -s /bin/sh ${AKAMAI_USER} \
    && mkdir -p ${AKAMAI_CLI_HOME}/.akamai-cli ${AKAMAI_USER_HOME}/workspace \
    && chown -R ${AKAMAI_USER}:${AKAMAI_USER} ${AKAMAI_CLI_HOME} ${AKAMAI_USER_HOME}/workspace \
    && apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get install --no-install-recommends -y git python2 python3 python-dev python3-dev python-setuptools python3-setuptools python-pip python3-pip openssl nodejs npm golang jq curl \
    && pip2 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir --upgrade pip \
    && curl -sL -o /usr/local/bin/akamai $(curl -s "https://api.github.com/repos/akamai/cli/releases/tags/$AKAMAI_CLI_VERSION" | jq -r '.assets[].browser_download_url' | grep linuxamd64 | grep -v sig) \
    && chmod +x /usr/local/bin/akamai \
    && curl -s "$AKAMAI_CLI_PACKAGES" | jq -r '.packages[].name' | xargs -I '{}' /bin/su -c "export AKAMAI_CLI_HOME=${AKAMAI_CLI_HOME} ; /usr/local/bin/akamai install --force {}" - ${AKAMAI_USER} \
    && apt-get remove -y --purge python-dev python3-dev python-setuptools python3-setuptools python-pip python3-pip npm \
    && apt-get clean

RUN echo "[cli]"                                                        >  ${AKAMAI_CLI_HOME}/.akamai-cli/config && \
    echo "cache-path            = ${AKAMAI_CLI_HOME}/.akamai-cli/cache" >> ${AKAMAI_CLI_HOME}/.akamai-cli/config && \
    echo "config-version        = 1.1"                                  >> ${AKAMAI_CLI_HOME}/.akamai-cli/config && \
    echo "enable-cli-statistics = false"                                >> ${AKAMAI_CLI_HOME}/.akamai-cli/config && \
    echo "last-ping             = $(date --utc +%FT%TZ)"                >> ${AKAMAI_CLI_HOME}/.akamai-cli/config && \
    echo "client-id             ="                                      >> ${AKAMAI_CLI_HOME}/.akamai-cli/config && \
    echo "install-in-path       ="                                      >> ${AKAMAI_CLI_HOME}/.akamai-cli/config && \
    echo "last-upgrade-check    = ignore"                               >> ${AKAMAI_CLI_HOME}/.akamai-cli/config

USER ${AKAMAI_USER}
WORKDIR ${AKAMAI_USER_HOME}/workspace
ENTRYPOINT ["/usr/local/bin/akamai"]
CMD ["--daemon"]
#CMD ["/bin/sh"]
