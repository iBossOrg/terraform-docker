MK_DIR  ?= $(CURDIR)/../../../Mk
include $(MK_DIR)/terraform.mk

init: tf-init

plan: tf-plan

apply: tf-apply

output: tf-output

destroy: tf-destroy forget

forget: tf-forget
	@set -ex; \
	rm -rfv k3s-*

clean: tf-clean forget
