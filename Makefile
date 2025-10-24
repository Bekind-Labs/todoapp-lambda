# Makefile

AWSCLI=awslocal
AWS_REGION=ap-northeast-1

.PHONY: all ci deploy test lint clean

all:

ci:
	cd ./app && $(MAKE) ci

deploy:
	cd ./app && AWSCLI="$(AWSCLI)" AWS_REGION="$(AWS_REGION)" $(MAKE) deploy

test:
	cd ./app && AWSCLI="$(AWSCLI)" AWS_REGION="$(AWS_REGION)" $(MAKE) test

lint:
	cd ./app && $(MAKE) lint
	cd ./terraform && $(MAKE) lint

clean:
	cd ./app && $(MAKE) clean
	cd ./terraform && $(MAKE) clean
