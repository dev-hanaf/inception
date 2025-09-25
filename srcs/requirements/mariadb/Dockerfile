FROM alpine:3.19

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY --chmod=777 tools/mariadb-entrypoint.sh /usr/local/bin/
COPY conf/mariadb-server.cnf /etc/my.cnf.d/

EXPOSE 3306

CMD ["mariadb-entrypoint.sh"]
