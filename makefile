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

.PHONY: invoke
invoke:
	aws --endpoint-url=http://localhost:4566 lambda invoke --function-name test-local invoke.log
	cat invoke.log
