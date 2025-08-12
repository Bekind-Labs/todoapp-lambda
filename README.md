# todoapp-lambda

This is a sample backend with Lambda + LocalStack.

## Contents

- `README.md`: This file.
- `Makefile`: Helper scripts.
- `docker-compose.yml`: Docker compose file for LocalStack.
- `terraform/`: Infrastructure code.
  - Can be used for LocalStack and a real AWS account.
- `todo/`: A sample TODO app.
  - `src/`: Source code (TypeScript).
  - `biome.json`: Biome settings..
  - `Makefile`: Helper scripts.
  - `invoke_api.sh`: Script for API gateway.
  - `invoke_funcurl.sh`: Script for Lambda Functional URL.
  - `package.json`: Package dependency.
  - `package-lock.json`: Package lockfile.
  - `tsconfig.json`: TypeScript settings.

## How to run

```shell
$ docker compose up
...
$ make test    # run tests
$ make lint    # run linter
$ make clean   # cleanup files
$ make deploy  # deploy to AWS
```
