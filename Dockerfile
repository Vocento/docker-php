FROM php:5.6.29-fpm-alpine

# Install dev dependencies
RUN apk update \
    && apk add --no-cache autoconf file g++ gcc libc-dev make pkgconf re2c
    
# Install iconv, mbstring, bcmath and pcntl
RUN docker-php-ext-install -j5 iconv mbstring bcmath pcntl

# Install mcrypc
RUN apk update && apk add libmcrypt-dev \
    && docker-php-ext-install -j5 mcrypt

# Install intl
RUN apk update && apk add icu-dev \
    && docker-php-ext-install -j5 intl

# Install igbinary
RUN curl -sSL -A "Docker" -D - -o /tmp/igbinary-2.0.0.tgz https://pecl.php.net/get/igbinary-2.0.0.tgz \
    && tar zxpf /tmp/igbinary-2.0.0.tgz -C /tmp \
    && cd /tmp/igbinary-2.0.0 \
    && phpize && ./configure \
    && make && make install \
    && docker-php-ext-enable igbinary

# Install msgpack
RUN pecl install msgpack-0.5.7 \
    && docker-php-ext-enable msgpack

# Install memcached
RUN apk update && apk add libmemcached-dev zlib-dev libgsasl-dev cyrus-sasl-dev \
    && cd /tmp \
    && pecl download memcached-2.2.0 \
    && tar zxpf memcached-2.2.0.tgz \
    && cd memcached-2.2.0 \
    && phpize \
    && ./configure --enable-memcached-igbinary --enable-memcached-json --disable-memcached-msgpack --disable-memcached-sasl \
    && make \
    && make install \
    && docker-php-ext-enable memcached \
    && rm -rf /tmp/memcached-2.2.0*
    
# Install mongodb
RUN apk update && apk add openssl-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

# Install gd
RUN apk update && apk add libjpeg-turbo-dev freetype-dev libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j5 gd

# Install memcache lib
RUN pecl install memcache \
    && docker-php-ext-enable memcache

# Install bzip2 lib
RUN apk update && apk add libbz2 bzip2-dev \
    && docker-php-ext-install bz2 zip

# Install ftp lib
RUN docker-php-ext-install ftp

# Install calendar lib
RUN docker-php-ext-install calendar

# Install xsl lib
RUN apk update && apk add libxslt-dev \
    && docker-php-ext-install xsl

# Install gettext lib
RUN apk update && apk add gettext-dev \
    && docker-php-ext-install gettext

# Install xdebug
RUN curl -fsSL 'https://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz' -o xcache-3.2.0.tar.gz \
    && mkdir -p /tmp/xcache-3.2.0 \
    && tar zxpf xcache-3.2.0.tar.gz -C /tmp/xcache-3.2.0 --strip-components=1 \
    && docker-php-ext-configure /tmp/xcache-3.2.0 --enable-xcache \
    && docker-php-ext-install /tmp/xcache-3.2.0 \
    && rm -r /tmp/xcache-3.2.0*

# Install NodeJS & NPM
RUN apk update && apk add nodejs \
    &&  npm install -g less uglify-js

# Clear APK depedencies 
RUN apk del .fetch-deps \
    && apk del .build-deps \
    && apk del --purge
