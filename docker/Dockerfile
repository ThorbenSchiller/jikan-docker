FROM php:7-apache

# Expose apache.
EXPOSE 80

COPY ./docker/apache-config.conf /etc/apache2/sites-available/000-default.conf

# option to mount volume as cache
# VOLUME /app/cache
# set symlink
RUN ln -s /app/public/ /var/www/html/app

WORKDIR /app

RUN docker-php-ext-install mbstring pdo pdo_mysql

# Enable apache mods.
RUN a2enmod rewrite setenvif headers deflate filter expires