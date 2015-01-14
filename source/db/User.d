module db.User;

import mysql.connection; 
import db.Common;


class NoSuchUserException : Exception
{
    import std.string;
    this(T...)(string msg, T args)
    {
        super(format(msg, args));
    }
}

struct User
{
    private:
        static Connection conn;

        static this()
        {
            conn = DB.mysql;
        }

        static User fillIn(ResultSet rs)
        {
            return User(
                    rs.asAA["id"].value.get!long,
                    rs.asAA["email"].value.get!string,
                    rs.asAA["password"].value.get!string,
                    rs.asAA["salt"].value.get!string
                    );
        }

    public: 

        long id;
        string email;
        string password;
        string salt;


        // TODO:: Figure out exactly how to get the MySQL error messages from mysql-native when it asplodes
        static User byId(long id)
        {  
            auto dbUser = conn.select("select * from users where id = ?", id);
            if (dbUser.length == 0)
            {
                throw new NoSuchUserException("No such user for id: %s",id);
            }
            return fillIn(dbUser);
        }

        static User byEmail(string email)
        {
            auto dbUser = conn.select("select * from users where email = ?", email);
            if (dbUser.length == 0)
            {
                throw new NoSuchUserException("No such user for email: %s",email);
            }
            return fillIn(dbUser);
        }

        static bool existsByEmail(string email)
        {
            auto dbUser = conn.select("select count(1) from users where email = ?", email);
            return dbUser[0][0] == 1;
        }

        // TODO:: Some sanity-checking here? or leave that to api(biz) layer?
        static create(string email, string password, string salt)
        {
            auto id = conn.insert("insert into users (email, password, salt) values (?, ?, ?)", email, password, salt);
            return User(id, email, password, salt);
        }
}

unittest
{
    import std.exception;
    assertThrown(User.byEmail("one"));
    assertThrown(User.byEmail(null));

    // Insert a dummy, and clean up afterwards
    auto id = User.conn.insert("insert into users (email, password, salt) values(?,?,?)", "one", "two", "three");
    scope(exit) { User.conn.exec("delete from users where id=?", id); }

    User user;
    assertNotThrown(user = User.byId(id), "Error getting the user");
    assert(user.id == id, "Incorrect ID");
    assert(user.email == "one", "Incorrect email");
    assert(user.password == "two", "Incorrect password");
    assert(user.salt == "three", "Incorrect salt");
}


