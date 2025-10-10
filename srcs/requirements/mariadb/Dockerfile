FROM alpine:3.19

# Downloads packages
# Installs them
# KEEPS cache in /var/cache/apk/
# Cache adds ~50-100 MB to image!
RUN apk update && apk add --no-cache mariadb mariadb-client
# Downloads packages
# Installs them
# DELETES cache immediately
# Smaller final image
COPY --chmod=777 tools/mariadb-entrypoint.sh /usr/local/bin/
COPY conf/mariadb-server.cnf /etc/my.cnf.d/

EXPOSE 3306

CMD ["mariadb-entrypoint.sh"]
