FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server

RUN mkdir -p  /run/mysqld/

RUN chown -R mysql:mysql /run/mysqld/

COPY --chmod=755 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY --chmod=755 entrypoint.sh .

CMD ["./entrypoint.sh"] 
