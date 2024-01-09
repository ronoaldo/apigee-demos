PROXY=gcpreleases-v1
PROXY_DIR=src/main/apigee/apiproxies/gcpreleases-v1
TARGET=$(PWD)/target
BUNDLE_ZIP_DIR=$(TARGET)/bundles
BUNDLE_ZIP_FILE:=$(BUNDLE_ZIP_DIR)/gcpreleases-v1_$(shell date +%Y%m%d%H%M%S).zip

all: bundle

# Ref https://cloud.google.com/apigee/docs/api-platform/fundamentals/download-api-proxies#upload
bundle:
	mkdir -p $(BUNDLE_ZIP_DIR)
	cd $(PROXY_DIR) && zip $(BUNDLE_ZIP_FILE) -r ./

clean:
	rm -rvf $(BUNDLE_ZIP_DIR)

deploy-with-script: clean bundle
	ci/deploy-proxy-bundle.sh "$(BUNDLE_ZIP_FILE)"

# Ref: https://github.com/apigee/apigeecli/blob/main/docs/apigeecli_apis_deploy.md
.apigeecli-setup:
	apigeecli prefs set -o ronoaldo-apigee-demo
	apigeecli token cache --token $$(gcloud auth print-access-token) 2>/dev/null >/dev/null

deploy: clean bundle .apigeecli-setup
	apigeecli apis create bundle --name $(PROXY) --proxy-zip $(BUNDLE_ZIP_FILE)
	apigeecli apis deploy -e eval -r --name $(PROXY) --sa apigee@ronoaldo-apigee-demo.iam.gserviceaccount.com

clean-revisions: .apigeecli-setup
	apigeecli apis clean --name $(PROXY) --report=false