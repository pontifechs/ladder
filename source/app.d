
import vibe.d;

import vibe.http.fileserver;
import vibe.http.router;
import vibe.http.server;
import vibe.http.websockets;


import mysql.connection;

import api.V1;

void setupServer()
{
	auto router = new URLRouter;
    registerRestInterface(router, new V1API(), "api");

	router.get("/", staticRedirect("/index.html"));
	router.get("/ws", handleWebSockets(&handleWebSocketConnection));
    
    // This needs to be last, or it will assume everything is a static file
    router.get("*", serveStaticFiles("public/"));

    foreach (route ; router.getAllRoutes)
    {
        std.stdio.writeln(route);
    }

    auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["127.0.0.1"];
	listenHTTP(settings, router);
}

void handleWebSocketConnection(scope WebSocket socket)
{
	int counter = 0;
	logInfo("Got new web socket connection.");
	while (true) {
        logInfo("tick");
		sleep(1.seconds);
		if (!socket.connected) break;
		counter++;
	}
	logInfo("Client disconnected.");

}

shared static this()
{
    setupServer();
}

