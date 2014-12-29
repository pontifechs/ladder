import vibe.d;

import vibe.http.fileserver;
import vibe.http.router;
import vibe.http.server;

import mysql.connection;


// API
import api.Users;


void setupServer()
{
	auto router = new URLRouter;
	registerRestInterface(router, new UsersAPI());
    
    // This needs to be last, or it will assume everything is a static file
    router.get("*", serveStaticFiles("public/"));

	std.stdio.writeln(router.getAllRoutes);
    
    auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["127.0.0.1"];
	listenHTTP(settings, router);
}

shared static this()
{
    setupServer();
}
