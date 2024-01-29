// Load the node 'assert' library to help validating the results.
const assert = require('assert');
// Load the some sample data fixtures, collected using the Google Cloud API Explorer.
const fixtures = require('./fixtures.json');

// The script under test here: our isolated business logic library.
require('../src/main/apigee/apiproxies/gcpreleases-v1/apiproxy/resources/jsc/library.js');

// Test suit for the libraty under test
describe('library', function() {

    describe('#parseRows', function() {
        it('should return empty array for 0 results query', function() {
            var src = fixtures.zeroRowsResponse.resp;
            var rows = library.parseRows(src);
            assert.equal(rows.length, 0);
        });

        it('should return single column/row for 1 row query', function() {
            var src = fixtures.singleRowResponse.resp;
            var rows = library.parseRows(src);
            assert.equal(rows.length, 1);
            assert.equal(rows[0].col, 42);
        });

        it('should parse the payload of a release notes query', function() {
            var src = fixtures.releaseNotesQuery.resp;
            var rows = library.parseRows(src);
            assert.equal(rows.length, 10);
            // check if all columns are present
            var firstRow = {
                "projectName": "Google Kubernetes Engine",
                "noteType": "NON_BREAKING_CHANGE",
                "description": "#### (2024-R02) Version updates\n \nNote: Your clusters might not have these versions available. Rollouts are already in progress when we publish the release notes, and can take multiple days to complete across all Google Cloud zones.\n\n  * The following versions are now available in the Stable channel:\n      * [1.25.16-gke.1041000](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.25.md#v12516)\n      * [1.26.11-gke.1055000](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.26.md#v12611)\n      * [1.27.7-gke.1121002](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.27.md#v1277)\n      * [1.27.8-gke.1067004](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.27.md#v1278)\n      * [1.28.3-gke.1118000](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.28.md#v1283)\n  * The following versions are no longer available in the Stable channel:\n      * 1.24.17-gke.200\n      * 1.24.17-gke.2266000\n      * 1.25.10-gke.2700\n      * 1.25.13-gke.200\n      * 1.27.4-gke.900\n      * 1.27.5-gke.200\n      * 1.27.7-gke.1121000\n  * Control planes and nodes with auto-upgrade enabled in the Stable channel will be upgraded from version 1.24 to version [1.25.15-gke.1115000](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.25.md#v12515) with this release.\n  * Control planes and nodes with auto-upgrade enabled in the Stable channel will be upgraded from version 1.25 to version [1.26.10-gke.1101000](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.26.md#v12610) with this release.\n  * Control planes and nodes with auto-upgrade enabled in the Stable channel will be upgraded from version 1.26 to version [1.26.10-gke.1101000](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.26.md#v12610) with this release.\n  * Control planes and nodes with auto-upgrade enabled in the Stable channel will be upgraded from version 1.27 to version [1.27.7-gke.1121002](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.27.md#v1277) with this release.\n  * Control planes and nodes with auto-upgrade enabled in the Stable channel will be upgraded from version 1.28 to version [1.28.3-gke.1118000](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.28.md#v1283) with this release.",
                "publishedAt": "2024-01-26",
            }
            assert.deepEqual(rows[0], firstRow);
        });
    });
});
