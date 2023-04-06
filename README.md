# Image

> NOTE: These images are still a work-in-progress and should not be used in production.

This repository hosts the code for building container images tailored for Craft CMS applications. Our aim is to offer an always up-to-date base image that developers can expand to run a web server of their choice. Our base image does not include an NGINX server and is exclusively configured to support running PHP-FPM. This setup enables developers to fully customize their container environments and maximize performance to meet their application needs (e.g. deploy with Caddy instead of NGINX). 

## Image

This repository contains the following image types:

1. `image` - The base image for all other images that installs PHP and creates a non-root user. This image also installs supervisord and NGINX but does not configure NGINX.

## Adding a new service to supervisor

In order to add a new service to supervisor, follow these steps:

1. Create a new service file ending in `.ini`.
2. Copy the new file during a build step in the `Dockerfile` (
   e.g. `COPY ./supervisor.d/craft-worker.ini /etc/supervisor.d/craft-worker.ini`).
3. Supervisor will automatically pick up the new service and start it.

## Examples

This repository contains examples for extending the container image to adapt to your use case. The examples are located in the `examples` folder.

## Testing

In order to test this image locally, follow these steps:

1. Install an app (Craft), into the `examples/nginx/local` folder (the
   webroot `web` is still expected and not dynamic yet). (_**Note**: If it is easier, create an `index.php`
   in `./examples/nginx/local/web` with `<?php phpinfo();` to verify configuration_).
2. Run the `make run` command which is a helper to `docker-compose up -d --build`.
3. Visit `http://localhost:8080` to verify the installation.

## Customizing PHP Settings

Some PHP settings may be customized by setting environment variables for the image.

In this example, we’re setting the PHP memory limit to `512M` rather than the default `256M`:

```yaml
version: "3.6"
services:
  php-fpm:
    image: ghcr.io/craftcms/image:8.1
    volumes:
      - .:/app
    env_file: .env
    environment:
      PHP_MEMORY_LIMIT: 512M
  # ... nginx and database services
```

### Customizable Settings

| PHP Setting                       | Environment Variable                  | Default Value |
| --------------------------------- | ------------------------------------- | ------------- |
| `memory_limit`                    | `PHP_MEMORY_LIMIT`                    | `256M`        |
| `max_execution_time`              | `PHP_MAX_EXECUTION_TIME`              | `120`         |
| `upload_max_filesize`             | `PHP_UPLOAD_MAX_FILESIZE`             | `20M`         |
| `max_input_vars`                  | `PHP_MAX_INPUT_VARS`                  | `1000`        |
| `post_max_size`                   | `PHP_POST_MAX_SIZE`                   | `8M`          |
| `opcache.enable`                  | `PHP_OPCACHE_ENABLE`                  | `1`           |
| `opcache.revalidate_freq`         | `PHP_OPCACHE_REVALIDATE_FREQ`         | `0`           |
| `opcache.validate_timestamps`     | `PHP_OPCACHE_VALIDATE_TIMESTAMPS`     | `0`           |
| `opcache.max_accelerated_files`   | `PHP_OPCACHE_MAX_ACCELERATED_FILES`   | `10000`       |
| `opcache.memory_consumption`      | `PHP_OPCACHE_MEMORY_CONSUMPTION`      | `256`         |
| `opcache.max_wasted_percentage`   | `PHP_OPCACHE_MAX_WASTED_PERCENTAGE`   | `10`          |
| `opcache.interned_strings_buffer` | `PHP_OPCACHE_INTERNED_STRINGS_BUFFER` | `16`          |
| `opcache.fast_shutdown`           | `PHP_OPCACHE_FAST_SHUTDOWN`           | `1`           |

## Upgrading Fedora

In order to update Fedora (e.g. Fedora 38 was released), follow these steps:

1. Update the `FEDORA_VERSION` in the `Makefile` to the new version (e.g. `FEDORA_VERSION=38`). This will update the
   base image used for the build.
2. Update the `PHP_VERSION` in the `Makefile` to the new version (e.g. `PHP_VERSION=8.2`). This will update the
   PHP version installed in the image.
3. Then, run `make build` to rebuild the image to test locally.

> Note: The version of Fedora determines the version of PHP that is installed. For example, Fedora 38 uses PHP 8.2 and Fedora 37 uses 8.1.


