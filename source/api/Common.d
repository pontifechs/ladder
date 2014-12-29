module api.Common;

import vibe.data.json;
import vibe.http.server;

/**
 * Convenience method (which should really be in the Json struct, IMO)
 */
public static bool hasKey(Json obj, string key)
{
    return obj[key].type != Json.Type.Undefined;    
}

/**
 * For use with APIs which can generate Response codes. Simply set the "status" variable, and it will
 * be stripped out and used as the HTTP Status Code.
 */
public static Json setHTTPStatusCode(Json result, HTTPServerRequest request, HTTPServerResponse response)
{
    HTTPStatus status = HTTPStatus.ok;
    if (result.hasKey("status"))
    {
        status = result.status.get!HTTPStatus;
        result.remove("status");
    }
    response.writeJsonBody(result, status);
    return result;
}



