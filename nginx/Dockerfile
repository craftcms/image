FROM craftcms/base:8.1

ARG userid=3000
ARG groupid=3000

RUN dnf install -y \
        nginx \
    && dnf update -y \
    && dnf clean all -y

# copy the files from the host to the container that we need
COPY etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY etc/supervisord.d/nginx.ini /etc/supervisord.d/nginx.ini

# set the sockets and pid files to be writable by the appuser
RUN mkdir -p /var/log/nginx && chown -R apputser:appgroup /var/log/nginx

RUN chown -R appuser:appgroup /var/lib/nginx && touch /run/nginx.pid && chown -R appuser:appgroup /run/nginx.pid
