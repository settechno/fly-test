FROM php:8.1-fpm-alpine

LABEL fly_launch_runtime="fly-test"

RUN set -eux ; \
    apk add --no-cache supervisor; \
    apk add --no-cache caddy --repository=https://dl-cdn.alpinelinux.org/alpine/latest-stable/community; \
    docker-php-ext-enable opcache

RUN curl -sS --compressed https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY docker/caddy/ /etc/caddy/
COPY docker/php/ ${PHP_INI_DIR}/
COPY docker/supervisor/supervisord.conf /etc/

COPY --chown=www-data:www-data composer.* ./

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_CACHE_DIR /dev/null

RUN composer install --no-autoloader --no-dev --no-interaction --no-scripts

COPY --chown=www-data:www-data . .

ARG APP_ENV

RUN set -eux ; \
    chmod -R -x+X . ;

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]