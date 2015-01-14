module db.GameType;

import mysql.connection;
import db.Common;

class NoSuchGameTypeException : Exception
{
    import std.string;
    this(T...)(string msg, T args)
    {
        super(format(msg, args));
    }
}

struct GameType
{
    private:
        static Connection conn;
        
        static this()
        {
            conn = DB.mysql;
        }
        
        static GameType fillIn(ResultSet rs)
        {
            auto game = rs.asAA;
            return GameType(
                    game["id"].value.get!long,
                    game["name"].value.get!string
                    );
        }

    public:
        long id;
        string name;
        
    static GameType byId(long id)
    {
        auto dbGameType = conn.select("select * from game_types where id = ?", id);
        if (dbGameType.length == 0)
        {
            throw new NoSuchGameTypeException("No such game type for id: ", id);
        }
        return fillIn(dbGameType); 
    }

    static GameType[] all()
    {
        auto dbGameTypes = conn.select("select * from game_types");
        GameType[] gameTypes = [];
        foreach(row ; dbGameTypes)
        {
            GameType g;
            row.toStruct(g);
            gameTypes ~= g;
        }
        return gameTypes;
    }
    
}



