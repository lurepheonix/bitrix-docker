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
    php8.3-apcu \
    php8.3-bcmath \
    php8.3-bz2 \
    php8.3-curl \
    php8.3-ds \
    php8.3-fpm \
    php8.3-gd \
    php8.3-gmp \
    php8.3-imagick \
    php8.3-intl \
    php8.3-ldap \
    php8.3-maxminddb \
    php8.3-mbstring \
    php8.3-memcache \
    php8.3-mcrypt \
    php8.3-mysql \
    php8.3-opcache \
    php8.3-readline \
    php8.3-redis \
    php8.3-soap \
    php8.3-tidy \
    php8.3-uuid \
    php8.3-vips \
    php8.3-xdebug \
    php8.3-xml \
    php8.3-zip \
    && \
    wget -O /usr/bin/composer https://github.com/composer/composer/releases/latest/download/composer.phar && \
    chmod +x /usr/bin/composer && \
    apt clean && \
    apt -y --purge autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/{man,doc}

COPY ./certs/*.pem /usr/local/share/ca-certificates/
RUN update-ca-certificates
RUN echo "* * * * * www-data php -f /var/www/html/bitrix/modules/main/tools/cron_events.php" >> /etc/crontab

COPY ./conf/50-settings.ini /etc/php/8.3/cli/conf.d/50-settings.ini
COPY ./conf/50-settings.ini /etc/php/8.3/fpm/conf.d/50-settings.ini
COPY ./conf/php-fpm.conf /etc/php/8.3/fpm/php-fpm.conf
COPY ./entrypoint.sh /run/entrypoint.sh

ENTRYPOINT [ "/run/entrypoint.sh" ]

WORKDIR /var/www/html
EXPOSE 9000
