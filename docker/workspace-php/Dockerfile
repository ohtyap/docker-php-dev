ARG PHP_VERSION=8.0
FROM php:${PHP_VERSION}-cli-alpine

# Install php extension installer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

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
ARG INSTALL_PCOV=false
ARG INSTALL_XHPROF=false

USER root
RUN set -eux; \
    apk add --no-cache --virtual .build-deps pcre-dev ${PHPIZE_DEPS}; \
    apk add --no-cache shadow sudo openssh-client git curl vim zsh zsh-autosuggestions zsh-syntax-highlighting gnupg; \
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
    if [ ${INSTALL_PCOV} = true ]; then \
            php_ext="pcov ${php_ext}"; \
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
        php_ext="xdebug ${php_ext}"; \
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
    adduser --disabled-password --shell /bin/zsh develop; addgroup develop wheel; \
    mkdir -p /opt && chmod 0777 /opt; \
    touch /etc/pam.d/chsh && echo 'auth        sufficient  pam_rootok.so' > /etc/pam.d/chsh; \
    echo '%wheel ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/wheel;

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm-256color

# Install zsh/ohmyzsh for root
USER root
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k;
COPY --chown=root:root .zshrc /root/.zshrc
COPY --chown=root:root .p10k.zsh /root/.p10k.zsh

# Install zsh/ohmyzsh for root
USER develop
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k;
COPY --chown=develop:develop .zshrc /home/develop/.zshrc
COPY --chown=develop:develop .p10k.zsh /home/develop/.p10k.zsh

# Change default shell
USER root
RUN chsh -s $(which zsh) && chsh -s $(which zsh) develop

USER develop
ENV TERM xterm-256color
WORKDIR /srv/www/
