FROM php:7.2-apache

LABEL maintainer="Bruce E. Sueira"

RUN mkdir -p /var/www/html/public

COPY .docker/php/php.ini /usr/local/etc/php/
COPY .docker/apache/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY .docker/php/xdebug-dev.ini /usr/local/etc/php/conf.d/xdebug-dev.ini

RUN docker-php-ext-install pdo_mysql && \
    docker-php-ext-install opcache && \
    apt-get update && \
    apt-get install libldap2-dev -y && \
    apt-get install curl -y && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

RUN curl -s https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install nodejs    

RUN a2enmod rewrite negotiation

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /var/www/

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

RUN php composer-setup.php

RUN php -r "unlink('composer-setup.php');"

RUN mv composer.phar /usr/local/bin/composer
