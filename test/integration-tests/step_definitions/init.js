const apickli = require("apickli");
const { Before: before, setDefaultTimeout } = require("@cucumber/cucumber");

// Defaults to emulator http://0:8998/gcpreleases/v1
var proto = process.env.APIGEE_PROTO || "http";
var host = process.env.APIGEE_HOST || "localhost:8998/gcpreleases/v1"

before(function () {
  this.apickli = new apickli.Apickli(proto, host);
  this.apickli.storeValueInScenarioScope('apikey', process.env.APIKEY);
});

setDefaultTimeout(60 * 1000);
