1. Make sure the submodule is initialized: `git submodule init && git submodule update`
1. Rename `.env.sample` to `.env` in root directory and may adjust to your needs.
1. Rename `.env.dist` to `.env` in jikan-rest submodule.
1. Set database and redis host to docker services in `.env`:
```
DB_CONNECTION=mysql
REDIS_HOST=redis
```
