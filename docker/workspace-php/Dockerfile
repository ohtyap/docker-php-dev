ARG PHP_VERSION=8.0
FROM php:${PHP_VERSION}-cli-buster

ARG INSTALL_INTL=true
ARG INSTALL_OPCACHE=true
ARG INSTALL_XDEBUG=true
ARG INSTALL_REDIS=true
ARG INSTALL_MONGO=true
ARG INSTALL_PDO_MYSQL=true
ARG INSTALL_PDO_PGSQL=true
USER root
RUN set -eux; \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        locales \
        libpq-dev \
        openssh-client \
        git \
        curl \
        vim \
        zsh \
        zsh-syntax-highlighting \
        zsh-autosuggestions; \
    locale-gen en_US.UTF-8; \
    if [ ${INSTALL_OPCACHE} = true ]; then \
        docker-php-ext-enable opcache; \
    fi; \
    if [ ${INSTALL_INTL} = true ]; then \
        apt-get install -y --no-install-recommends  libicu-dev && docker-php-ext-configure intl && docker-php-ext-install intl; \
    fi; \
    if [ ${INSTALL_PDO_MYSQL} = true ]; then \
        docker-php-ext-install pdo_mysql; \
    fi; \
    if [ ${INSTALL_PDO_PGSQL} = true ]; then \
        docker-php-ext-install pdo_pgsql; \
    fi; \
    if [ ${INSTALL_XDEBUG} = true ]; then \
        if [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ]; then \
            pecl install xdebug-2.9.8; \
        else \
            pecl install xdebug; \
        fi \
        && docker-php-ext-enable xdebug; \
    fi; \
    if [ ${INSTALL_REDIS} = true ]; then \
        pecl install -o -f redis && docker-php-ext-enable redis; \
    fi; \
    if [ ${INSTALL_MONGO} = true ]; then \
        pecl install mongodb && docker-php-ext-enable mongodb; \
    fi; \
    groupadd -g 1000 develop && useradd -u 1000 -g develop -m -G sudo develop; \
    apt-get clean;

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm-256color

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

USER develop
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k;

COPY --chown=develop:develop .zshrc /home/develop/.zshrc
COPY --chown=develop:develop .p10k.zsh /home/develop/.p10k.zsh

USER develop
ENV TERM xterm-256color
WORKDIR /srv/www/