# Jikan Docker

This repository provides a configuration for building the
[Jikan Rest](https://github.com/jikan-me/jikan-rest) Server as
PHP FastCGI module.

As base image `php:7-fpm-alpine` is used.

## About Volumes

As the application server (e.g. nginx) requires access to the files as well,
the actual code will be stored in side a volume.
To share the volume with the application server, use a named volume:

```yaml
version: '3'
services:
  jikan-service:
    image: nginx:alpine
    restart: unless-stopped
    volumes:
      - ./conf:/etc/nginx/conf.d
      - jikan-code:/app
    depends_on:
      - php
  php:
    image: registry.gitlab.com/thorbens/anime/jikan-docker
    restart: unless-stopped
    volumes:
      - jikan-code:/app
    depends_on:
      - redis
      - mysql
  [...]
```

The drawback of this method is that, unless the volume is deleted, a new
container image still uses the code.
The volume needs to be deleted explicitly before the container is updated. 

## Build local

Use the `docker-compose.yml` to setup a local instance with a Redis and
MySQL instance:

```shell script
docker-compose up
```

