# Makefile

RM=rm -f
TERRAFORM=terraform

.PHONY: all lint clean

all:

lint:
	-$(TERRAFORM) fmt -recursive

validate:
	-$(TERRAFORM) validate

clean:
	-$(RM) -r .terraform* terraform.tfstate*
