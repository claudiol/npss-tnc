.PHONY: default
default: help

.PHONY: help
##@ Pattern tasks

# No need to add a comment here as help is described in common/
help:
	@printf "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) common/Makefile | sort | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)\n"

%:
	make -f common/Makefile $*

.PHONY: install
install: operator-deploy post-install ## installs the pattern and loads the secrets
	@echo "Installed"

.PHONY: post-install
post-install: ## Post-install tasks
	make load-secrets
	@echo "Done"

.PHONY: test
test:
	@make -f common/Makefile PATTERN_OPTS="-f values-global.yaml -f values-hub.yaml" test

.PHONY: kubeconform
KUBECONFORM_SKIP=-skip 'CustomResourceDefinition,QuayRegistry,HyperConverged,VirtualMachine,OCSInitialization,StorageCluster,Certificate,CertManager,ClusterIssuer,ArgoCD'
kubeconform:
	make -f common/Makefile KUBECONFORM_SKIP="$(KUBECONFORM_SKIP)" kubeconform
