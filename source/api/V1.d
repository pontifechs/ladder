module api.V1;

import vibe.web.rest;

import api.v1.Auth;
import api.v1.Users;
import api.v1.GameTypes;
import api.v1.Matches;

@rootPathFromName
interface V1
{
    @path("")
    @property Auth auth();
    @path("")
    @property Users users();
    @path("")
    @property Matches matches();
    @path("")
    @property GameTypes gameTypes();   
}

class V1API : V1
{
private:
    Auth _auth;
    Users _users;
    Matches _matches;
    GameTypes _gameTypes;

public:
    this()
    {
        _auth = new AuthAPI();
        _users = new UsersAPI();
        _matches = new MatchesAPI();
        _gameTypes = new GameTypesAPI();
    }

    @property Auth auth()
    {
        return this._auth;
    }

    @property Users users()
    {
        return this._users;
    }

    @property Matches matches()
    {
        return this._matches;
    }

    @property GameTypes gameTypes()
    {
        return this._gameTypes;
    }
}



