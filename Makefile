.DEFAULT_GOAL = help

#########
# SETUP #
#########
.PHONY: setup
setup: setup/install-tools pre-commit/install-hooks ## Install and setup necessary tools

.PHONY: setup/install-tools
setup/install-tools:	# Install required tools
ifeq (, $(shell which brew))
	@echo "No brew in $$PATH. Currently only brew is supported for installing tools."
else
	@brew install pre-commit terraform terraform-docs tflint
endif

##############
# PRE-COMMIT #
##############
.PHONY: pre-commit/install-hooks
pre-commit/install-hooks:	## Install pre-commit git hooks script
	@pre-commit install

.PHONY: pre-commit/run-all
pre-commit/run-all:	## Run pre-commit against all files
	@pre-commit run -a

########
# HELP #
########
.PHONY: help
help:	## Shows this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_\-\.\/]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
