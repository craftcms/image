# Image

> NOTE: These images are still a work-in-progress and should not be used in production.

This repository hosts the code for building container images tailored for Craft CMS applications. Our aim is to offer an always up-to-date base image that developers can expand to run a web server of their choice. Our base image does not include an NGINX server and is exclusively configured to support running PHP-FPM. This setup enables developers to fully customize their container environments and maximize performance to meet their application needs (e.g. deploy with Caddy instead of NGINX). 

## Image Types

This repository contains the following image types:

1. `base` - The base image for all other images that installs PHP and creates a non-root user.
2. `web` - The web image that extends the base image and installs Nginx.

## Adding a new service to supervisor

In order to add a new service to supervisor, follow these steps:

1. Create a new service file ending in `.ini`.
2. Copy the new file during a build step in the `Dockerfile` (
   e.g. `COPY ./supervisor.d/craft-worker.ini /etc/supervisor.d/craft-worker.ini`).
3. Supervisor will automatically pick up the new service and start it.

## Testing

In order to test this image locally, follow these steps:

1. Install an app (Craft), into the `local` folder (the
   webroot `web` is still expected and not dynamic yet). (_**Note**: If it is easier, create an `index.php`
   in `./local/web` with `<?php phpinfo();` to verify configuration_).
2. Run the `make run` command which is a helper to `docker-compose up -d --build`.
3. Visit `http://localhost:8080` to verify the installation.

## Upgrading Fedora

In order to update Fedora (e.g. Fedora 38 was released), follow these steps:

1. Update the `FEDORA_VERSION` in the `Makefile` to the new version (e.g. `FEDORA_VERSION=38`). This will update the
   base image used for the build.
2. Update the `PHP_VERSION` in the `Makefile` to the new version (e.g. `PHP_VERSION=8.2`). This will update the
   PHP version installed in the image.
3. Then, run `make build` to rebuild the image to test locally.

> Note: The version of Fedora determines the version of PHP that is installed. For example, Fedora 38 uses PHP 8.2 and Fedora 37 uses 8.1.


