FROM alpine:3.22

RUN apk update && apk add --no-cache \
    ca-certificates \
    php83 \
    php83-fpm \
    php83-mysqli \
    curl \
    tar \
    mariadb-client  

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY --chmod=700 tools/wp-entrypoint.sh /usr/local/bin/wp-entrypoint.sh

RUN adduser -S -D -H -h /var/www -s /sbin/nologin -G www-data www-data
#-S → system user
#-D → no password
#-H → no home directory created (we set /var/www manually)
#-h /var/www → home dir for compatibility
#-s /sbin/nologin → no shell
#-G www-data → assign to existing www-data group

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

EXPOSE 9000

CMD ["wp-entrypoint.sh"]
