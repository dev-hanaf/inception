FROM alpine:3.19

# Install dependencies and build Redis
RUN apk add --no-cache build-base tcl bash linux-headers wget curl \
    && wget http://download.redis.io/redis-stable.tar.gz \
    && tar xzf redis-stable.tar.gz \
    && cd redis-stable \
    && make \
    && make install \
    && mkdir -p /etc/redis /data \
    && cp redis.conf /etc/redis/redis.conf \
    && cd .. && rm -rf redis-stable.tar.gz redis-stable

COPY conf/redis.conf /etc/redis/redis.conf
# Expose custom Redis port
EXPOSE 6379

# Start Redis server with persistence
CMD ["redis-server", "/etc/redis/redis.conf"]

