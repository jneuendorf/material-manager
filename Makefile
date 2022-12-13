.PHONY: run_docker clean_docker

run_docker:
	docker-compose --file docker-compose.yml up --detach --build

clean_docker:
	docker-compose down --remove-orphans
