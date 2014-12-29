module api.Users;

import vibe.data.json;
import vibe.http.rest;
import vibe.http.server;

import api.Common;

interface Users 
{
    @after!setHTTPStatusCode()
    Json getSession(string username, string password);

    @path("users")
    @after!setHTTPStatusCode()
    Json getAllUsers();

    @path("users")
    @after!setHTTPStatusCode()
    Json createUser(string username, string password); 

}

class UsersAPI : Users
{
import dcrypto.evp;
import std.datetime;
import std.base64;
import mysql.connection;

private:
    static EVPEncryptor encryptor;
    static EVPDecryptor decryptor;
    
    static Connection conn;

public:
    static this()
    {
        // TODO:: Get this in by config or something
        auto key = keyFromSecret("
o/Zj5vtN8NcLbLlwlLqg07iP/SU2LQ2mVue+Ca8oT5uobkgBSlEQZwqu93S03lMR
73UakMHb4amdXSYYGCrhfkdZCVNEGfJRCdma1MoLmJV10dYAjFRcjIUA2Wv7Y4ce
N3TsL30rCxMshMOgjMnrdv9Ymtz3moG3v+dzc2NhFBu2HlSFeMnJwYTRogB298q7
Kpw5mFEW8OAk+RQkT2fa14IteKQ8sozX9S/VwpGf3Y/TdIrRu490ZnpyxzDyPJ/i
+BTTa9CL/c1m7219XU/SBFmXO5teUzRYFX5dS1npHplkAlLE36FXHwGJTF7tCtyL
vt+5Mk0I7C7bulzBt9zypo7SXRotLQ79ibYD68vOjxm5IIGV6z2Gl6d/4lfzdFxE
zotaZXqBJ3APXxEOqpG8Av5gEEASvWyZklAAtDA5T+vg6LoiakV4Cuq3MymdjcOr
IabL3i+1c4nffsABQmXiaVw2sDPv5OLirvXrFIrtZLwSyltFWgwwc6uAohKDtCaU
bYmcg5GpzmXXK/T6qpOCDqTvnnm0V9OpF+uQ19HaDEX3V6ILw6S9V4giLdcJwQIY
+s6CcQE8gfLDdP8ASGCg5P3JeUC2jn2SK+qeZdUrl7K8wYXWbGkrjGfhMwIzzdvn
ubKTyLjkGzniNiERSEXSW80ZaGkBDYK5yizTmJvyEB4QpBsPql1O+Zo0veLZD3Rs
E+hDNK7F9janT0+DEmBt7myQhJwhvm9TJRhab+/GrPTHPVbYCmRQGl3+EvxFZAzE
hmlg5yC9z4VGgfiluSDJC9MU0Z5Z5S1VtFy9FVKZiUdsNnBZlLt1IAfYsZp4mEuh
l/AhSyvU3k6rJ4hZVT9zY/xnk7LQ1jzgCQavg88Upoxmje7nCer9Nn6puWIRtLQR
PydUTV7ptMkNzeMa5SgQqb3pPTK998cIVKhKavsKvXFe8+/lsUzaBhQH4vItfOW/
BEwsoVwPvyDfWq95AbbnRNlLYOVAhNU6DMqIqwf88zBZlNpFnP42clWiOpIbwkKc
kvy9QCBywArr+C01Js4lHO+ufQ7TdVb+Fb45zTL/O90tLyBb45Tg7NnEbz+KUy3s
RvWgDzdXGZxrv1PZM44Vzh8y387zHnLp2BhhOQNnDgU8FU0ZOcszJgRjgfQlAoeb
fIOEuQYcG63Oo0vw8ZY0mtGHnRSxrY6d8i6quiQdw2upL+PkrHI8tBjKy6sDcZJj
5c54YFBmx1cWAmpuxigHyDnCmHONdjMV7pu+Z6b83eT9PrVwnBvMYS8e2HpS4EkH
7SfpR5T4Onkg0kjDbbBCKv59tCaOOgh1Lj68le0CZBteTKtIRQqChfqukXbeD2nE
D5q06N1v9aaetpXO23fHYAgoYv+8w0+TchNJ63Inhse90KBONl7+8U/Dhl9J4WTi
PlZQkEKUkRNQ7qZrH1J7mjvKp+WGR7rE6q0KVF4VD5ZrUofT1y+3+RtZEBbnPZQe
/6qtxyTARY8TLMykcKVfEeaXnsGpuWsh08gxTnYmudW3bierel0s1SieU38GOr6d
SiphV704zPvTSUsG8iKHUV57ppRtUNhWeP3FM1xSMnEmBmWLRr+Nzqef13xaxzFh", "MMTASTYSALT");

        encryptor = new EVPEncryptor(key);
        decryptor = new EVPDecryptor(key);

        import mysql.db;
        auto mdb = new MysqlDB("host=localhost;port=3306;user=mdudley;pwd=9876ar25;db=ladder");
        conn = mdb.lockConnection();
    }

    static ~this()
    {
        conn.close();
    }

    static bool isValidAuthToken(string auth)
    {
        import std.array;
        import std.conv;
        
        auto plainTextAuth = decryptor.decrypt(cast(immutable char[])Base64.decode(auth));
        auto authComponents = plainTextAuth.split("|||");
        if (authComponents.length != 2)
        {
            return false;
        }

        auto issueTime = SysTime.fromISOString(authComponents[0]);
        auto duration = authComponents[1].to!(long);
        return Clock.currTime <= issueTime + dur!"seconds"(duration);
    }

    private static string generateAuthToken(long secs)
    {
        auto authToken = Clock.currTime.toISOString() ~ "|||" ~ secs.to!string;
        return Base64.encode(cast(ubyte[])encryptor.encrypt(authToken));    
    }

override:

    Json getSession(string username, string password)
    {
        auto ret = Json.emptyObject;
                
        // Get the user record from the db;
        auto userLookupCmd = Command(conn, "select password, salt from users where username = ?");
        userLookupCmd.prepare();
        userLookupCmd.bindParameterTuple(username);
        auto userLookupResult = userLookupCmd.execPreparedResult().asAA;
        auto salt = userLookupResult["salt"].value.get!string;
        auto encPass = userLookupResult["password"].value.get!string;
        
        auto encGivenPass = Base64.encode(cast(ubyte[])encryptor.encrypt(password ~ salt));
        if (encPass == encGivenPass)
        {
            ret.authToken = generateAuthToken(1800);
            return ret;
        }

        // TODO:: More standardized error handling
        ret.status = HTTPStatus.unauthorized;
        ret.error = "Invalid Credentials";
        return ret;
    }
 
    Json getAllUsers()
    {
        // TODO:: Implement
        return Json.emptyObject;
    }

    Json createUser(string username, string password)
    {
        import std.regex;
        import vibe.crypto.cryptorand;
        import std.variant;
        
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
       
        // TODO:: Make some wrapper functions for this mysql stuff. Or maybe look into hibernateD?
        // Check username availability
        auto nameAvailableCmd = Command(conn, "select count(1) as ans from users where username = ?");
        nameAvailableCmd.prepare();
        nameAvailableCmd.bindParameterTuple(username);
        auto nameAvailableResult = nameAvailableCmd.execPreparedResult().asAA; 
        if (nameAvailableResult["ans"].value >= 1)
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

        // Encrypt the password
        auto encPassword = Base64.encode(cast(ubyte[])encryptor.encrypt(to!string(password ~ salt)));

        auto insertSql = "insert into users (username, password, salt) values (?, ?, ?)";
        auto insertCommand = Command(conn, insertSql);
        insertCommand.prepare();
        insertCommand.bindParameterTuple(username, encPassword, salt);
        ulong rowsAffected = 0;
        insertCommand.execPrepared(rowsAffected);
        
        if (rowsAffected != 1)
        {
            ret.status = 500;
            ret.error = "Sql Error ";
            return ret;
        }

        // Everything went groovy.
        ret.userId = insertCommand.lastInsertID;
        return ret;
    }
}

unittest
{
    import core.thread;
    
    auto token = AuthenticationAPI.generateAuthToken(1);
    assert(AuthenticationAPI.isValidAuthToken(token), "Fresh token invalid!");
    Thread.sleep(dur!"seconds"(2));   
    assert(!AuthenticationAPI.isValidAuthToken(token) ,"Expired token valid!");
}

