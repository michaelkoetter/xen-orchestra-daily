#############################################################################
FROM node:14-buster AS build

ARG TARGETOS
ARG TARGETARCH
ARG XO_COMMIT
ARG XO_VERSION

RUN apt-get update && apt-get install -y build-essential libpng-dev git python-minimal

WORKDIR /home/node

RUN git clone --depth 1 https://github.com/vatesfr/xen-orchestra/ && \
    cd /home/node/xen-orchestra && \
    git reset --hard ${XO_COMMIT} && \
    rm -rf .git && \
    yarn config set network-timeout 60000 -g && \
    yarn && \
    yarn build

RUN cd /home/node/xen-orchestra/packages/xo-server/node_modules && \
    ln -s ../../xo-server-audit \
        ../../xo-server-auth-github \
        ../../xo-server-auth-google \
        ../../xo-server-auth-ldap \
        ../../xo-server-auth-saml \
        ../../xo-server-backup-reports \
        ../../xo-server-load-balancer \
        ../../xo-server-netbox \
        ../../xo-server-perf-alert \
        ../../xo-server-sdn-controller \
        ../../xo-server-transport-email \
        ../../xo-server-transport-icinga2 \
        ../../xo-server-transport-nagios \
        ../../xo-server-transport-slack \
        ../../xo-server-transport-xmpp \
        ../../xo-server-usage-report \
        ../../xo-server-web-hooks \
        .

#############################################################################
FROM node:14-buster

MAINTAINER Michael Kötter <michael@m-koetter.de>

ARG TARGETOS
ARG TARGETARCH

ENV XO_HTTP_PORT=80
ENV XO_REDIS_URI=redis://redis:6379/0
ENV NODE_ENV=production
ENV XOA_PLAN=5

RUN apt-get update && apt-get install -y libvhdi-utils lvm2 cifs-utils

COPY --from=build /home/node/xen-orchestra /xen-orchestra

RUN mkdir -p /etc/xo-server /etc/confd/{conf.d,templates}

RUN curl -Lo /confd https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-${TARGETOS}-${TARGETARCH} && \
    chmod +x /confd

COPY files/config.toml.tmpl /etc/confd/templates/
COPY files/xo-server-config.toml /etc/confd/conf.d/
COPY files/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
