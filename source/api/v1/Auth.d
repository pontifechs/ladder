module api.v1.Auth;

import std.array;
import std.base64;

import vibe.data.json;
import vibe.web.rest;
import vibe.http.server;

import db.User;

import api.Common;

static User authenticate(HTTPServerRequest request, HTTPServerResponse response)
{
    auto token = AuthToken(request.headers["Authorization"]);
    return token.user;
}

class InvalidAuthTokenException : Exception
{
    import std.string;
    this(T...)(string msg, T args)
    {
        super(format(msg, args));
    }
}

class AuthTokenExpiredException : Exception
{
    import std.string;
    this(T...)(string msg, T args)
    {
        super(format(msg, args));
    }
}

struct AuthToken
{
    import std.datetime;
    import std.conv;

    User user;
    SysTime issueTime;
    long duration;

    this(string auth)
    {
        auto plainTextAuth = AuthAPI.decryptor.decrypt(cast(immutable char[])Base64.decode(auth));
        auto authComponents = plainTextAuth.split("|||");
        if (authComponents.length != 3)
        {
            throw new InvalidAuthTokenException("Invalid Auth Token");
        }

        this.user = User.byId(authComponents[0].to!(long));
        this.issueTime = SysTime.fromISOString(authComponents[1]);
        this.duration = authComponents[2].to!(long);

        if(!valid())
        {
            throw new AuthTokenExpiredException("Auth token expired. Please generate a new one.");
        }
    }

    this(User user, long duration)
    {
        this.user = user;
        this.duration = duration;
        this.issueTime = Clock.currTime;
    }

    string toString() const
    {
        auto authToken = user.id.to!string ~ "|||" ~ Clock.currTime.toISOString() ~ "|||" ~ duration.to!string;
        return Base64.encode(cast(ubyte[])AuthAPI.encryptor.encrypt(authToken));    
    }

    bool valid() const
    {
        return Clock.currTime <= this.issueTime + dur!"seconds"(this.duration);              
    }
}

@rootPathFromName
interface Auth
{   
    @after!setHTTPStatusCode()
    Json get(string username, string password);

    @after!setHTTPStatusCode()
    Json post(string username, string password);
}



class AuthAPI : Auth
{
    import dcrypto.evp;
    import std.digest.sha;
    
private:
    static EVPEncryptor encryptor;
    static EVPDecryptor decryptor;
     
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
    }


public:
override:

    Json get(string username, string password)
    {
        auto ret = Json.emptyObject;
        auto user = User.byEmail(username);

        auto hashedGivenPass = Base64.encode(sha512Of(password ~ user.salt));
        if (user.password == hashedGivenPass)
        {
            auto token = AuthToken(user, 1800);
            ret.authToken = token.toString();
            return ret;
        }

        // TODO:: More standardized error handling
        ret.status = HTTPStatus.unauthorized;
        ret.error = "Invalid Credentials";
        return ret;
    }

    Json post(string username, string password)
    {
        return get(username, password);
    }
}
