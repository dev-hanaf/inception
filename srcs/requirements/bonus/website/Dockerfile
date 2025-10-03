FROM alpine:3.19

RUN  apk update && apk add --no-cache nginx 


COPY conf/default.conf /etc/nginx/http.d/
COPY conf/index.html /tmp/
COPY conf/style.css /tmp/

RUN mkdir -p /var/www/html

RUN adduser -S -D -H -h /var/www -s /sbin/nologin -G www-data www-data

COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3000

CMD ["entrypoint.sh"]