SHELL   := /bin/bash
PYTHON  ?= python3

export PYTHONWARNINGS := default

.PHONY: all install test cleanup

all: apksigcopier.1

install:
	$(PYTHON) -mpip install -e .

test:
	# TODO
	apksigcopier --version
	flake8 apksigcopier.py

cleanup:
	find -name '*~' -delete -print
	rm -fr __pycache__/
	rm -fr build/ dist/ apksigcopier.egg-info/
	rm -fr .coverage htmlcov/
	rm -fr apksigcopier.1

%.1: %.1.md
	pandoc -s -t man -o $@ $<

.PHONY: _package _publish

_package:
	$(PYTHON) setup.py sdist bdist_wheel
	twine check dist/*

_publish: cleanup _package
	read -r -p "Are you sure? "; \
	[[ "$$REPLY" == [Yy]* ]] && twine upload dist/*
