# Makefile

RM=rm -f
TERRAFORM=terraform

.PHONY: all init lint clean

all:

init:
	$(TERRAFORM) init

lint:
	$(TERRAFORM) fmt -recursive

validate:
	$(TERRAFORM) validate

clean:
	-$(RM) -r .terraform terraform.tfstate*
