FROM dralec/php73-cli-alpine
LABEL Description="Application container"

ENV PHP_XDEBUG_VERSION 2.7.0

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
    && echo 'xdebug.cli_color=1' > /usr/local/etc/php/conf.d/xdebug.ini \
    && apk del .build-deps \
    && composer --no-interaction global --prefer-stable require 'squizlabs/php_codesniffer' \
    && composer --no-interaction global --prefer-stable require 'phpmetrics/phpmetrics' \
    && composer --no-interaction global --prefer-stable require 'phpstan/phpstan' \
    && composer --no-interaction global --prefer-stable require 'phpunit/phpunit' \
    && composer --no-interaction global --prefer-stable require 'vimeo/psalm' \
    && composer --no-interaction global --prefer-stable require 'sensiolabs/security-checker' \
    && composer --no-interaction global --prefer-stable require 'kylekatarnls/multi-tester' \
    && composer --no-interaction global --prefer-stable require 'innmind/dependency-graph' \
    && composer --no-interaction global --prefer-stable require 'mamuz/php-dependency-analysis' \
    && composer --no-interaction global --prefer-stable require 'jakub-onderka/php-var-dump-check' \
    && composer --no-interaction global --prefer-stable require 'jakub-onderka/php-console-highlighter' \
    && composer clear-cache

WORKDIR /var/www
ENTRYPOINT []
CMD []
