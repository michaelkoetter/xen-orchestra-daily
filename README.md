# Xen Orchestra Daily Image
[![Build Docker Image](https://github.com/michaelkoetter/xen-orchestra-daily/actions/workflows/build-image.yml/badge.svg)](https://hub.docker.com/r/mkoetter/xen-orchestra) 
[![image-version](https://img.shields.io/docker/v/mkoetter/xen-orchestra)](https://hub.docker.com/r/mkoetter/xen-orchestra)
[![arch-amd64](https://img.shields.io/badge/arch-amd64-blue)](https://hub.docker.com/r/mkoetter/xen-orchestra)
[![arch-arm64](https://img.shields.io/badge/arch-arm64-blue)](https://hub.docker.com/r/mkoetter/xen-orchestra)

[This image](https://hub.docker.com/r/mkoetter/xen-orchestra) is built automatically from the [Xen Orchestra](https://github.com/vatesfr/xen-orchestra) master branch.

## Usage

The supplied [`docker-compose.yml`](docker-compose.yml) can be used to run this image with a Redis container for persistence.

Instead of using the `latest` tag, it is recommended to use a
date tag (eg. `20210503`) and update only as required. 

***As this image is built directly from master, it might break anytime.*** So please backup and test thoroughly before deploying a new version.

## Configuration

The Xen Orchestra container can be configured using environment variables.

### `XO_HTTP_PORT`

The HTTP port that Xen Orchestra will listen on.

Default: `80`

### `XO_REDIS_URI`

The Redis URI for Xen Orchestra persistence.

Default: `redis://redis:6379/0`
