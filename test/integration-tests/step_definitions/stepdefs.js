const assert = require('assert');
const { Then } = require("@cucumber/cucumber");

const xpath = require('xpath');
const dom = require('@xmldom/xmldom').DOMParser

Then(/response body xml xpath (.*) appears (.*) times/, function (xPath, expectedCount) {
    // Get the resopnse body from the apickli object
    var xml = this.apickli.getResponseObject().body;
    // Parse XML and lookup xPath count
    var doc = new dom().parseFromString(xml);
    var count = xpath.select("count(" + xPath + ")", doc);
    // Validate the result
    assert.equal(count, expectedCount);
});