FROM alpine:3.19

RUN apk update && apk add --no-cache vsftpd lftp

RUN mkdir -p /var/www/html



COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY --chmod=755 tools/ftp-entrypoint.sh .


CMD ["./ftp-entrypoint.sh"]
