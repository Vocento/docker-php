# Vocento - Docker PHP 5.6 image

To user this image create a Dockerfile with the following content:

```Dockerfile
FROM vocento/php:5-fpm

```

You can add configuration files to `/usr/local/etc/php` folder and php-fpm configuration 
to `/usr/local/etc/php-fpm.d` folder.

```Dockerfile
...

ADD conf.d/php.ini /usr/local/etc/php
ADD conf.d/www.conf /usr/local/etc/php-fpm.d

...
```

