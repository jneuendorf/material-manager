# See https://stackoverflow.com/a/59335943/6928824
.PHONY: all venv install install_prod sample_data precommit run shell test run clean

all: install run

venv:
	@# Create venv if it doesn't exist
	test -d venv || python3 -m venv venv

install: venv
	. venv/bin/activate && pip install -Ur requirements-dev.txt && pre-commit install

install_prod: venv
	. venv/bin/activate && pip install -Ur requirements.txt

# NOTE: sqlite only
clear_db:
	rm -rf instance/*.db

sample_data: venv
	. venv/bin/activate && flask create-sample-data user material inspection rental legal

precommit: venv
	. venv/bin/activate && pre-commit run --all-files

shell: venv
	. venv/bin/activate && python -i -c 'from core import signals'

test: venv
	. venv/bin/activate && pytest -W ignore::DeprecationWarning

run: venv
	. venv/bin/activate && flask run

clean:
	rm -rf venv
	find . -type d -name '.mypy_cache' -delete -exec rm -r {} +
	find . -type d -name '.pytest_cache' -delete -exec rm -r {} +
	find . -type d -name '__pycache__' -delete -exec rm -r {} +
