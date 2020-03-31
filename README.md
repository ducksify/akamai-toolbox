# Ducksified Akamai CLI Docker image
[![GitHub license](https://img.shields.io/github/license/ducksify/docker-akamai-cli?style=flat-square)](https://github.com/ducksify/docker-akamai-cli/blob/master/LICENSE)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/ducksify/docker-akamai-cli/Docker?style=flat-square)
![GitHub issues](https://img.shields.io/github/issues-raw/ducksify/docker-akamai-cli?style=flat-square)
![GitHub pull requests](https://img.shields.io/github/issues-pr/ducksify/docker-akamai-cli?style=flat-square)
[![GitHub forks](https://img.shields.io/github/forks/ducksify/docker-akamai-cli?style=flat-square)](https://github.com/ducksify/docker-akamai-cli/network)
[![GitHub stars](https://img.shields.io/github/stars/ducksify/docker-akamai-cli?style=flat-square)](https://github.com/ducksify/docker-akamai-cli/stargazers)


## Disclaimer
**WIP**

We are trying to address issues on the official Akamai CLI Docker image.
Changes implemented here may/will be opinionated, and may not be a good fit for everybody.

At this point in time, we don't commit on any stability / backward compatibility, so use it at your own risk.



## Using image
Our image is based on Akamai CLI 1.1.5, and contains all modules listed in the *packages.json* file. 

### Prerequisites
You must use a personal access token with the appropriate scopes to install packages from Github Packages.
Considering that your token is stored within ~/gh_token,

```
$ docker login docker.pkg.github.com -u <username> --password-stdin < ~/gh_token
```

### Pulling image
```
$ docker pull docker.pkg.github.com/ducksify/docker-akamai-cli/latest
```

### Usage
tbd
