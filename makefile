.PHONY: init
init:
	terraform -chdir=./infra/ init

.PHONY: apply
apply:
	terraform -chdir=./infra/ apply -var="LAMBDA_MOUNT_CWD=${PWD}/bin" -auto-approve

.PHONY: destroy
destroy:
	terraform -chdir=./infra/ destroy -var="LAMBDA_MOUNT_CWD=${PWD}/bin"

.PHONY: build
build:
	go build -o bin/main ./cmd/lambda/...
