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

	while (true) {
		if (!socket.connected) break;

        sleep(1.seconds);

        auto json = Json.emptyObject;
        json.username = "bob";
        json.message = "hey ";
        
        //ChatUser.broadcast(json);
    }
}






