# Lambda Localstack POC

This has a working example of how we can test locally an AWS lambda function with localstack

```bash
docker-compose up -d # run localstack
make build # build lambda binary
make init # run only once to init terraform
make apply # create lambda function with terraform
make invoke # invoke localstack lambda function
```
