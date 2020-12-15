ARG PHP_VERSION=8.0
FROM php:${PHP_VERSION}-cli-alpine

ARG INSTALL_INTL=true
ARG INSTALL_OPCACHE=true
ARG INSTALL_XDEBUG=true
ARG INSTALL_REDIS=true
ARG INSTALL_MONGO=true
ARG INSTALL_PDO_MYSQL=true
ARG INSTALL_PDO_PGSQL=true

RUN apk add --no-cache --virtual .build-deps pcre-dev ${PHPIZE_DEPS}; \
dependencies="supervisor" && configureExt="" && installExt="" && enableExt="" && dependencyUninstall="";  \
if [ ${INSTALL_INTL} = true ]; then \
    dependencies="icu-dev ${dependencies}" && configureExt="intl ${configureExt}" && installExt="intl ${installExt}"; \
fi; \
if [ ${INSTALL_PDO_MYSQL} = true ]; then \
    installExt="pdo_mysql ${installExt}"; \
fi; \
if [ ${INSTALL_PDO_PGSQL} = true ]; then \
    dependencies="postgresql-libs postgresql-dev ${dependencies}" && dependencyUninstall="postgresql-dev ${dependencyUninstall}" && installExt="pdo_pgsql ${installExt}"; \
fi; \
if [ ${INSTALL_OPCACHE} = true ]; then \
    enableExt="opcache ${enableExt}"; \
fi; \
if [ ${INSTALL_XDEBUG} = true ]; then \
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ]; then \
        pecl install xdebug-2.9.0; \
    else \
        pecl install xdebug; \
    fi \
    && enableExt="xdebug ${enableExt}"; \
fi; \
if [ ${INSTALL_REDIS} = true ]; then \
    pecl install -o -f redis && enableExt="redis ${enableExt}"; \
fi; \
if [ ${INSTALL_MONGO} = true ]; then \
    pecl install mongodb && enableExt="mongodb ${enableExt}"; \
fi; \
if [ "${dependencies}"  != "" ]; then \
    apk add --no-cache ${dependencies}; \
fi; \
if [ "${configureExt}"  != "" ]; then \
    docker-php-ext-configure ${configureExt}; \
fi; \
if [ "${installExt}" != "" ]; then \
    docker-php-ext-install ${installExt}; \
fi; \
if [ "${enableExt}"  != "" ]; then \
    docker-php-ext-enable ${enableExt} ; \
fi; \
if [ "${dependencyUninstall}"  != "" ]; then \
    apk del --no-cache --no-network ${dependencyUninstall}; \
fi; \
apk del --no-cache --no-network .build-deps;

COPY supervisord.conf /etc/supervisord.conf
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]
WORKDIR /etc/supervisor/conf.d/