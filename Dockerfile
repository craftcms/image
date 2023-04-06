ARG fedora_version
FROM fedora:${fedora_version}

ARG userid=3000
ARG groupid=3000

# setup general options for environment variables
ARG PHP_MEMORY_LIMIT_ARG="256M"
ENV PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT_ARG}
ARG PHP_MAX_EXECUTION_TIME_ARG="120"
ENV PHP_MAX_EXECUTION_TIME=${PHP_MAX_EXECUTION_TIME_ARG}
ARG PHP_UPLOAD_MAX_FILESIZE_ARG="20M"
ENV PHP_UPLOAD_MAX_FILESIZE=${PHP_UPLOAD_MAX_FILESIZE_ARG}
ARG PHP_MAX_INPUT_VARS_ARG="1000"
ENV PHP_MAX_INPUT_VARS=${PHP_MAX_INPUT_VARS_ARG}
ARG PHP_POST_MAX_SIZE_ARG="8M"
ENV PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE_ARG}

# setup opcache for environment variables
ARG PHP_OPCACHE_ENABLE_ARG="1"
ARG PHP_OPCACHE_REVALIDATE_FREQ_ARG="0"
ARG PHP_OPCACHE_VALIDATE_TIMESTAMPS_ARG="0"
ARG PHP_OPCACHE_MAX_ACCELERATED_FILES_ARG="10000"
ARG PHP_OPCACHE_MEMORY_CONSUMPTION_ARG="128"
ARG PHP_OPCACHE_MAX_WASTED_PERCENTAGE_ARG="10"
ARG PHP_OPCACHE_INTERNED_STRINGS_BUFFER_ARG="16"
ARG PHP_OPCACHE_FAST_SHUTDOWN_ARG="1"
ENV PHP_OPCACHE_ENABLE=$PHP_OPCACHE_ENABLE_ARG
ENV PHP_OPCACHE_REVALIDATE_FREQ=$PHP_OPCACHE_REVALIDATE_FREQ_ARG
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=$PHP_OPCACHE_VALIDATE_TIMESTAMPS_ARG
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES=$PHP_OPCACHE_MAX_ACCELERATED_FILES_ARG
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=$PHP_OPCACHE_MEMORY_CONSUMPTION_ARG
ENV PHP_OPCACHE_MAX_WASTED_PERCENTAGE=$PHP_OPCACHE_MAX_WASTED_PERCENTAGE_ARG
ENV PHP_OPCACHE_INTERNED_STRINGS_BUFFER=$PHP_OPCACHE_INTERNED_STRINGS_BUFFER_ARG
ENV PHP_OPCACHE_FAST_SHUTDOWN=$PHP_OPCACHE_FAST_SHUTDOWN_ARG

# speed up dnf (https://ostechnix.com/how-to-speed-up-dnf-package-manager-in-fedora/)
RUN echo 'max_parallel_downloads=10' >> /etc/dnf/dnf.conf

# add the application user
RUN groupadd -r -g ${groupid} appgroup \
    && useradd --no-create-home --no-log-init --system --home-dir=/app --uid ${userid} --gid ${groupid} appuser

RUN mkdir -p /app && chown -R appuser:appgroup /app

RUN dnf --disablerepo=fedora-cisco-openh264 install -y \
        curl \
        unzip \
        nginx \
        supervisor \
        php-bcmath \
        php-cli \
        php-common \
        php-curl \
        php-fpm \
        php-gd \
        php-iconv \
        php-intl \
        php-mbstring \
        php-mysqlnd \
        php-opcache \
        php-pgsql \
        php-redis \
        php-soap \
        php-xml \
        php-zip \
    && dnf --disablerepo=fedora-cisco-openh264 update -y \
    && dnf --disablerepo=fedora-cisco-openh264 clean all -y

# copy the files from the host to the container that we need
COPY etc/supervisord.conf /etc/supervisord.conf
COPY etc/supervisord.d /etc/supervisord.d
COPY etc/php-fpm/php-fpm.conf /etc/php-fpm.conf
COPY etc/php.d/60-craftcms.ini /etc/php.d/60-craftcms.ini

# set the sockets and pid files to be writable by the appuser
RUN mkdir -p /var/run/php && touch /var/run/php/php-fpm.sock && chown -R appuser:appgroup /var/run/php

RUN touch /run/php-fpm.pid && chown -R appuser:appgroup /run/php-fpm.pid

RUN touch /run/supervisord.pid && chown -R appuser:appgroup /run/supervisord.pid

WORKDIR /app

USER appuser

# check the server configuration to make sure it can run Craft CMS
RUN curl -Lsf https://raw.githubusercontent.com/craftcms/server-check/HEAD/check.sh | bash

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
