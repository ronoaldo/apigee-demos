# apigee-demos

Apigee Demos. This demo uses the BigQuery API method that runs a query and
synchronously returns the results to showcase how to implement and possibly
monetize data-driven APIs.

**This is intended for learning/demoing pourposes only! Do not publish
unrestricted API endpoints that execute queries against your Google Project. It
is an exercise for the reader to apply the needed security policies, quotas, and
caching!**

## How to use this demo

This was tested using an Eval Org. The easier way is to bundle the proxy and use
the .zip bundle to import a new version.

To create a proxy bundle, use the helper target in the provided Makefile:

    make bundle

A new file is created under the directory `target/bundles/`. Use that to upload
a new proxy bundle to the `eval` environment following these instructions:
https://cloud.google.com/apigee/docs/api-platform/fundamentals/download-api-proxies#upload.
**Important**: make sure to deploy the proxy with a service account that can
access Bigquery public data and also has the Bigquery Job User role.

After you deploy/import your bundle, go to the Develop tab and edit the Target
Endpoint bigquery-v2, and change the URL final part to match your Google Cloud
Project ID. Deploy this changed version to the eval environment.

### Setup to use a Test VM

1. Create a premptive VM (can be e2-micro) with Full Access to Google APIs permission
2. Make sure to allow the firewall from IAP to port TCP 22, and ssh to the VM
3. Install `jq`: `sudo apt-get update && sudo apt-get install -y jq`
4. Export the environment variables:
```
export AUTH="Authorization: Bearer $(gcloud auth print-access-token)"
export PROJECT_ID="$(gcloud config get project)"
export ENV_GROUP_HOSTNAME=$(curl -H "$AUTH" https://apigee.googleapis.com/v1/organizations/$PROJECT_ID/envgroups -s | jq -r '.environmentGroups[0].hostnames[0]')
export INTERNAL_LOAD_BALANCER_IP=$(curl -H "$AUTH" https://apigee.googleapis.com/v1/organizations/$PROJECT_ID/instances -s | jq -r '.instances[0].host')
```
5. Create a new entry in /etc/hosts to make easier to call it:
```
echo "$INTERNAL_LOAD_BALANCER_IP $ENV_GROUP_HOSTNAME" | sudo tee -a /etc/hosts
```
6. Make API calls:
```
curl -k https://${ENV_GROUP_HOSTNAME}/gcpreleases/v1/echo | jq .

curl -k https://${ENV_GROUP_HOSTNAME}/gcpreleases/v1/releases | jq .
```

## References

* Inspiration: https://www.youtube.com/watch?v=lUDZAzSpWEw
* Some in-depth inspiration with implementation details: https://youtu.be/58smxQu3P5k
* Using Google Authentication docs: https://cloud.google.com/apigee/docs/api-platform/security/google-auth/overview
