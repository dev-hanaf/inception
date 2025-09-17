FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	php8.2-fpm \
	php8.2-mysql \
	curl \
	unzip

RUN mkdir -p /var/www/html
RUN mkdir -p /usr/src
#WORKDIR /var/www/html
WORKDIR /usr/src

#RUN unzip latest.zip && mv wordpress/* . && rmdir wordpress && rm latest.zip

RUN curl -O https://wordpress.org/latest.zip \
    && unzip latest.zip \
    && rm latest.zip

COPY wp-config.php wordpress/

COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY --chmod=755 entrypoint.sh /


WORKDIR /var/www/html

CMD ["/entrypoint.sh"]
