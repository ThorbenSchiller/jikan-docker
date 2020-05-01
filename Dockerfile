# Use a build container to resolve dependencies
FROM composer:1.9.1 as composer

WORKDIR /app

COPY ./jikan-rest /app

# Run composer to build dependencies in vendor folder
RUN composer install --quiet --no-dev --no-scripts --no-suggest --no-interaction --prefer-dist --optimize-autoloader

# use specific version of jikan to get latest fixed.
# current jikan-rest is incompatible with an external redis :/
RUN composer require jikan-me/jikan:2.16.2 --quiet --update-no-dev --no-suggest --no-progress --prefer-dist

# Generated optimized autoload files containing all classes from vendor folder and project itself
RUN composer dump-autoload --no-dev --optimize --classmap-authoritative

# begin of main image
FROM php:7.3-apache

ENV APP_ENV=production
ENV APP_DEBUG=false
ENV APP_KEY=jikan-rest
ENV APP_TIMEZONE=UTC
ENV APP_URL=http://localhost

ENV CACHE_DRIVER=redis
ENV QUEUE_DRIVER=redis

ENV CACHE_METHOD=legacy
ENV CACHE_DEFAULT_EXPIRE=86400
ENV CACHE_META_EXPIRE=300
ENV CACHE_USER_EXPIRE=300
ENV CACHE_404_EXPIRE=604800
ENV CACHE_SEARCH_EXPIRE=432000

ENV MICROCACHING=true
ENV MICROCACHING_EXPIRE=5

ENV QUEUE_DELAY_PER_JOB=5

ENV THROTTLE=false
ENV THROTTLE_DECAY_MINUTES=1
ENV THROTTLE_MAX_PER_DECAY_MINUTES=30
ENV THROTTLE_MAX_PER_SECOND=2

ENV SLAVE_INSTANCE=false
ENV SLAVE_KEY=null
ENV SLAVE_CLIENT_IP_HEADER=X-Real-IP
ENV SLAVE_KEY_HEADER=X-Master

ENV REDIS_HOST=redis
ENV REDIS_PASSWORD=null
ENV REDIS_PORT=6379

ENV GITHUB_REPORTING=false
ENV GITHUB_REST=jikan-me/jikan-rest
ENV GITHUB_API=jikan-me/jikan

ENV APACHE_DOCUMENT_ROOT /app/public

RUN a2enmod rewrite

COPY --from=composer /app /app

RUN chown -R www-data:www-data /app

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
