FROM debian:11-slim
ARG BUILD_DATE
ARG VCS_REF
ARG AKAMAI_CLI_VERSION="1.3.1"
ARG AKAMAI_CLI_PACKAGES="./packages.json"

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="Akamai Toolbox" \
      org.label-schema.description="Ducksified Akamai Toolbox" \
      org.label-schema.url="https://ducksify.com/" \
      org.label-schema.vcs-url="https://github.com/ducksify/akamai-toolbox" \
      org.label-schema.vendor="Ducksify SA" \
      org.label-schema.schema-version="1.0"

ENV DEBIAN_FRONTEND=noninteractive
ENV TOOLBOX_USER="toolbox" TOOLBOX_USER_HOME="/home/toolbox" AKAMAI_CLI_HOME="/home/toolbox" AKAMAI_CLI_PACKAGES="$AKAMAI_CLI_PACKAGES" AKAMAI_CLI_VERSION="$AKAMAI_CLI_VERSION"

ADD ${AKAMAI_CLI_PACKAGES} /tmp/packages.json
COPY bin/cmd/akcurl /usr/local/bin/akcurl

RUN useradd -u 9001 -m -d ${TOOLBOX_USER_HOME} -s /bin/sh ${TOOLBOX_USER} \
    && mkdir -p ${AKAMAI_CLI_HOME}/.akamai-cli ${TOOLBOX_USER_HOME}/workspace /etc/apt/keyrings \
    && chown -R ${TOOLBOX_USER}:${TOOLBOX_USER} ${AKAMAI_CLI_HOME}/.akamai-cli ${TOOLBOX_USER_HOME}/workspace /usr/local/bin/akcurl \
    && echo "deb http://deb.debian.org/debian bullseye-backports main contrib non-free" | tee /etc/apt/sources.list.d/bullseye-backports.list \
    && echo "deb-src http://deb.debian.org/debian bullseye-backports main contrib non-free" | tee -a /etc/apt/sources.list.d/bullseye-backports.list \
    && apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get install --no-install-recommends -y git python2 python3 python-dev python3-dev python-setuptools python3-setuptools python3-pip openssl jq curl httpie bc gpg \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y nodejs golang/bullseye-backports golang-doc/bullseye-backports golang-go/bullseye-backports golang-src/bullseye-backports \
    && pip3 install --no-cache-dir --upgrade pip \
    && pip3 install httpie-edgegrid \
    && curl -sL -o /usr/local/bin/cli $(curl -s "https://api.github.com/repos/akamai/cli/releases/tags/$AKAMAI_CLI_VERSION" | jq -r '.assets[].browser_download_url' | grep linuxamd64 | grep -v sig) \
    && chmod +x /usr/local/bin/cli \
    && ln -s /usr/local/bin/cli /usr/local/bin/akamai \
    && chmod +x /usr/local/bin/akcurl \
    && jq -r '.packages[]' < /tmp/packages.json | xargs -I '{}' /bin/su -c "export AKAMAI_CLI_HOME=${AKAMAI_CLI_HOME} ; /usr/local/bin/cli install --force {} ; echo OK" - ${TOOLBOX_USER} \
    && su -c "npm cache clean --force" - ${TOOLBOX_USER} \
    && apt-get remove -y --purge python-dev python3-dev python-setuptools python3-setuptools python-pip python3-pip npm "golang*" git gpg \
    && apt-get clean \
    && find /home/toolbox/.akamai-cli/src/ -type d -name ".git" | xargs -I '{}' rm -rf '{}' \
    && rm -f /tmp/packages.json \
    && echo "[cli]"                                                        >  ${AKAMAI_CLI_HOME}/.akamai-cli/config \
    && echo "cache-path            = ${AKAMAI_CLI_HOME}/.akamai-cli/cache" >> ${AKAMAI_CLI_HOME}/.akamai-cli/config \
    && echo "config-version        = 1.1"                                  >> ${AKAMAI_CLI_HOME}/.akamai-cli/config \
    && echo "enable-cli-statistics = false"                                >> ${AKAMAI_CLI_HOME}/.akamai-cli/config \
    && echo "last-ping             = $(date --utc +%FT%TZ)"                >> ${AKAMAI_CLI_HOME}/.akamai-cli/config \
    && echo "client-id             ="                                      >> ${AKAMAI_CLI_HOME}/.akamai-cli/config \
    && echo "install-in-path       ="                                      >> ${AKAMAI_CLI_HOME}/.akamai-cli/config \
    && echo "last-upgrade-check    = ignore"                               >> ${AKAMAI_CLI_HOME}/.akamai-cli/config

USER ${TOOLBOX_USER}
WORKDIR ${TOOLBOX_USER_HOME}/workspace
ENTRYPOINT ["/usr/local/bin/cli"]
CMD ["--daemon"]
