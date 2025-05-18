SHELL := /bin/bash
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: help env up down clean health \
        bootstrap check update \
        admin-help check-prereqs \
        install-linters lint

.DEFAULT_GOAL := help

MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CUSTOM_PATH := $(abspath $(MAKEFILE_DIR)/../customization)

# -------------------------------------------------
# 🧑‍💻 Available Commands
# -------------------------------------------------

help:
	@echo "� Langfuse Fork for quick deployment - Make Commands"
	@echo ""
	@echo "🚀 Regular Usage Commands (Day-to-Day Operations):"
	@echo "  make help          - Show this help message"
	@echo "  make up            - Start Docker Compose stack and show logs"
	@echo "  make down          - Stop Docker Compose stack"
	@echo "  make health        - Check Docker status and Langfuse health endpoints"
	@echo ""
	@echo "🔧 First-Time Setup Commands:"
	@echo "  make check-prereqs - Check if your system meets the prerequisites"
	@echo "  make env           - Generate .env file with secure secrets"
	@echo ""
	@echo "🧹 Maintenance Commands:"
	@echo "  make clean         - Stop Docker Compose stack and remove all resources (volumes, networks)"
	@echo ""
	@echo "🛠️ Fork Creation & Maintenance Commands: make admin-help"

env:
	bash $(CUSTOM_PATH)/scripts/generate-env.sh

up:
	bash $(CUSTOM_PATH)/scripts/up.sh

down:
	bash $(CUSTOM_PATH)/scripts/down.sh

clean:
	bash $(CUSTOM_PATH)/scripts/clean.sh

health:
	bash $(CUSTOM_PATH)/scripts/healthcheck.sh

check-prereqs:
	bash $(CUSTOM_PATH)/scripts/check-prereqs.sh

# -------------------------------------------------
# 🛠️ Fork Creation & Maintenance commands
# -------------------------------------------------

admin-help:
	@echo "🛠️ Fork Creation & Maintenance Commands:"
	@echo ""
	@echo "  ⚙️ One-Time Setup Commands (Fork Creation):"
	@echo "  make bootstrap 			- Setup fork and push to personal GitHub repo"
	@echo ""
	@echo "  🔄 Periodic Maintenance Commands:"
	@echo "  make check     			- Check if your fork is in sync with upstream"
	@echo "  make update    			- Merge latest changes from upstream into your fork"
	@echo ""
	@echo "  🧪 Development & Quality Commands:"
	@echo "  make install-linters - Install shellcheck and shfmt"
	@echo "  make lint      			- Run linters on customization/"

bootstrap:
	bash $(CUSTOM_PATH)/scripts/housekeeping/bootstrap.sh

check:
	@bash $(CUSTOM_PATH)/scripts/housekeeping/check-upstream.sh

update:
	@bash $(CUSTOM_PATH)/scripts/housekeeping/update.sh

install-linters:
	bash $(CUSTOM_PATH)/scripts/housekeeping/install-linters.sh

lint:
	bash $(CUSTOM_PATH)/scripts/housekeeping/lint.sh
