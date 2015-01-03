module api.v1.Users;

import vibe.data.json;
import vibe.http.rest;
import vibe.http.server;

import api.Common;

import db.User;

@rootPathFromName
interface Users 
{
    @after!setHTTPStatusCode()
    Json get();

    @after!setHTTPStatusCode()
    Json create(string username, string password); 

    @after!setHTTPStatusCode()
    Json get(long id);
}

class UsersAPI : Users
{
public:
override:

    Json get()
    {
        // TODO:: Implement
        return Json.emptyObject;
    }

    Json create(string username, string password)
    {
        import std.regex;
        import std.digest.sha;
        import std.base64;

        import vibe.crypto.cryptorand;

        auto ret = Json.emptyObject;

        if (!username.match(regex(`^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$`)))
        {
            ret.status = 418;
            ret.error = "Invalid username format. Username must be a valid email address";
            return ret;
        }
        
        if (password.length < 8)
        {
            ret.status = 418;
            ret.error = "Password must be at least 8 characters";
            return ret;
        }
       
        // Check username availability
        if (User.existsByEmail(username))
        {
            ret.status = 418;
            ret.error = "Username has already been registered";
            return ret;
        }

        // Make some salt   
        auto rng = new SystemRNG;
        ubyte[96] rand;
        rng.read(rand);
        auto salt = Base64.encode(rand);

        // Hash the password
        auto hashedPass = Base64.encode(sha512Of(password ~ salt));
        
        // Save it off to the DB
        try
        {
            ret.userId = User.create(username, hashedPass.to!string, salt.to!string).id;
        }
        catch(Exception e)
        {
            ret.status = 500;
            ret.error = "Sql Error " ~ e.msg;
            return ret;
        }

        // Everything went groovy.
        return ret;
    }

    Json get(long id)
    {
        auto json = serialize!JsonSerializer(User.byId(id));
        json.remove("password");
        json.remove("salt");
        return json;
    }
}

