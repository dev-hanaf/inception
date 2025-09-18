FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	php8.2-fpm \
	php8.2-mysql \
	curl \
	unzip \
	mariadb-client

RUN mkdir -p /var/www/html
RUN mkdir -p /data

WORKDIR /data

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp


COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY --chmod=755 entrypoint.sh /

WORKDIR /var/www/html


CMD ["/entrypoint.sh"]
