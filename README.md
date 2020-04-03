<p align="center">
  <img alt="Ducksify logo" src="https://github.com/ducksify/akamai-toolbox/raw/master/docs/assets/logo.jpg"/>
  <h3 align="center">Ducksified Akamai Toolbox</h3>
  <p align="center">
    <img alt="GitHub License" src="https://badgen.net/github/license/ducksify/akamai-toolbox"/>
    <img alt="GitHub Workflow Status" src="https://github.com/ducksify/akamai-toolbox/workflows/Docker/badge.svg"/>
    <img alt="GitHub issues" src="https://badgen.net/github/open-issues/ducksify/akamai-toolbox"/>
    <img alt="GitHub pull requests" src="https://badgen.net/github/open-prs/ducksify/akamai-toolbox"/>
    <img alt="GitHub forks" src="https://badgen.net/github/forks/ducksify/akamai-toolbox"/>
    <img alt="GitHub stars" src="https://badgen.net/github/stars/ducksify/akamai-toolbox"/>
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
**Work-in-progress**

This project is trying to address various issues of the official Akamai CLI Docker image, and provide a full featured toolbox to interact with Akamai OpenAPIs & debug online properties.

Changes implemented here will be opinionated, and may not be a good fit for everybody.

Main drifts with Akamai official Docker image :
- Built on top of Debian slim (solve all potential musl/glibc differences)
- Unprivileged user
- Lighter
- Includes httpie + edgegrid.
- 

At this point in time, we don't commit on any stability / backward compatibility, so use it at your own risk.


## Using the toolbox

The toolbox contains httpie + edgegrid plugin, akamai CLI 1.1.5 (https://github.com/akamai/cli), and the following modules (cf. `packages.json`) :

| Module  	| Description  	|
|---	|---	|
| adaptive-acceleration  	| -  	|
| appsec  	| -  	|
| auth  	| -  	|
| cps  	| -  	|
| dns  	| -  	|
| eaa  	| -  	|
| edgeworkers  	| -  	|
| firewall  	| -  	|
| image-manager  	| -  	|
| netstorage  	| -  	|
| property  	| -  	|
| property-manager  	| -  	|
| purge  	| -  	|
| visitor-prioritization  	| -  	|






### Prerequisites
You must use a personal access token with the appropriate scopes to install packages from Github Packages.
Considering that your token is stored within `~/gh_token` :
```
$ docker login docker.pkg.github.com -u <username> --password-stdin < ~/gh_token
```

### Pulling image
If you just want to pull the image :
```
$ docker pull docker.pkg.github.com/ducksify/akamai-toolbox/latest
```

### Usage

Simply deploy `bin/akamai-toolbox` in your $PATH & run it :
```
$ akamai-toolbox
Usage :
-------
$ akamai-toolbox <cmd>

Valid commands :
----------------
- cli : Akamai CLI
- http : HTTPie with edgegrid plugin
```

#### Accessing the CLI
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

## Customizing build

TBD
