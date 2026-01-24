PHONY: update-time verify build

build:
	npm run build
update-time:
	scripts/deploy.sh
verify:
	scripts/verify.sh $(CURDIR)/dist