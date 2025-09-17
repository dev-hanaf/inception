FROM debian:bookworm


RUN apt-get update && apt-get install -y nginx openssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/ahanaf.42.fr.key \
    -out /etc/ssl/certs/ahanaf.42.fr.crt \
    -subj "/C=MR/ST=Morocco/L=Bengruire/O=Ahanaf/OU=1337/CN=ahanaf.42.fr/emailAddress=admin@ahanaf.42.fr"


RUN mkdir -p /var/www/html

COPY default /etc/nginx/sites-available/default
COPY html/* /var/www/html/ 

EXPOSE 443

CMD ["nginx", "-g" , "daemon off;"]
