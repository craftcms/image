# Contributing

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
