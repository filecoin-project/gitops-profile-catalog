SHELL: /bin/bash
.ONESHELL:


OS := $(shell uname | tr '[:upper:]' '[:lower:]')

BINDIR="${PWD}/.bin"

CLUSTER_NAME?=test-cluster

test:
	@echo "Testing platform"
	bash ${BINDIR}/test-platform.sh ${INFRASTRUCTURE}

sort-layers:
	@echo "Sorting charts by layers"
	bash ${BINDIR}/sort-layers.sh