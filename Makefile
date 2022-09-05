DOCKER=$(shell which docker)

help:
	@grep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

create: ## spin up docker postgres
	$(DOCKER) pull postgres
	$(DOCKER) run --name postgresql -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres

load: ## load running docker postgres database
	bash -c "curl -LO https://www.postgresqltutorial.com/wp-content/uploads/2019/05/dvdrental.zip"
	bash -c "unzip -o dvdrental.zip && rm -r dvdrental.zip"
	$(DOCKER) exec -i postgresql pg_restore -U postgres -v -d postgres < ./dvdrental.tar
	bash -c "rm -r dvdrental.tar"

start: ## start existing docker postgres database
	$(DOCKER) start postgresql

stop: ## stop running docker postgres database
	$(DOCKER) stop postgresql

clean: ## completely remove docker postgres database and cached data
	-$(DOCKER) container rm -v postgresql -f
	-$(DOCKER) image rm postgres -f