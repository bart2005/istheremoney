PHONY: update-time verify build sitemap* deploy template img verify-site

sitemap:
	scripts/sitemap.sh
sitemap-verify-links:
	scripts/sitemap.sh | rg loc | sed 's/<loc>//g;s|</loc>||g' | while read l; do printf $${l}:; curl -s -o /dev/null -w "%{http_code}" "$$l"; echo; done
sitemap-update:
	scripts/sitemap.sh | tee src/sitemap.xml
build:
	npm run build
update-time:
	scripts/deploy.sh

verify:
	scripts/verify.sh $(CURDIR)/dist

verify-site:
	scripts/verify-site.sh

before-deploy: update-time verify sitemap-update

template:
	scripts/template.sh

img:
	magick $(I) -quality 85 -strip output.webp