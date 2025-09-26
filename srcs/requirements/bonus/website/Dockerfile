FROM alpine:3.19

RUN apk update && apk add --no-cache nodejs npm


WORKDIR app

COPY conf/site .

WORKDIR /app/site


RUN npm run build
RUN npm install -g serve

EXPOSE 3000


CMD ["serve", "-s", "build", "-l", "3000"]

