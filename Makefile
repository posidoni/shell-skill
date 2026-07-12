# Makefile — developer and CI entrypoints. Run `make help` for the menu.
#
# Recipes run under strict Bash so a failing command fails the target.
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

.PHONY: help fmt fmt-check lint examples nushell nushell-demo test hooks ci

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN { FS = ":.*?## " } { printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2 }'

fmt: ## Format all shell scripts in place (shfmt -w)
	shfmt -w .

fmt-check: ## Check formatting; fails on any diff
	./tools/format-check.sh

lint: ## ShellCheck all non-bad shell scripts
	./tools/lint-shell.sh

examples: ## Verify the good-vs-bad example contract
	./tools/check-bad-examples.sh

nushell: ## Static-check all Nushell scripts (nu --ide-check)
	./tools/check-nushell.sh

nushell-demo: ## Run the Nushell startup-order bug/fix demonstration
	./tests/nushell-startup-demo.sh

test: ## Run the bats behavioural suite
	bats tests

hooks: ## Run every pre-commit hook across the whole repo
	pre-commit run --all-files

ci: fmt-check lint examples nushell nushell-demo test ## Run everything CI runs
