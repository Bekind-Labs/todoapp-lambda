# Makefile

RM=rm -f
TERRAFORM=terraform
AWS_REGION=ap-northeast-1
STATE_BUCKET=local-terraform-state

.PHONY: all init plan apply lint clean

all:

init:
	$(TERRAFORM) init -reconfigure -backend-config=bucket=$(STATE_BUCKET) -backend-config=region=$(AWS_REGION)

plan:
	$(TERRAFORM) plan

apply:
	$(TERRAFORM) apply

lint:
	$(TERRAFORM) fmt -recursive

validate:
	$(TERRAFORM) validate

clean:
	-$(RM) -r .terraform
