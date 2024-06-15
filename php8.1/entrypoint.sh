#!/bin/bash

if [ "${XDEBUG_ENABLE}" == "true" ];
then
    echo "Xdebug: ENABLED"
    echo "[xdebug]" > /etc/php/8.1/20-xdebug.ini
    echo "zend_extension=xdebug.so" >> /etc/php/8.1/20-xdebug.ini
    echo "xdebug.idekey = VSCODE" >> /etc/php/8.1/20-xdebug.ini
    echo "xdebug.mode = debug" >> /etc/php/8.1/20-xdebug.ini
    echo "xdebug.remote_enable = true" >> /etc/php/8.1/20-xdebug.ini
    echo "xdebug.start_with_request = yes" >> /etc/php/8.1/20-xdebug.ini
    echo "xdebug.client_host = ${COMPOSE_SUBNET}.1" >> /etc/php/8.1/20-xdebug.ini
    echo "xdebug.client_port = ${XDEBUG_PORT}" >> /etc/php/8.1/20-xdebug.ini
    cp /etc/php/8.1/20-xdebug.ini /etc/php/8.1/cli/conf.d/20-xdebug.ini
    cp /etc/php/8.1/20-xdebug.ini /etc/php/8.1/fpm/conf.d/20-xdebug.ini
else
    echo "Xdebug: DISABLED"
    echo "" > /etc/php/8.1/20-xdebug.ini
fi

/usr/sbin/php-fpm8.1 -R --nodaemonize