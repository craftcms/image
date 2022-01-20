FROM ubuntu:20.04
ARG S6_VERSION="v2.2.0.3"
ARG S6_ARCH="aarch64"
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}-installer /tmp
RUN chmod +x /tmp/s6-overlay-${S6_ARCH}-installer && /tmp/s6-overlay-${S6_ARCH}-installer / && rm /tmp/s6-overlay-${S6_ARCH}-installer

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
        ca-certificates \
        curl \
        unzip \
        php8.0-cli \
        php8.0-common \
        php8.0-curl \
        php8.0-gd \
        php8.0-mbstring \
        php8.0-mysql \
        php8.0-redis \
        php8.0-soap \
        php8.0-xml \
        php8.0-zip \
        php8.0-fpm \
        nginx \
    && apt-get clean \
    && chown -R appuser:appgroup /app/ \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Copy over S6 configurations
COPY etc/services.d/ /etc/services.d/
COPY etc/nginx/ /etc/nginx/

# Apply PHP configuration files
COPY etc/php/fpm/pool.d/ /etc/php/8.0/fpm/pool.d/
ENTRYPOINT [ "/init" ]
HEALTHCHECK --start-period=5s \
  CMD curl -f http://127.0.0.1:9000/ping/ || exit 1
EXPOSE 80
