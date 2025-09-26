FROM alpine:3.19

RUN  apk update && apk add --no-cache nginx  openssl


RUN mkdir -p /etc/ssl/certs /etc/ssl/private

ARG COUNTRY STATE LOCALITY ORGANIZATION UNIT COMMON_NAME

RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
	-out /etc/ssl/certs/server.crt \
	-keyout /etc/ssl/private/server.key \
	-subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${UNIT}/CN=${COMMON_NAME}"


COPY conf/default.conf /etc/nginx/http.d/

RUN mkdir -p /var/www/html

#ADD USER www-data and GROUP www-data group already exist
RUN adduser -S -D -H -h /var/www -s /sbin/nologin -G www-data www-data

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
