FROM fedora:37

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
        php-iconv \
        php-intl \
        php-mbstring \
        php-mysqlnd \
        php-opcache \
        php-pgsql \
        php-redis \
        php-xml \
        php-zip \
        php-fpm \
    && dnf update -y \
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

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
