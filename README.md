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
Endpoint bigquery, and change the URL final part to match your Google Cloud
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

### Setup to use in localhost development

You can also open this project using VS Code with the Cloud Code extension.
The big picture is: you need to have a service-account.json file visible to the local
Apigee Docker container as a volume folder, and set up the GOOGLE_APPLICATION_CREDENTIALS
environment variable to point to that location. You also need to configure SSL certificates
to call out the API.

You need to follow some tutorials to test locally the Apigee -> Bigquery sample:

1. Create a new service account key and save it on a local folder. I recommend using the `cert`
   folder as it is in .gitignore. If you have deployed to Apigee Eval org as described previously, exporting
   a new service account key using the same service account you created earlier should work.
   **Important**: you need to add the role '**Service Account Token Creator**' to this account, in addition
   to the '**Bigquery Job User**' role.
2. Configure Cloud Code to use a service account. This requires configuring the docker environment
   as described in
   [this document](https://cloud.google.com/apigee/docs/api-platform/local-development/vscode/deploy-environment#configuring_service_accounts_with_proxy_and_shared_flow_deployments) and also
   the container configuration [described here](https://cloud.google.com/apigee/docs/api-platform/local-development/vscode/manage-apigee-emulator#customizing_the_apigee_emulator_to_support_service_account-based_authentication).
3. Follow the steps to deploy the environment using the instructions
   [provided here](https://cloud.google.com/apigee/docs/api-platform/local-development/vscode/deploy-environment#deploy).

When developping locally, you can fetch logs from your local container with this:

    docker logs apigee-localhost 2>&1 >/dev/null | grep '^{' | jq -r .exceptionStackTrace

This should make easier to see the local logs and stack traces if issues arise.
Change the part `apigee-localhost` to the name you gave to your container during the
local environment setup.

## References

* Inspiration: https://www.youtube.com/watch?v=lUDZAzSpWEw
* Some in-depth inspiration with implementation details: https://youtu.be/58smxQu3P5k
* Using Google Authentication docs: https://cloud.google.com/apigee/docs/api-platform/security/google-auth/overview
* BDD Proxy Development with Apigee: https://github.com/apigee/devrel/blob/main/labs/bdd-proxy-development/lab.md