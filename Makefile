.PHONY: run_prod

run_prod:
	docker-compose --file docker-compose.yml up --detach --build
