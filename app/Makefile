# Makefile

ZIP=zip
RM=rm -f
MKDIR=mkdir
NPM=npm
CURL=curl
AWSCLI=awslocal
AWS_REGION=ap-northeast-1
GET_REST_API_URL=../tools/get_rest_api_url.sh

API_NAME=todo_api
STAGE_NAME=dev
FUNCTION_NAME=todo_lambda
ENDPOINT_PATH=/todos
SINCE=1h

.PHONY: all deploy build test lint clean invoke tail

all:

deploy: clean dist/index.zip
	$(AWSCLI) --no-cli-pager lambda update-function-code --region $(AWS_REGION) --function-name $(FUNCTION_NAME) --zip-file fileb://dist/index.zip

dist/index.zip: build
	-$(MKDIR) dist
	cd dist && $(ZIP) -r index.zip index.js*

ci:
	$(NPM) ci

build: ci
	$(NPM) run build

test: ci
	$(NPM) run test

lint: ci
	$(NPM) run lint

clean:
	-$(RM) -r dist

invoke:
	$(CURL) -i $$(AWSCLI="$(AWSCLI)" AWS_REGION="$(AWS_REGION)" $(GET_REST_API_URL) $(API_NAME) $(STAGE_NAME) $(ENDPOINT_PATH))

tail:
	$(AWSCLI) --no-cli-pager logs tail --region $(AWS_REGION) --since $(SINCE) /aws/lambda/$(FUNCTION_NAME)
