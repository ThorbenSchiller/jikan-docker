FROM php:7.3-apache

# Expose apache.
EXPOSE 80

COPY ./apache-config.conf /etc/apache2/sites-available/000-default.conf

# option to mount volume as cache
# VOLUME /app/cache
# set symlink
RUN ln -s /app/public/ /var/www/html/app
# copy source files
COPY ./jikan-rest /app
# set rights
RUN chown -R www-data:www-data /app
# install system dependencies for composer
RUN apt-get update \
    && apt-get install -y libzip-dev git \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install zip
# install php extensions
RUN docker-php-ext-install mbstring pdo pdo_mysql zip
# set work dir
WORKDIR /app
# install composer
RUN curl --silent --show-error https://getcomposer.org/installer | php
# install dependencies
RUN ./composer.phar install --no-ansi --no-suggest --no-dev --no-interaction --no-progress --no-scripts --optimize-autoloader
# remove composer
RUN rm composer.phar
# Enable apache mods.
RUN a2enmod rewrite deflate
