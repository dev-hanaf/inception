FROM alpine:3.22

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY --chmod=777 tools/mariadb-entrypoint.sh /usr/local/bin/

EXPOSE 3306

CMD ["mariadb-entrypoint.sh"]
