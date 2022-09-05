DOCKER=$(shell which docker)
DOCKER-COMPOSE=$(shell which docker-compose)

help:
	@grep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

start: ## start existing docker postgres database
	$(DOCKER) start postgresql

stop: ## stop running docker postgres database
	$(DOCKER) stop postgresql

clean: ## completely remove docker postgres database and cached data
	-$(DOCKER) container rm -v postgresql -f
	-$(DOCKER) image rm postgres -f

psql: ## bash into running postgres database to run psql commands
	$(DOCKER) exec -it postgresql psql -U postgres -d Adventureworks

create: ## create docker adventureworks postgres database
	$(DOCKER-COMPOSE) up --wait