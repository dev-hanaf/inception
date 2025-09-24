COMPOSE_FILE = srcs/docker-compose.yml
DOCKER_COMPOSE = docker-compose -f $(COMPOSE_FILE)

all: build up

build:
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

rebuild: down build up

restart:
	$(DOCKER_COMPOSE) restart

