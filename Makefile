SERVER_NAME="rutas.localhost, caddy:80"
DOCKER_COMPOSE_DEBUG=-f docker-compose.yml -f docker-compose.debug.yaml -f docker-compose.override.yml
REQUIRE=sensio/framework-extra-bundle \
		symfony/asset \
		symfony/expression-language \
		symfony/form \
		symfony/http-client \
		symfony/intl \
		symfony/mailer \
		symfony/mime \
		symfony/monolog-bundle \
		symfony/notifier \
		symfony/orm-pack \
		symfony/process \
		symfony/security-bundle \
		symfony/serializer-pack \
		symfony/string \
		symfony/translation \
		symfony/twig-pack \
		symfony/validator \
		symfony/web-link
REQUIRE_DEV= symfony/debug-pack \
		symfony/maker-bundle \
		symfony/profiler-pack \
		symfony/test-pack


.PHONY: help

help:
	@grep -E '^[\%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

.INTERMEDIATE: stop

composer.json:
	docker-compose ${DOCKER_COMPOSE_DEBUG} build --no-cache
	docker-compose ${DOCKER_COMPOSE_DEBUG} run --rm php php -v
	docker-compose ${DOCKER_COMPOSE_DEBUG} run --rm php composer require ${REQUIRE}
	docker-compose ${DOCKER_COMPOSE_DEBUG} run --rm php composer require --dev ${REQUIRE_DEV}
	docker-compose ${DOCKER_COMPOSE_DEBUG} build
	docker-compose run --rm php chown -R `id -u`:`id -g` .

build: ## Build images
	docker-compose ${DOCKER_COMPOSE_DEBUG} build

dev: composer.json ## Run development environmet
	SERVER_NAME=${SERVER_NAME} docker-compose ${DOCKER_COMPOSE_DEBUG} up

down:
	docker-compose ${DOCKER_COMPOSE_DEBUG}  down

shell: ## Run shell
	docker-compose ${DOCKER_COMPOSE_DEBUG} run --rm php sh

fix: ## Fix permissions
	docker-compose run --rm php chown -R `id -u`:`id -g` .


