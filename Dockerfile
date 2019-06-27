FROM php:7.1-fpm-alpine

LABEL authors="Hannes Papenberg"

RUN apk --no-cache add zlib-dev libpng-dev postgresql-dev autoconf gcc composer

RUN docker-php-ext-install gd mysqli pdo_mysql pgsql pdo_pgsql

RUN docker-php-ext-enable memcache

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev
RUN apk add --no-cache --update libmemcached-libs zlib
RUN set -xe \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --update --virtual .memcached-deps $MEMCACHED_DEPS \
    && pecl install memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20_memcached.ini \
    && rm -rf /usr/share/php7 \
    && rm -rf /tmp/* \
    && apk del .memcached-deps .phpize-deps

RUN apk add --no-cache --update gcc make autoconf libc-dev \
	&& pecl install redis \
	&& docker-php-ext-enable redis
