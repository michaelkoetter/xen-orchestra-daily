#############################################################################
FROM node:18-bookworm AS build

ARG TARGETOS
ARG TARGETARCH
ARG XO_COMMIT
ARG XO_VERSION

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    libpng-dev \
    python3-minimal \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home/node

COPY files/proxy.patch /tmp

RUN git clone --depth 1 https://github.com/vatesfr/xen-orchestra/ && \
    cd /home/node/xen-orchestra && \
    git reset --hard ${XO_COMMIT} && \
    rm -rf .git && \
    patch -p1 --fuzz=0 --no-backup-if-mismatch < /tmp/proxy.patch && \
    yarn config set network-timeout 60000 -g && \
    yarn && \
    yarn build

RUN cd /home/node/xen-orchestra/packages/xo-server/node_modules && \
    ln -s ../../xo-server-audit \
        ../../xo-server-auth-github \
        ../../xo-server-auth-google \
        ../../xo-server-auth-ldap \
        ../../xo-server-auth-oidc \
        ../../xo-server-auth-saml \
        ../../xo-server-backup-reports \
        ../../xo-server-load-balancer \
        ../../xo-server-netbox \
        ../../xo-server-perf-alert \
        ../../xo-server-sdn-controller \
        ../../xo-server-test-plugin \
        ../../xo-server-test \
        ../../xo-server-transport-email \
        ../../xo-server-transport-icinga2 \
        ../../xo-server-transport-nagios \
        ../../xo-server-transport-slack \
        ../../xo-server-transport-xmpp \
        ../../xo-server-usage-report \
        ../../xo-server-web-hooks \
        .

#############################################################################
FROM node:18-bookworm

MAINTAINER Michael Kötter <michael@m-koetter.de>

ARG TARGETOS
ARG TARGETARCH
ARG XO_COMMIT
ARG XO_VERSION

ENV XO_SERVER_REDIS_URI=redis://redis:6379/0
ENV XO_PROXY_ENABLED=0
ENV XO_PROXY_AUTHENTICATION_TOKEN=
ENV NODE_ENV=production
ENV XOA_PLAN=5

RUN apt-get update && apt-get install -y \
    cifs-utils \
    gettext-base \
    libvhdi-utils \
    lvm2 \
    nfs-common \
    xenstore-utils \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /home/node/xen-orchestra /xen-orchestra
COPY files/docker-entrypoint /docker-entrypoint
EXPOSE 80/tcp
EXPOSE 443/tcp
ENTRYPOINT [ "/docker-entrypoint" ]
