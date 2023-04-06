ARG image=ghcr.io/craftcms/image
ARG php_version
FROM ${image}:${php_version}

USER root

# copy the files from the host to the container that we need
COPY etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY etc/supervisord.d/nginx.ini /etc/supervisord.d/nginx.ini

# set the sockets and pid files to be writable by the appuser
RUN mkdir -p /var/log/nginx && chown -R appuser:appgroup /var/log/nginx
RUN chown -R appuser:appgroup /var/lib/nginx && touch /run/nginx.pid && chown -R appuser:appgroup /run/nginx.pid

USER appuser