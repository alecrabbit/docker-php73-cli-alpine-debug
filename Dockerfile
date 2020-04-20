ARG REPO_OWNER=dralec
ARG REPO_IMAGE=php73-cli-alpine

FROM ${REPO_OWNER}/${REPO_IMAGE}

LABEL Description="DEV Application container w XDEBUG"

ARG XDEBUG_VERSION=2.9.4

ARG PHP_BUILD_DEPS="\
    autoconf \
    cmake \
    file \
    g++ \
    make \
    gcc"

ARG COMPOSER_HOME=/tmp/composer

RUN set -xe \
    && \
    apk add --no-cache --virtual .php-build-deps ${PHP_BUILD_DEPS} \
    && pecl install xdebug-${XDEBUG_VERSION} \
    && docker-php-ext-enable xdebug \
    && echo 'xdebug.cli_color=1' > /usr/local/etc/php/conf.d/xdebug.ini \
    && apk del --no-cache .php-build-deps \
    && composer --no-interaction global --prefer-stable require 'squizlabs/php_codesniffer' \
    && composer --no-interaction global --prefer-stable require 'phpmetrics/phpmetrics' \
    && composer --no-interaction global --prefer-stable require 'phpstan/phpstan' \
    && composer --no-interaction global --prefer-stable require 'edgedesign/phpqa' \
    && composer --no-interaction global --prefer-stable require 'vimeo/psalm' \
    && composer --no-interaction global --prefer-stable require 'sensiolabs/security-checker' \
    && composer --no-interaction global --prefer-stable require 'kylekatarnls/multi-tester' \
    && composer --no-interaction global --prefer-stable require 'innmind/dependency-graph' \
    # && composer --no-interaction global --prefer-stable require 'mamuz/php-dependency-analysis' \
    && composer --no-interaction global --prefer-stable require 'friendsofphp/php-cs-fixer' \
    && composer clear-cache \
    && rm -rf ${COMPOSER_HOME}/.htaccess ${COMPOSER_HOME}/cache \
    && php -v \
    && php -m

ENV PS1='🐳 \[\033[1;36m\]\D{%F} \[\033[0;33m\]\t \[\033[0;32m\][\[\033[1;34m\]\u\[\033[1;97m\]@\[\033[1;91m\]\h\[\033[0;32m\]] \[\033[0;95m\]\w \[\033[1;36m\]#\[\033[0m\] '


COPY ./patch/bin/multi-tester /tmp/vendor/bin/multi-tester
COPY ./patch/src/. ${COMPOSER_HOME}/vendor/kylekatarnls/multi-tester/src/MultiTester/.

WORKDIR /var/www
ENTRYPOINT []
