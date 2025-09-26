FROM alpine:3.19

RUN apk update && apk add --no-cache \
    php83 \
    php83-fpm \
    php83-gd \
    php83-pdo \
    php83-pdo_mysql \
    php83-mysqli \
    php83-session \
    php83-json \
    php83-openssl \
    php83-mbstring \
    php83-ctype \
    wget \
    freetype \
    libpng \
    libjpeg-turbo

RUN mkdir -p /var/www/html

WORKDIR /var/www/html
RUN wget -O index.php https://github.com/vrana/adminer/releases/download/v5.3.0/adminer-5.3.0.php && \
    chmod 644 index.php

RUN mkdir -p /etc/php83/conf.d && \
    echo 'upload_max_filesize = 64M' > /etc/php83/conf.d/custom.ini && \
    echo 'post_max_size = 64M' >> /etc/php83/conf.d/custom.ini && \
    echo 'memory_limit = 128M' >> /etc/php83/conf.d/custom.ini

EXPOSE 8080


CMD ["php83", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]

