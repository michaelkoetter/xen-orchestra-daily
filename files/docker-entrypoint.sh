#!/bin/sh

/confd -onetime -backend env && \
    exec /xen-orchestra/packages/xo-server/bin/xo-server $@