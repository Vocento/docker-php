FROM php:5-fpm
# APC APCU ldap json-1.3.9

# Install iconv and mbstring
RUN docker-php-ext-install -j$(nproc) iconv mbstring bcmath pcntl

# Install mcrypc
RUN apt-get update && apt-get install -y \
        libmcrypt-dev \
    && docker-php-ext-install -j$(nproc) mcrypt

# Install intl
RUN apt-get update && apt-get install -y \
        libicu-dev \
    && docker-php-ext-install -j$(nproc) intl

# Install igbinary
RUN pecl install igbinary \
    && docker-php-ext-enable igbinary

# Install msgpack
RUN pecl install msgpack-0.5.7 \
    && docker-php-ext-enable msgpack

# Install memcached
RUN apt-get update && apt-get install -y \
        libz-dev \
        libmemcached-dev \
    && pecl download memcached-2.2.0 \
    && tar -xzf memcached-2.2.0.tgz \
    && cd memcached-2.2.0 \
    && phpize \
    && ./configure --enable-memcached-igbinary --enable-memcached-json --enable-memcached-msgpack \
    && make \
    && make install \
    && docker-php-ext-enable memcached \
    && cd .. && rm -rf memcached-2.2.0*

# Install mongo
RUN apt-get update && apt-get install -y \
        libssl-dev \
    && pecl install mongo \
    && docker-php-ext-enable mongo

# Install gd
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN apt-get update && apt-get install -y \
        nodejs \
        npm \
    &&  npm install -g less uglify-js

# Install memcache lib
RUN pecl install memcache \
    && docker-php-ext-enable memcache

RUN apt-get update && apt-get install -y \
    libbz2-dev \
    libxslt-dev \
    && docker-php-ext-install bz2 calendar ftp gettext zip xsl

RUN apt-get purge -y \
    && rm -rf /var/lib/apt/lists/*
