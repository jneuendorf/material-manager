# See https://stackoverflow.com/a/59335943/6928824

.PHONY: all venv install install_prod precommit run shell test clean

all: install run

venv:
	@# Create venv if it doesn't exist
	test -d venv || python3.10 -m venv venv

install: venv
	. venv/bin/activate && pip install -r requirements-dev.txt && pre-commit install

install_prod: venv
	. venv/bin/activate && pip install -r requirements.txt

precommit: venv
	. venv/bin/activate && pre-commit run --all-files

shell: venv
	. venv/bin/activate && python -i -c 'from dav_core import signals'

test: venv
	. venv/bin/activate && python -m unittest

run: venv
	. venv/bin/activate && flask --app dav_material.app run

clean:
	rm -rf venv
	find -iname "*.pyc" -delete
