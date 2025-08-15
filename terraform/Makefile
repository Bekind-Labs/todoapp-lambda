# Makefile

RM=rm -f
TERRAFORM=terraform

.PHONY: all lint clean

all:

lint:
	-$(TERRAFORM) fmt -recursive

clean:
	-$(RM) -r .terraform* terraform.tfstate*
