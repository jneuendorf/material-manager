# See https://stackoverflow.com/a/59335943/6928824

.PHONY: all install install_prod run venv clean

all: install run

install: venv
	. venv/bin/activate && pip install -r requirements-dev.txt

install_prod: venv
	. venv/bin/activate && pip install -r requirements.txt

venv:
	@# Create venv if it doesn't exist
	test -d venv || python3.10 -m venv venv

run: venv
	: # Run your app here, e.g
	: # determine if we are in venv,
	: # see https://stackoverflow.com/q/1871549
	. venv/bin/activate && python

clean:
	rm -rf venv
	find -iname "*.pyc" -delete
