#!/bin/bash
#
# deploy-proxy-bundle.sh: simple shell script to upload and
# deploy a proxy bundle to the eval environment.
set -e

BUNDLE="$1"
ORG="ronoaldo-apigee-demo"
ENV="eval"
PROXY="gcpreleases-v1"
SERVICE_ACCOUNT="apigee@ronoaldo-apigee-demo.iam.gserviceaccount.com"
APIGEE_API="https://apigee.googleapis.com/v1"

TOKEN="$(gcloud auth print-access-token)"
TMP="$(mktemp)"

# Step 0 validate the bundle file is a zip file
[[ -f "${BUNDLE}" ]] || {
    echo "Usage: $0 BUNDLE_FILE.zip"
    [[ -n "${BUNDLE}" ]] && echo "Invalid file: $BUNDLE"
    exit 1
}

# Ref: https://cloud.google.com/apigee/docs/reference/apis/apigee/rest/v1/organizations.apis/create
# Step 1 upload bundle
curl --silent --fail-with-body \
    -X POST \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/octet-stream" \
    --data-binary "@${BUNDLE}" \
    "${APIGEE_API}/organizations/${ORG}/apis?name=${PROXY}&action=import" > "${TMP}"
cat "${TMP}"
REV="$(jq -r .revision "${TMP}")"
echo "Uploaded ${REV}... Deploying"

# Ref: https://cloud.google.com/apigee/docs/api-platform/deploy/ui-deploy-new#apigee-api
# Step 2 create report
curl --fail-with-body \
    -X POST \
    -H "Authorization: Bearer ${TOKEN}" \
    "${APIGEE_API}/organizations/${ORG}/environments/${ENV}/apis/${PROXY}/revisions/${REV}/deployments:generateDeployChangeReport"

# Step 3 start the deployment
curl --fail-with-body \
    -X POST \
    -H "Authorization: Bearer ${TOKEN}" \
    "${APIGEE_API}/organizations/${ORG}/environments/${ENV}/apis/${PROXY}/revisions/${REV}/deployments?serviceAccount=${SERVICE_ACCOUNT}&override=true"
