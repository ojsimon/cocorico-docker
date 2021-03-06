FROM php:5.6-fpm
MAINTAINER ADIL YASSINE <me@adilyassine.com>

ARG PHP_APCU_VERSION=4.0.11
ARG PHP_XDEBUG_VERSION=2.4.1

RUN apt-get update \
    && apt-get install -y \
        libicu-dev \
        php5-imagick \
        zlib1g-dev \
        php5-dev php5-cli php-pear mysql-client mcrypt \
        libmagickwand-dev --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install mongo \
    && pecl install imagick \
    && docker-php-source extract \
    && curl -L -o /tmp/apcu-$PHP_APCU_VERSION.tgz https://pecl.php.net/get/apcu-$PHP_APCU_VERSION.tgz \
    && curl -L -o /tmp/xdebug-$PHP_XDEBUG_VERSION.tgz http://xdebug.org/files/xdebug-$PHP_XDEBUG_VERSION.tgz \
    && tar xfz /tmp/apcu-$PHP_APCU_VERSION.tgz \
    && tar xfz /tmp/xdebug-$PHP_XDEBUG_VERSION.tgz \
    && rm -r \
        /tmp/apcu-$PHP_APCU_VERSION.tgz \
        /tmp/xdebug-$PHP_XDEBUG_VERSION.tgz \
    && mv apcu-$PHP_APCU_VERSION /usr/src/php/ext/apcu \
    && mv xdebug-$PHP_XDEBUG_VERSION /usr/src/php/ext/xdebug \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install \
        apcu \
        intl \
        mbstring \
        mysqli \
        xdebug \
        zip \
        pdo_mysql \
        fileinfo \
    && docker-php-source delete \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +sx /usr/local/bin/composer

EXPOSE 9000
