module Chat;


import vibe.data.json;
import vibe.http.websockets;

import db.User;


struct ChatUser 
{
private:

    enum Status
    {
        Connected,
        Authenticated
    }
    
    WebSocket socket;
    Status status;

    User user;

public:
     
    static ChatUser[] allUsers;

    static ChatUser opCall(WebSocket socket)
    {
        ChatUser chatUser;
        chatUser.socket = socket;
        chatUser.status = Status.Connected;
        allUsers ~= chatUser;
        return chatUser; 
    }

    static void broadcast(Json msg)
    {
        foreach (user ; allUsers)
        {
            user.send(msg);
        }
    }

    public void send(Json msg)
    {
        socket.send(msg.to!string);
    }
}


public void handleWebSocketConnection(scope WebSocket socket)
{
    import std.conv;
    import vibe.data.json;
    import vibe.core.log;
    import vibe.core.core: sleep;
    import core.thread; 
    
    auto user = ChatUser(socket);

	while (socket.connected) {
        auto msg = socket.receiveText;
        try
        {
            auto json = parseJsonString(msg);
            std.stdio.writeln(json);
        }
        catch(JSONException e)
        {
            auto response = Json.emptyObject;
            response.msg = "invalid json";
            user.send(response);
            std.stdio.writeln("invalid json: fail");      
            std.stdio.writeln(msg.to!string);
        }
    }
}






