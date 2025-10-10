#!/bin/sh
set -eu

if [ ! -f /run/secrets/ftp_user_password ]; then
    echo "ERROR: ftp_credentials secret not found!"
    exit 1
fi

FTP_PASS=$(cat /run/secrets/ftp_user_password)

echo ">>>>Creating empty dir"
mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

echo ">>>>Creating ${FTP_USER}"
# Alpine adduser syntax
adduser -D -h /home/${FTP_USER} -s /sbin/nologin ${FTP_USER} 
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

echo ">>>>Adding ${FTP_USER} to www-data group"
addgroup ${FTP_USER} www-data || true
adduser ${FTP_USER} www-data || true

echo "removing write permission for /home/${FTP_USER}"
chmod a-w /home/${FTP_USER}
mkdir -p /home/${FTP_USER}/wordpress
chown -R ${FTP_USER}:${FTP_USER} /home/${FTP_USER}/wordpress

echo ">>>>Starting vsftpd"
vsftpd /etc/vsftpd/vsftpd.conf

