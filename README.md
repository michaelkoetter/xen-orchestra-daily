# Xen Orchestra Daily Image

[![Build Docker Image](https://github.com/michaelkoetter/xen-orchestra-daily/actions/workflows/build-image.yml/badge.svg)](https://github.com/michaelkoetter/xen-orchestra-daily/actions/workflows/build-image.yml)
![image-version](https://img.shields.io/docker/v/mkoetter/xen-orchestra)
![arch-amd64](https://img.shields.io/badge/arch-amd64-blue)

This image is built automatically from the [Xen Orchestra](https://github.com/vatesfr/xen-orchestra) master branch.

## Usage

The supplied [`docker-compose.yml`](https://github.com/michaelkoetter/xen-orchestra-daily/blob/master/docker-compose.yml) can be used to run this image with a Redis container for persistence.

Instead of using the `latest` tag, it is recommended to use a
date tag (eg. `20210503`) and update only as required. 

***As this image is built directly from master, it might break anytime.*** So please backup and test thoroughly before deploying a new version.

## Xen Orchestra Server

### Environment Variables

#### `XO_SERVER_REDIS_URI`

The Redis URI for Xen Orchestra persistence.

Default: `redis://redis:6379/0`

## Xen Orchestra Backup Proxy

You can optionally start the container in [Backup Proxy](https://xen-orchestra.com/docs/proxy.html) mode. 
To do so, the container *must* be run in a VM that can be discovered by Xen Orchestra 
(it uses this to figure out the proxy address).

The proxy will always listen on port 443 with auto-TLS (self signed certificates).

***This is experimental and completely unsupported!***

Run the following and import the resulting config file:
```bash
# Keep this token secure. It must also be passed to the proxy container (see below)
PROXY_AUTHENTICATION_TOKEN="$(head -n50 /dev/urandom | tr -dc A-Z-a-z0-9_- | head -c 43)"

# Random UUID to identify the proxy instance
PROXY_UUID="$(cat /proc/sys/kernel/random/uuid)"

# Any name you like
PROXY_NAME="Xen Orchestra Proxy TEST"

# UUID of the VM running the proxy
PROXY_VM_UUID="<Proxy VM UUID>"

(
envsubst <<EOF
{
    "proxies": [
        {
            "authenticationToken": "$PROXY_AUTHENTICATION_TOKEN",
            "name":     "$PROXY_NAME",
            "vmUuid":   "$PROXY_VM_UUID",
            "id":       "$PROXY_UUID"
        }
    ]
}
EOF
) > proxy-config.json

```

### Environment Variables

#### `XO_PROXY_ENABLED`

Set this to `1` to run Xen Orchestra Proxy in this container.

Default: `0`

#### `XO_PROXY_AUTHENTICATION_TOKEN`

Authentication Token for this proxy. Must match the one in Xen Orchestra Config file.

Default: not set
