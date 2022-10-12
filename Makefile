# See https://stackoverflow.com/a/59335943/6928824

.PHONY: all venv install install_prod db precommit run clean

all: install run

venv:
	@# Create venv if it doesn't exist
	test -d venv || python3.10 -m venv venv

install: venv
	. venv/bin/activate && pip install -r requirements-dev.txt && pre-commit install

install_prod: venv
	. venv/bin/activate && pip install -r requirements.txt

db:
	. venv/bin/activate && python -c 'from core.app import commands; commands.create_db()'

precommit: install
	. venv/bin/activate && pre-commit run --all-files

run: venv
	. venv/bin/activate && flask --app dav_material.app run

clean:
	rm -rf venv
	find -iname "*.pyc" -delete
