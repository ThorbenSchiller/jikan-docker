# Jikan Docker

This repository provides a configuration for building the
[Jikan Rest](https://github.com/jikan-me/jikan-rest) server relying on
`php:7.3-apache` as base image.

## Example

[Jikan Rest](https://github.com/jikan-me/jikan-rest) relies currently on redis,
so include a redis service as well:

```yaml
version: '3'
services:
  jikan-service:
    image: registry.gitlab.com/thorbens/anime/jikan-docker
    restart: unless-stopped
  redis:
    image: redis:5-alpine
    restart: unless-stopped
```

For further configuration, you may mount your own `.env` file.
Take a look at the [.env.dist](https://github.com/jikan-me/jikan-rest/blob/master/.env.dist) for further information. 

## Build local

Use the `docker-compose.yml` to set up a local instance with a Redis instance:

```shell script
docker-compose up
```

