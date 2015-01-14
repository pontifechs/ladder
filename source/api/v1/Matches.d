module api.v1.Matches;

import vibe.data.json;
import vibe.http.rest;
import vibe.http.server;

import api.Common;
import api.v1.Auth;

import db.User;


@rootPathFromName
interface Matches
{
    @after!setHTTPStatusCode()
    Json get();

    @before!authenticate("user")
    @after!setHTTPStatusCode()
    Json create(User user);
    

}

class MatchesAPI : Matches
{
override:
    Json get()
    { return Json.emptyObject;
    }

    Json create(User user)
    {
        std.stdio.writeln(user);
        return Json.emptyObject;
    }
}

