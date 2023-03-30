ARG fedora_version
FROM fedora:${fedora_version}

ARG userid=3000
ARG groupid=3000

# speed up dnf (https://ostechnix.com/how-to-speed-up-dnf-package-manager-in-fedora/)
RUN echo 'max_parallel_downloads=10' >> /etc/dnf/dnf.conf

# add the application user
RUN groupadd -r -g ${groupid} appgroup \
    && useradd --no-create-home --no-log-init --system --home-dir=/app --uid ${userid} --gid ${groupid} appuser

RUN mkdir -p /app && chown -R appuser:appgroup /app

RUN dnf install -y \
        curl \
        unzip \
        supervisor \
        php-bcmath \
        php-cli \
        php-common \
        php-curl \
        php-fpm \
        php-gd \
        php-mysqlnd \
        php-opcache \
        php-pgsql \
        php-redis \
        php-soap \
        php-xml \
        php-zip \
    && dnf upgrade -y \
    && dnf clean all -y

# copy the files from the host to the container that we need
COPY etc/supervisord.conf /etc/supervisord.conf
COPY etc/supervisord.d /etc/supervisord.d
COPY etc/php-fpm/php-fpm.conf /etc/php-fpm.conf

# set the sockets and pid files to be writable by the appuser
RUN mkdir -p /var/run/php && touch /var/run/php/php-fpm.sock && chown -R appuser:appgroup /var/run/php

RUN touch /run/php-fpm.pid && chown -R appuser:appgroup /run/php-fpm.pid

RUN touch /run/supervisord.pid && chown -R appuser:appgroup /run/supervisord.pid

WORKDIR /app

USER appuser

# check the server configuration to make sure it can run Craft CMS
RUN curl -Lsf https://raw.githubusercontent.com/craftcms/server-check/HEAD/check.sh | bash

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
