FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    APPUSER_HOME="/app" \
    PUID=3000 \
    PGID=3000

RUN apt-get update \
    && mkdir /app \
    && groupadd -r -g $PGID appgroup \
    && useradd --no-log-init -r -s /usr/bin/bash -d $APPUSER_HOME -u $PUID -g $PGID appuser \
    && apt-get install -y --no-install-recommends gnupg \
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu focal main" > /etc/apt/sources.list.d/ondrej-php.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        xz-utils \
        ca-certificates \
        curl \
        unzip \
        php8.0-cli \
        php8.0-common \
        php8.0-curl \
        php8.0-gd \
        php8.0-iconv \
        php8.0-intl \
        php8.0-mbstring \
        php8.0-mysql \
        php8.0-opcache \
        php8.0-pgsql \
        php8.0-redis \
        php8.0-soap \
        php8.0-xml \
        php8.0-zip \
        php8.0-fpm \
        nginx \
    && apt-get upgrade -y \
    && apt-get clean \
    && chown -R appuser:appgroup /app/ \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

ADD https://github.com/just-containers/s6-overlay/releases/download/v3.0.0.0-1/s6-overlay-noarch-3.0.0.0-1.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch-3.0.0.0-1.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.0.0.0-1/s6-overlay-aarch64-3.0.0.0-1.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-aarch64-3.0.0.0-1.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.0.0.0-1/s6-overlay-symlinks-noarch-3.0.0.0-1.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch-3.0.0.0-1.tar.xz

# Copy over S6 configurations
COPY etc/s6-overlay/s6-rc.d /etc/s6-overlay/s6-rc.d
COPY etc/nginx/ /etc/nginx/

# Apply PHP configuration files
COPY etc/php/fpm/pool.d/ /etc/php/8.0/fpm/pool.d/
ENTRYPOINT [ "/init" ]

HEALTHCHECK --start-period=5s \
  CMD curl -f http://127.0.0.1:9000/ping/ || exit 1
EXPOSE 80
