FROM debian:bookworm

# php-fpm launches under www-data, see php-fpm.conf
USER root
RUN apt update && \
    apt -y install lsb-release ca-certificates curl wget && \
    curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb && \
    dpkg -i /tmp/debsuryorg-archive-keyring.deb && \
    sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
    apt update && \
    apt upgrade && \
    apt install -y php8.1 \
    php8.1-apcu \
    php8.1-bcmath \
    php8.1-bz2 \
    php8.1-curl \
    php8.1-ds \
    php8.1-fpm \
    php8.1-gd \
    php8.1-gmp \
    php8.1-imagick \
    php8.1-intl \
    php8.1-ldap \
    php8.1-lz4 \
    php8.1-maxminddb \
    php8.1-mbstring \
    php8.1-memcache \
    php8.1-mcrypt \
    php8.1-mysql \
    php8.1-opcache \
    php8.1-psr \
    php8.1-readline \
    php8.1-redis \
    php8.1-soap \
    php8.1-tidy \
    php8.1-uuid \
    php8.1-vips \
    php8.1-xdebug \
    php8.1-xml \
    php8.1-zip \
    && \
    wget -O /usr/bin/composer https://github.com/composer/composer/releases/latest/download/composer.phar && \
    chmod +x /usr/bin/composer && \
    apt clean && \
    apt -y --purge autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/{man,doc}

COPY ./certs/*.pem /usr/local/share/ca-certificates/
RUN update-ca-certificates
RUN echo "* * * * * www-data php -f /var/www/html/bitrix/modules/main/tools/cron_events.php" >> /etc/crontab

COPY ./conf/50-settings.ini /etc/php/8.1/cli/conf.d/50-settings.ini
COPY ./conf/50-settings.ini /etc/php/8.1/fpm/conf.d/50-settings.ini
COPY ./conf/php-fpm.conf /etc/php/8.1/fpm/php-fpm.conf
COPY ./entrypoint.sh /run/entrypoint.sh

ENTRYPOINT [ "/run/entrypoint.sh" ]

WORKDIR /var/www/html
EXPOSE 9000