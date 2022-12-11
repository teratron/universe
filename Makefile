
delete-garbage: ## delete garbage
	@find . -path './**/config.json' -delete

upgrade: ## Upgrade pip.
	python -m pip install --upgrade pip


lint: ## lint
	mypy src --ignore-missing-imports
	flake8 src --ignore=$(shell cat .flakeignore)

dev: ## dev
	pip install -e .

test: dev ## test
	pytest --doctest-modules --junitxml=junit/test-results.xml
	bandit -r src -f xml -o junit/security.xml || true

clean: ## clean
	@rm -rf .pytest_cache/ .mypy_cache/ junit/ build/ dist/
	@find . -not -path './.venv*' -path '*/__pycache__*' -delete
	@find . -not -path './.venv*' -path '*/*.egg-info*' -delete

venv: ## Init .venv
	python -m venv .venv
	source .venv/Scripts/activate

packaging: ## New project
	python -m venv .venv
	source .venv/bin/activate
	pip install --user pipenv
	pipenv install -d requests mypy autopep8 flake8 pytest bandit pydocstyle sphinx
	pipenv lock
	sphinx-quickstart docs

set-url: ## git remote set-url origin git@github.com:login/repo.git
	git remote set-url origin git@github.com:teratron/universe.git

message = Add sourse.
branch = master
add-commit-push: ## add commit push
	git add .
	git commit -m "$(message)"
	git push origin $(branch)

.PHONY: help
help:
	@echo "Tasks in \033[1;32mnettix\033[0m:"
	@awk '                                             \
		BEGIN {FS = ":.*?## "}                         \
		/^[a-zA-Z_-]+:.*?## /                          \
		{printf "\033[36m%-24s\033[0m %s\n", $$1, $$2} \
	'                                                  \
	$(MAKEFILE_LIST)

.DEFAULT_GOAL := help
