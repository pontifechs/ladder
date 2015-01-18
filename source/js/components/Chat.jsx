
define(['lib/react', 'services/Auth'], function(React, Auth) {

var ChatLine = React.createClass({
    render : function() {
        return (
            <div className="chat-line clear">
                <div className="chat-user">{this.props.username}:</div>
                <div className="chat-message">{this.props.message}</div>
            </div>
        );
    }
});

return React.createClass({
    
    getInitialState : function() {
        return {messages : this.props.messages};
    },

    componentDidMount : function() {
        this.ws = new WebSocket("ws://127.0.0.1:8080/ws");
        this.ws.onmessage = this.onWebSocketMessage; 
    },

    onWebSocketMessage : function(e) {
        var data = JSON.parse(e.data);
        var messages = this.state.messages;
        messages.push({username: data.username, message: data.message});
        this.setState({messages: messages});
        console.log(React);
        console.log(Auth);
        console.log(Auth.loggedIn());
    },

    render : function() {
        var messages = []; 

        this.state.messages.forEach(function (entry) {
            messages.push(<ChatLine username={entry.username} message={entry.message}/>);
        });

        return (
            <div>
                <div className="chat-area">
                    {messages}
                </div>
                <input className="chat-input-line" type="text"/>
            </div>
        );
    }
});
});
