.DEFAULT_GOAL = help

TEMPLATE_REPO := https://github.com/geekcell/template-terraform-module.git
REMOVE_TEMPLATE_FILES := .github/labels.yaml docs/assets
UPDATABLE_TEMPLATE_FILES := Makefile .editorconfig .gitignore .pref-commit-config.yaml .terraform-docs.yml .tflint.hcl LICENSE .github/pull_request-template.md .github/worksflows/ docs/logo.md

#########
# SETUP #
#########
.PHONY: setup/run
setup/run: setup/install-tools setup/clean-files pre-commit/install-hooks ## Install and setup necessary tools

.PHONY: setup/install-tools
setup/install-tools:	# Install required tools
ifeq (, $(shell which brew))
	@echo "No brew in $$PATH. Currently only brew is supported for installing tools."
else
	@brew install pre-commit terraform terraform-docs tflint
endif

.PHONY: setup/clean-files
setup/clean-files:	# Delete files which are pulled from remote
	@rm -r "$(REMOVE_TEMPLATE_FILES)"

.PHONY: setup/update-template
setup/update-template: ## Pull the latest template files from the main repo
	@git config remote.terraform-module-template.url >&- || git remote add terraform-module-template $(TEMPLATE_REPO)
	@git fetch terraform-module-template main
	@git checkout -p terraform-module-template/main -- $(UPDATABLE_TEMPLATE_FILES)

##############
# PRE-COMMIT #
##############
.PHONY: pre-commit/install-hooks
pre-commit/install-hooks:	## Install pre-commit git hooks script
	@git init
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
