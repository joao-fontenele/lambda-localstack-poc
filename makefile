.PHONY: init
init:
	terraform -chdir=./infra/ init

.PHONY: apply
apply:
	terraform -chdir=./infra/ apply -var="lambda_mount_cwd=${PWD}/bin" -auto-approve

.PHONY: destroy
destroy:
	terraform -chdir=./infra/ destroy -var="lambda_mount_cwd=${PWD}/bin"

.PHONY: build
build:
	go build -o bin/main ./cmd/lambda/...
