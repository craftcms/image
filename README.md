# Cloud Image

This is the base image for the Craft Cloud images.

## S6 Overlay

These images also use the S6 overlay image which allows a different behavior than the typical Docker setup where when a process stops (nginx or php-fpm) the container exits. Instead, if the one of the application processes stops, s6 will try to restart it.

> See [The Docker Way?](https://github.com/just-containers/s6-overlay#the-docker-way) for more details on this approach.

## Ports

The only port exposed by the image is port 80 for nginx. Unlike the public images, the PHP-FPM port 9000 is not exposed.

## Environment Variables

This image also sets the `clear_env` option in php-fpm to `yes`. This ensures PHP-FPM cannot access environment variables that are specific to the underlying host (e.g. AWS specific information).

In order to add environment variables, the easiest method is to use the Docker `COPY` command to add a `zz-app-env.conf` to `/etc/php/8.0/fpm/pool.d/`.

### Example

```conf
# zz-app-env.conf
env[CUSTOM_ENV] = $CUSTOM_ENV;
env[HARDCODED_ENV] = hardcodedenv;
```

```Dockerfile
COPY zz-app-env.conf /etc/php/8.0/fpm/pool.d/
```

