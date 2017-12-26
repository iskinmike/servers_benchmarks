// inside "index.js"
// start server
var server = new Server({
    tcpPort: 8080,
    views: [
        "server/views/hi",
        // "server/views/bye"
    ]
});
// active URLS:
// http://127.0.0.1:8080/server/views/hi
// http://127.0.0.1:8080/server/views/bye
// wait for Ctrl+C (in console app)
misc.waitForSignal();
// stop server
server.stop();
// inside "server/views/hi.js"
// GET: function(req) {
//     req.sendResponse("hello from GET handler");
// },
// POST: function(req) {
//     req.sendResponse({
//         msg: "hello from POST handler"
//     });
// }