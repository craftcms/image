FROM ubuntu:22.04

ARG php_version

ENV DEBIAN_FRONTEND=noninteractive \
    APPUSER_HOME="/app" \
    PUID=3000 \
    PGID=3000

RUN apt-get update \
    && mkdir /app \
    && groupadd -r -g $PGID appgroup \
    && useradd --no-log-init -r -s /usr/bin/bash -d $APPUSER_HOME -u $PUID -g $PGID appuser \
    && apt-get install -y --no-install-recommends gnupg \
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu jammy main" > /etc/apt/sources.list.d/ondrej-php.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        xz-utils \
        ca-certificates \
        curl \
        unzip \
        php${php_version}-bcmath \
        php${php_version}-cli \
        php${php_version}-common \
        php${php_version}-curl \
        php${php_version}-gd \
        php${php_version}-iconv \
        php${php_version}-intl \
        php${php_version}-mbstring \
        php${php_version}-mysql \
        php${php_version}-opcache \
        php${php_version}-pgsql \
        php${php_version}-redis \
        php${php_version}-soap \
        php${php_version}-xml \
        php${php_version}-zip \
        php${php_version}-fpm \
        nginx \
    && apt-get upgrade -y \
    && apt-get clean \
    && chown -R appuser:appgroup /app/ \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

ADD https://github.com/just-containers/s6-overlay/releases/download/v3.1.0.1/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.1.0.1/s6-overlay-aarch64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-aarch64.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.1.0.1/s6-overlay-symlinks-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz

COPY etc/s6-overlay/s6-rc.d /etc/s6-overlay/s6-rc.d
COPY etc/nginx/ /etc/nginx/
COPY etc/php/fpm/pool.d/ /etc/php/${php_version}/fpm/pool.d/
COPY etc/php/fpm/opcache.ini /etc/php/${php_version}/fpm/conf.d/opcache.ini

ENTRYPOINT [ "/init" ]

WORKDIR /app

HEALTHCHECK --start-period=5s \
  CMD curl -f http://127.0.0.1:9000/ping/ || exit 1
