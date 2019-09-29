MK_DIR  ?= $(CURDIR)/../../Mk
include $(MK_DIR)/terraform.mk

init: tf-init

plan: tf-plan

apply: tf-apply

output: tf-output

destroy: tf-destroy tf-forget

forget: tf-forget

clean: tf-clean
	@set -ex; \
	rm -rfv k3d-*
