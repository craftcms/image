# Image

> NOTE: These images are still a work-in-progress and should not be used in production.

This repository contains the code for building container images for Craft CMS.

## S6 Overlay

These images also use the S6 overlay image which allows a different behavior than the typical Docker setup where when a process stops (nginx or php-fpm) the container exits. Instead, if the one of the application processes stops, s6 will try to restart it.

> See [The Docker Way?](https://github.com/just-containers/s6-overlay#the-docker-way) for more details on this approach.

## Ports

The only port exposed by the image is port 80 for nginx. Unlike the previous images, the PHP-FPM port 9000 is not exposed.

## Environment Variables

This image also sets the `clear_env` option in php-fpm to `yes`. This ensures PHP-FPM cannot access environment variables that are specific to the underlying host (e.g. AWS specific information).

In order to add environment variables, the easiest method is to use the Docker `COPY` command to add a `zz-app-env.conf` to `/etc/php/8.0/fpm/pool.d/`.

### Example

Create a file in the project directory named `zz-app-env.conf` (technically you can name this anything).

```conf
# zz-app-env.conf
env[CUSTOM_ENV] = $CUSTOM_ENV;
env[HARDCODED_ENV] = hardcodedenv;
```

> Note: You can use an existing environment variable that is in the system or hardcode a value.

During the build process, copy the configuration file with the envs into the correct path.

```Dockerfile
COPY zz-app-env.conf /etc/php/8.0/fpm/pool.d/
```

## Testing

In order to test this image locally, follow these steps:

1. Install an app (Craft), into the `local` folder of the version you are working on (e.g. `./php8.0/local`) (the webroot `web` is still expected and not dynamic yet). (_**Note**: If it is easier, create an `index.php` in `./php8.0/local/web` with `<?php phpinfo();` to verify configuration_).
2. Run the `make run` command which is a helper to `docker-compose up -d --build`.
3. Visit `http://localhost:8080` to verify the installation.

## Upgrading Ubuntu

In order to update Ubuntu (e.g. 22.04 was released), follow these steps:

In each `php<version>` directory, update the `FROM` in the `Dockerfile` to use the latest Ubuntu version.

```Dockerfile
FROM ubuntu:22.04
```

Find the PPA line in the `Dockerfile` and update it to use the latest Ubuntu version codename (e.g. `jammy`).

```Dockerfile
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu jammy main" > /etc/apt/sources.list.d/ondrej-php.list \
```

> Note: Ensure that the [ondrej/php](https://launchpad.net/~ondrej/+archive/ubuntu/php) PPA is available for the Ubuntu version. There may be a delay between the Ubuntu release and the PPA being available.

Then, run `make build` to rebuild the image to test locally.
