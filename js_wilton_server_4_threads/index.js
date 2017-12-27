
define([
    "wilton/httpClient",
    "wilton/Logger",
    "wilton/Server",
    "wilton/misc",
    "wilton/thread"
], function(http, Logger, Server, misc, thread) {
    "use strict";

    var logger = new Logger("js_wilton_server.main");
    // var misc = new misc();

    return {
        main: function() {
            Logger.initConsole("INFO");
            var server = new Server({
                numberOfThreads: 4,
                tcpPort: 8080,
                views: [
                    "js_wilton_server/views/hi",
                    "js_wilton_server/views/bye"
                ]
            });

            // http://127.0.0.1:8080/server/views/hi?foo=41&bar=42

            // for(;;) {
            //     // logger.info("Server is running ...");
            //     thread.sleepMillis(5000);
            // }            
            // wait for Ctrl+C (in console app)
            misc.waitForSignal();
            // stop server
            server.stop();
        }
    };
});
