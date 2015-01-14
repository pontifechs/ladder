module api.v1.GameTypes;

import vibe.data.json;
import vibe.web.rest;

import api.Common;

import db.GameType;

@rootPathFromName
interface GameTypes
{
    @after!setHTTPStatusCode()
    Json get();

    @after!setHTTPStatusCode()
    Json get(long id);
}

class GameTypesAPI : GameTypes
{
public:
override:

    Json get()
    {
        auto ret = Json.emptyObject;
        ret.gameTypes = serialize!JsonSerializer(GameType.all);
        return ret;
    }

    Json get(long id)
    {
        return serialize!JsonSerializer(GameType.byId(id));
    }

}


