#!/bin/sh

/confd -onetime -backend env && \
    exec /xen-orchestra/packages/xo-server/dist/cli.mjs $@
