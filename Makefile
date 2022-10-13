# See https://stackoverflow.com/a/59335943/6928824
.PHONY: all venv install install_prod db precommit run shell test clean

all: install run

venv:
	@# Create venv if it doesn't exist
	test -d venv || python3.9 -m venv venv

install: venv
	. venv/bin/activate && pip install -r requirements-dev.txt && pre-commit install

install_prod: venv
	. venv/bin/activate && pip install -r requirements.txt

db:
	. venv/bin/activate && python -c 'from backend.core.app import commands; commands.create_db()'

precommit: venv
	. venv/bin/activate && pre-commit run --all-files

shell: venv
	. venv/bin/activate && python -i -c 'from backend.core import signals'

test: venv
	. venv/bin/activate && python -m unittest

run: venv
	. venv/bin/activate && flask --app backend.core.app run

clean:
	rm -rf venv
	find -iname "*.pyc" -delete
