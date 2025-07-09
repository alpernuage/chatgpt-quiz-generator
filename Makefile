include .env
export

MAKEFLAGS += --silent #Disable the display of default commands for the entire file.

SUBCOMMAND = $(strip $(subst +,-, $(filter-out $@,$(MAKECMDGOALS))))
CURRENT_DIR = $(shell pwd)
SF_DIR = ${CURRENT_DIR}/app/back

DOCKER_COMPOSE = docker compose
CONTAINER_PHP = $(DOCKER_COMPOSE) exec php
CONSOLE = $(CONTAINER_PHP) bin/console
COMPOSER = $(CONTAINER_PHP) composer
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

# 🎨 Colors
RED := $(shell tput -Txterm setaf 1)
GREEN := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
BLUE := $(shell tput -Txterm setaf 4)
ORANGE=$(shell tput setaf 172)
LIME_YELLOW=$(shell tput setaf 190)
RESET=$(shell tput sgr0)
BOLD=$(shell tput bold)
REVERSE=$(shell tput smso)

## —— 📦 Install dependencies ——
.PHONY: vendor
vendor: ## Install PHP dependencies
vendor: .env.local
	$(COMPOSER) install

## —— 🔥 Project ——
.env.local: ## 📄📄 Create or update .env.local file
.env.local: .env
	@if [ -f .env.local ]; then \
		if ! cmp -s .env .env.local; then \
			echo "${LIME_YELLOW}ATTENTION: ${RED}${BOLD}.env file and .env.local are different, check the changes bellow:${RESET}${REVERSE}"; \
			diff -u .env .env.local | grep -E "^[\+\-]"; \
			echo "${RESET}---\n"; \
			echo "${LIME_YELLOW}ATTENTION: ${ORANGE}This message will only appear once if the .env file is updated again.${RESET}"; \
			touch .env.local; \
			exit 1; \
		fi \
	else \
		cp .env .env.local; \
		echo "${GREEN}.env.local file has been created."; \
		echo "${ORANGE}Modify it according to your needs and continue with running the same command.${RESET}"; \
		exit 1; \
	fi

.PHONY: install
install: ## 🚀 Project installation
install: .env.local build start vendor assets database-create migrate
	@echo "${BLUE}The application is available at the url: $(SERVER_NAME)$(RESET)";

.PHONY: tls-certificates
tls-certificates: ## 🔐 Add tls certificates for Linux (https://github.com/dunglas/symfony-docker/blob/main/docs/tls.md)
	docker cp $(docker compose ps -q php):/data/caddy/pki/authorities/local/root.crt /usr/local/share/ca-certificates/root.crt && sudo update-ca-certificates

## —— 🖥️ Console ——
.PHONY: console
console: ## Execute console command to accept arguments that will complete the command
	$(CONSOLE) $(filter-out $@,$(MAKECMDGOALS))

## —— 🎩 Composer ——
.PHONY: composer
composer: ## Execute composer command
	$(COMPOSER) $(filter-out $@,$(MAKECMDGOALS))

## —— 🎨 Assets ——
.PHONY: assets
assets: ## Install assets
	npm install
	npm run build

## —— 🐳 Docker ——
.PHONY: build
build: ## 🏗️ Build the container
	$(DOCKER_COMPOSE) build --pull --no-cache

.PHONY: rebuild
rebuild: ## 🏗️ Rebuild the docker environment
	$(DOCKER_COMPOSE) down --remove-orphans && $(DOCKER_COMPOSE) build --pull --no-cache
	$(DOCKER_COMPOSE) up --wait

.PHONY: test-setup
test-setup: ## 🏗️ Test your setup
	$(DOCKER_COMPOSE) exec php bin/console dbal:run-sql -q "SELECT 1" && echo "✅ OK" || echo "❌ Connection is not working"

.PHONY: start
start: ## ▶️ Start the containers
start: .env.local
	$(DOCKER_COMPOSE) up --wait

.PHONY: stop
stop: ## ⏹️ Stop the containers
	$(DOCKER_COMPOSE) stop

.PHONY: restart
restart: ## 🔄 restart the containers
restart: stop start

.PHONY: kill
kill: ## ❌ Forces running containers to stop by sending a SIGKILL signal
	docker kill $(docker ps -q)

.PHONY: down
down: ## ⏹️🧹 Stop containers and clean up resources
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

.PHONY: reset
reset: ## Stop and start a fresh install of the project
reset: kill down build start

.PHONY: test-connexion
test-connexion: ## Test database connexion
	$(DOCKER_COMPOSE) exec php bin/console dbal:run-sql -q "SELECT 1" && echo "✅ DB OK" || echo "❌ DB ERROR"

.PHONY: logs-php
logs-php: ## Display logs for the php container
	$(DOCKER_COMPOSE) logs -f php

## —— 🔨 Tools ——
.PHONY: cache
cache: ## 🧹 Clear Symfony cache
	$(CONSOLE) cache:clear

.PHONY: cache-test
cache-test: ## 🧹 Clear Symfony cache for test environment
	$(CONSOLE) cache:clear --env=test

## —— 🔍 PHPStan ——
.PHONY: phpstan
phpstan: ## PHP Static Analysis Tool (https://github.com/phpstan/phpstan)
	$(CONTAINER_PHP) vendor/bin/phpstan --memory-limit=-1 analyse src

## —— 🔧 PHP CS Fixer ——
.PHONY: fix-php-cs
fix-php-cs: ## PhpCsFixer (https://cs.symfony.com/)
	$(CONTAINER_PHP) vendor/bin/php-cs-fixer fix --verbose

## ——📋 APPLICATION ——
#code-check: apply-php-cs apply-rector apply-phpmd apply-phpstan eslint-format

## —— 🗄️ Database ——
.PHONY: migration
migration: ## 🔀 Generate a new Doctrine migration
	$(CONSOLE) doctrine:migrations:diff --formatted

.PHONY: migrate
migrate: ## Run migrations
	$(CONSOLE) doctrine:migration:migrate --no-interaction

.PHONY: migrate-prev
migrate-prev: ## Rollback to previous migration
	$(CONSOLE) doctrine:migration:migrate prev

.PHONY: migrate-next
migrate-next: ## Run the next migration
	$(CONSOLE) doctrine:migration:migrate next

.PHONY: database-create
database-create: ## Create database
	$(CONSOLE) doctrine:database:create --if-not-exists

.PHONY: database-reset
database-reset: ## 📊 Create and migrate the database schema
	$(CONSOLE) doctrine:database:drop --force || true
	$(CONSOLE) doctrine:database:create
	$(CONSOLE) doctrine:migrations:migrate -n

.PHONY: fixtures
fixtures: ## Load database fixtures
	$(CONSOLE) doctrine:fixtures:load -n

## —— ✅ Testing ——
.PHONY: test-database
test-database: ## Prepare the test database
	$(CONSOLE) doctrine:database:drop --force --env=test || true
	$(CONSOLE) doctrine:database:create --env=test
	$(CONSOLE) doctrine:migrations:migrate -n --env=test

.PHONY: test-fixtures
test-fixtures: ## Load test fixtures
test-fixtures: test-database
	$(CONSOLE) doctrine:fixtures:load -n --env=test

.PHONY: test
test: ## Run tests
	$(CONTAINER_PHP) vendor/bin/simple-phpunit

test-filter: ## Run filtered tests
	$(CONTAINER_PHP) vendor/bin/simple-phpunit --filter $(filter-out $@,$(MAKECMDGOALS))

.PHONY: testdox
testdox: ## Run tests with testdox output for clearer test result summary (https://docs.phpunit.de/en/10.2/attributes.html#testdox)
	$(CONTAINER_PHP) vendor/bin/simple-phpunit --testdox

## —— 🐱 Git ——
.PHONY: pull
pull: ## Run git pull command on current branch
	git fetch origin
	git pull origin $(BRANCH)

.PHONY: push
push: ## Run git push command on current branch
	git push origin $(BRANCH)

.PHONY: amend
amend: ## Send commit without edition
	git commit --amend --no-edit

.PHONY: filemode
filemode: ## Ignore file mode changes
	git config core.fileMode false

.PHONY: stash
stash: ## Stash with untracked files, add -m "message" if needed
	git stash save --include-untracked "${SUBCOMMAND}"

.PHONY: restore
restore: ## restore deleted file
	git restore --staged "${SUBCOMMAND}"
	git restore "${SUBCOMMAND}"

## —— 🛠️ Others ——
.PHONY: open
open: ## Open the project in the browser
	@echo "${GREEN}Opening https://$(SERVER_NAME)${RESET}"
	@open https://$(SERVER_NAME)

.PHONY: list-md
list-md: ## 📘 Export Make targets to a Markdown file
	@echo "# Liste des commandes Makefile\n" > COMMANDS.md
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##[^#])' Makefile | awk '\
	BEGIN {FS = ":.*?## "}; \
	/^##[^#]/ {gsub(/^## +/, "", $$0); printf "\n## %s\n", $$0} \
	/^[^#]/ {printf "- **`make %s`**: %s\n", $$1, $$2}' >> COMMANDS.md

.DEFAULT_GOAL := help
.PHONY: help
help: ## 📜 Describe targets
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##[^#])' Makefile | awk '\
	BEGIN {FS = ":.*?## "}; \
	/^##[^#]/ {gsub(/^## +/, "", $$0); printf "\n\033[33m%s\033[0m\n", $$0; next}; \
	/^[^#]/ {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'
