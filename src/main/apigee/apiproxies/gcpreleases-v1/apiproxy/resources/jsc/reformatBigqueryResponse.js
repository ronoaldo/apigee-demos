var body = context.getVariable("response.content");
if (body) {
    rows = parseRows(JSON.parse(body));
    response.headers['content-type'] = 'application/json';
    response.content = JSON.stringify(rows, null, "  ");
}