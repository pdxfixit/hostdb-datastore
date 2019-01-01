ENVIRONMENT ?= hostdb-datastore
TOP_DIR     := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
ENVS_DIR     = $(TOP_DIR)/envs/$(ENVIRONMENT)
BUILD_DIR    = $(TOP_DIR)/build/$(ENVIRONMENT)
TF_VERSION  := 0.11.11
TF_CMD       = $(shell $(TOP_DIR)/scripts/get-terraform.sh $(TF_VERSION))

$(info Using build directory [${BUILD_DIR}])

.PHONY: default help
default help:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort

$(ENVS_DIR):
	mkdir -p "$@"

$(BUILD_DIR):
	mkdir -p "$@"

# if environment config exists
ifneq ($(wildcard $(ENVS_DIR)/providers.tf),)

ENV_FILES   := $(wildcard $(ENVS_DIR)/*)
ROOT_FILES  := $(wildcard $(TOP_DIR)/*.tf)
BUILD_FILES := $(patsubst $(ENVS_DIR)/%,$(BUILD_DIR)/%,$(ENV_FILES)) $(patsubst $(TOP_DIR)/%,$(BUILD_DIR)/%,$(ROOT_FILES))

$(foreach file,$(ENV_FILES),$(eval $(patsubst $(ENVS_DIR)/%,$(BUILD_DIR)/%,$(file)): $(file)))
$(foreach file,$(ROOT_FILES),$(eval $(patsubst $(TOP_DIR)/%,$(BUILD_DIR)/%,$(file)): $(file)))

$(BUILD_DIR)/%: $(ENVS_DIR)/%
	cp -f $< $@

$(BUILD_DIR)/%: $(TOP_DIR)/%
	cp -f $< $@

endif # if environment config exists

.PHONY: check-env
check-env:
ifndef ENVIRONMENT
	$(error ENVIRONMENT is undefined)
endif

.PHONY: localconfig
localconfig: check-env $(BUILD_DIR) $(BUILD_FILES)

ifneq ($(wildcard $(BUILD_DIR)/backend.tfvars),)
TF_INIT_OPTIONS += -backend-config=$(BUILD_DIR)/backend.tfvars
endif

.PHONY: init
init: localconfig
	cd $(BUILD_DIR) && $(TF_CMD) init $(TF_INIT_OPTIONS) -input=false

.PHONY: plan
plan: init
	cd $(BUILD_DIR) && $(TF_CMD) plan -input=false

.PHONY: apply
apply: init
	cd $(BUILD_DIR) && $(TF_CMD) apply -auto-approve -input=false

.PHONY: destroy
destroy: init
	cd $(BUILD_DIR) && $(TF_CMD) destroy -force

.PHONY: clean
clean: check-env
	rm -rf $(BUILD_DIR)

.PHONY: structure-check
structure-check:
		$(info terraform fmt)
		$(eval FMT_ERR := $(shell terraform fmt -list -write=false .))
		@if [ "$(FMT_ERR)" != "" ]; then echo "misformatted files (run 'terraform fmt .' to fix):"; printf '%s\n' $(FMT_ERR); exit 1; fi

.PHONY: validate
validate: structure-check
	$(info terraform validate)
	@find . -name envs -prune -o -type f -name "*.tf" -exec dirname {} \; | sort -u | \
		while read m ; \
		do \
			( echo "$$m" ) ; \
			( terraform validate -check-variables=false "$$m" && echo "√ $$m") || exit 1 ; \
		done

