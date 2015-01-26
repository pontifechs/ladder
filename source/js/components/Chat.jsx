
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


var ChatInput = React.createClass({
    render : function() {
        return (
            <input className="chat-input-line" type="text" 
                   placeholder={!Auth.loggedIn() ? "You must login first." : ""}/>
        );
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
    },

});

return React.createClass({
    
    getInitialState : function() {
        return {messages : this.props.messages};
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
                <ChatInput/>
            </div>
        );
    }
});
});
