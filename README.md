<p align="center">
  <img alt="Ducksify logo" src="https://github.com/ducksify/akamai-toolbox/raw/master/docs/assets/logo.jpg"/>
  <h3 align="center">Ducksified Akamai Toolbox</h3>
  <p align="center">
    <img alt="GitHub license" src="https://badgen.net/github/license/ducksify/akamai-toolbox?cache=300&color=green"/>
    <img alt="GitHub issues" src="https://badgen.net/github/open-issues/ducksify/akamai-toolbox?cache=300&icon=github"/>
    <img alt="GitHub pull requests" src="https://badgen.net/github/open-prs/ducksify/akamai-toolbox?cache=300&icon=github"/>
    <img alt="GitHub forks" src="https://badgen.net/github/forks/ducksify/akamai-toolbox?cache=300&icon=github"/>
    <img alt="GitHub stars" src="https://badgen.net/github/stars/ducksify/akamai-toolbox?cache=300&icon=github"/>
    <img alt="GitHub releases" src="https://badgen.net/github/releases/ducksify/akamai-toolbox?cache=300&color=black&icon=github"/>
    <img alt="Docker pulls" src="https://badgen.net/docker/pulls/ducksify/akamai-toolbox?icon=docker&cache=300&color=cyan"/>
  </p>
</p>



## Table of Contents
- [Disclaimer](#disclaimer)
- [Using the toolbox](#using-the-toolbox)
  + [Prerequisites](#prerequisites)
  + [Pulling image](#pulling-image)
  + [Usage](#usage)
- [Customizing build](#customizing-build)

## Disclaimer

### Project description
**Work-in-progress**

This project is providing an opinionated, full featured and easily extensible/customizable toolbox to interact with Akamai OpenAPIs & debug online properties which includes :
- Akamai CLI installed with various modules (official & contrib)
- httpie with EdgeGrid authentication plugin
- akcurl, a custom wrapper around curl injecting Akamai debug pragmas and providing performance stats.

Main drifts with the Akamai CLI official Docker image (non exhaustive):
- Built on top of Debian slim instead of Alpine (solves all potential musl/glibc differences)
- Running as unprivileged user, with proper HOME folder & directory structure.
- Additional tools (httpie/edgedrid, akcurl ...)
- Lighter :)


### Notes
Installing / upgrading modules directly from the CLI is **not supported** and **will** fail : our goal is to provide a *stable* & *(quite) reproducible* toolbox. While it may not make everybody happy, this approach ensures that deploying a given release of the toolbox will *always* behave the same way.

If you want to modify included modules, please see [Customizing build](#customizing-build).


## Using the toolbox

### Requirements
- Docker enabled host
- `${HOME}/.edgerc` file containing your credentials to connect to Akamai APIs

### Wrapper installation
Head to the [releases page](https://github.com/ducksify/akamai-toolbox/releases), download the `akamai-toolbox` release somewhere in your PATH & make it executable.

Downloading the wrapper from the master branch is also definitely an option. Please note that in this case, your toolbox will use the `:latest` tag of the Docker image that may/will be updated without prior notice. 

Example :
```
# From a given release
$ wget -qO /usr/local/bin/akamai-toolbox https://github.com/ducksify/akamai-toolbox/releases/download/20200404-rc1/akamai-toolbox

# From master branch
$ wget -qO /usr/local/bin/akamai-toolbox https://raw.githubusercontent.com/ducksify/akamai-toolbox/master/bin/akamai-toolbox

$ chmod +x /usr/local/bin/akamai-toolbox
```

### Pulling image
If you just want to pull the image :
```
$ docker pull ducksify/akamai-toolbox:<tagname>
```

### Handy shell aliases
If you want to reduce the pressure on your keyboard, you can add the following aliases in your shell
```
alias akcurl="/usr/local/bin/akamai-toolbox akcurl"
alias akhttp="/usr/local/bin/akamai-toolbox http --auth-type=edgegrid"
alias akcli="/usr/local/bin/akamai-toolbox cli"
```

### Usage

Simply run the `akamai-toolbox` command :
```
Usage :
-------
$ akamai-toolbox <cmd>

Valid commands :
----------------
- cli : Akamai CLI
- http : HTTPie with edgegrid plugin
- akcurl : Debug online properties
```

#### Using the Akamai CLI
```
$ akamai-toolbox cli
Usage:
  akamai [global flags] command [command flags] [arguments...]

Built-In Commands:
  config
  help
  install (alias: get)
  list
  search
  uninstall
  update
  upgrade

Installed Commands:
  adaptive-acceleration (alias: a2)
  appsec
  
  [... truncated ...]
```

#### Using HTTPie 
```
$ akamai-toolbox http
usage: http [--json] [--form] [--pretty {all,colors,format,none}]
            [--style STYLE] [--print WHAT] [--headers] [--body] [--verbose]
            [--all] [--history-print WHAT] [--stream] [--output FILE]
            [--download] [--continue]
            [--session SESSION_NAME_OR_PATH | --session-read-only SESSION_NAME_OR_PATH]
            [--auth USER[:PASS]] [--auth-type {basic,digest,edgegrid}]

  [... truncated ...]
```

#### Using akcurl 
```
$ akamai-toolbox akcurl https://ducksify.com/
HTTP/2 200

accept-ranges: bytes
cache-control: private, max-age=1800
content-encoding: gzip
content-length: 5370
content-type: text/html
date: Sat, 04 Apr 2020 10:04:17 GMT
etag: "3bb998476d9a9927c55d114e591164f6:1578732245.29281"
expires: Sat, 04 Apr 2020 10:34:17 GMT
last-modified: Sat, 11 Jan 2020 08:44:05 GMT
server-timing: cdn-cache; desc=HIT
server-timing: edge; dur=1
strict-transport-security: max-age=31536000 ; includeSubDomains ; preload
vary: Accept-Encoding
x-akamai-transformed: 9 - 0 pmb=mRUM,3
x-cache-key-extended-internal-use-only: S/=/38607/918457/redacted/redacted/redacted/?akamai-transform=9 vcd=16634
x-cache-key: S/=/38607/918457/redacted/redacted/redacted/?akamai-transform=9
x-cache: TCP_HIT from a23-10-249-53.deploy.akamaitechnologies.com (AkamaiGHost/9.9.4.1-29027442) (-)
x-check-cacheable: NO
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
x-true-cache-key: /=/redacted/redacted/ vcd=16634
x-xss-protection: 1; mode=block

Download speed: 23306.6 KB
Upload speed 0.0 KB


  DNS Lookup   TCP Connection   SSL Handshake   Server Processing   Content Transfer
[      54ms  |        20ms    |       77ms    |         69ms      |          6ms     ]
             |                |               |                   |                  |
    namelookup:54ms           |               |                   |                  |
                        connect:74ms          |                   |                  |
                                    pretransfer:151ms             |                  |
                                                      starttransfer:220ms            |
                                                                                 total:226ms
```


## Customizing build

CLI modules included in the image are listed in `packages.json` which is parsed at build time.
Should you want to create your own image, including only specific modules, just fork/clone the repository, update the `packages.json` file and rebuild the image :
```
$ cd /path/to/your/local/copy
$ docker build -t akamai-toolbox .
```

It's also possible to specify a custom (or even HTTP remotely accessible) JSON file using `--build-arg` :
```
$ cd /path/to/your/local/copy
$ docker build -t akamai-toolbox --build-arg AKAMAI_CLI_PACKAGES=your_custom_packages.json .
```

Please refer to the current `packages.json` file to get the correct JSON structure.
