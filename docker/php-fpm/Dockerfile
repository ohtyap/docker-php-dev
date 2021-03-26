ARG PHP_VERSION=8.0
FROM php:${PHP_VERSION}-fpm-alpine

# Install php extension installer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

ARG INSTALL_INTL=false
ARG INSTALL_OPCACHE=false
ARG INSTALL_XDEBUG=false
ARG INSTALL_REDIS=false
ARG INSTALL_MONGO=false
ARG INSTALL_PDO_MYSQL=false
ARG INSTALL_PDO_PGSQL=false
ARG INSTALL_EXIF=false
ARG INSTALL_GD=false
ARG INSTALL_IMAGICK=false
ARG INSTALL_XHPROF=false

USER root
RUN set -eux; \
    apk add --no-cache --virtual .build-deps pcre-dev ${PHPIZE_DEPS}; \
    php_ext="zip"; \
    if [ ${INSTALL_OPCACHE} = true ]; then \
        php_ext="opcache ${php_ext}"; \
    fi; \
    if [ ${INSTALL_EXIF} = true ]; then \
            php_ext="exif ${php_ext}"; \
    fi; \
    if [ ${INSTALL_GD} = true ]; then \
            php_ext="gd ${php_ext}"; \
    fi; \
    if [ ${INSTALL_IMAGICK} = true ]; then \
            php_ext="imagick ${php_ext}"; \
    fi; \
    if [ ${INSTALL_XHPROF} = true ]; then \
            php_ext="xhprof ${php_ext}"; \
    fi; \
    if [ ${INSTALL_INTL} = true ]; then \
        php_ext="intl ${php_ext}"; \
    fi; \
    if [ ${INSTALL_PDO_MYSQL} = true ]; then \
        php_ext="pdo_mysql ${php_ext}"; \
    fi; \
    if [ ${INSTALL_PDO_PGSQL} = true ]; then \
        php_ext="pdo_pgsql ${php_ext}"; \
    fi; \
    if [ ${INSTALL_XDEBUG} = true ]; then \
        if [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ]; then \
            php_ext="xdebug-^2.9 ${php_ext}"; \
        else \
            php_ext="xdebug ${php_ext}"; \
        fi; \
    fi; \
    if [ ${INSTALL_REDIS} = true ]; then \
        php_ext="redis ${php_ext}"; \
    fi; \
    if [ ${INSTALL_MONGO} = true ]; then \
        php_ext="mongodb ${php_ext}"; \
    fi; \
    install-php-extensions ${php_ext}; \
    cp $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini; \
    apk del --no-cache --no-network .build-deps; \
    adduser --disabled-password develop;

EXPOSE 9000
CMD ["php-fpm"]
