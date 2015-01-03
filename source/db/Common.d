module db.Common;

import mysql.connection;
import mysql.db;

struct DB
{
private:
    static MysqlDB mdb;

public:
    static this()
    {
        // TODO:: Get this in by config

        version(unittest)
        {
            mdb = new MysqlDB("host=localhost;port=3306;user=mdudley;pwd=9876ar25;db=ladder_test");
        }
        else 
        {
            mdb = new MysqlDB("host=localhost;port=3306;user=mdudley;pwd=9876ar25;db=ladder");
        }
    }

    static Connection mysql()
    {
        return mdb.lockConnection();
    }
}



public static long insert(T...)(Connection conn, string statement, T args)
{
    auto command = Command(conn, statement);
    command.prepare();
    command.bindParameterTuple(args);
 
    auto ra = 0UL;
    command.execPrepared(ra);
    return command.lastInsertID;
}

public static ResultSet select(T...)(Connection conn, string statement, T args)
{
    auto command = Command(conn, statement);
    command.prepare();
    command.bindParameterTuple(args);

    return command.execPreparedResult();
}

public static ulong exec(T...)(Connection conn, string statement, T args)
{
    auto rowsAffected = 0UL;
    auto command = Command(conn, statement);
    command.prepare();
    command.bindParameterTuple(args);
    
    command.execPrepared(rowsAffected);
    return rowsAffected;
}



unittest
{
    // Insert a dummy
    auto conn = DB.mysql;

    conn.insert("insert into users (email, password, salt) values(?, ?, ?)", "one", "two", "three");
    
    auto result = conn.select("select * from users where email=?", "one");
    assert(result.length == 1, "Didn't catch a single result from users");
    assert(result.asAA["email"].value.get!string=="one");

    // Clean up
    conn.exec("delete from users where email=?", "one"); 
}
