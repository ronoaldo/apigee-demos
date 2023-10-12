TARGET=$(PWD)/target

BUNDLE_ZIP_DIR=$(TARGET)/bundles
PROXY_DIR=src/main/apigee/apiproxies/gcpreleases-v1

all: bundle

# Ref https://cloud.google.com/apigee/docs/api-platform/fundamentals/download-api-proxies#upload
bundle:
	mkdir -p $(BUNDLE_ZIP_DIR)
	cd $(PROXY_DIR) && zip $(BUNDLE_ZIP_DIR)/gcpreleases-v1_$$(date +%Y%m%d%H%M%S).zip -r ./