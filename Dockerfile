FROM dralec/php-cli-alpine
LABEL Description="Application container"

ENV PHP_XDEBUG_VERSION 2.6.1

# persistent / runtime deps
ENV PHPIZE_DEPS \
    autoconf \
    cmake \
    file \
    g++ \
    gcc \
    libc-dev \
    pcre-dev \
    make \
    pkgconf \
    re2c \
    # for GD
    freetype-dev \
    libpng-dev  \
    libjpeg-turbo-dev \
    libxslt-dev

RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
    && pecl install xdebug-${PHP_XDEBUG_VERSION} \
    && docker-php-ext-enable xdebug \
    && apk del .build-deps \
    && composer --no-interaction global require 'squizlabs/php_codesniffer' \
    && composer --no-interaction global require 'phpmetrics/phpmetrics' \
    && composer --no-interaction global require 'phpstan/phpstan' \
    && composer --no-interaction global require 'phpunit/phpunit' \
    && composer --no-interaction global require 'vimeo/psalm' \
    && composer clear-cache

WORKDIR /var/www
ENTRYPOINT []
CMD []
