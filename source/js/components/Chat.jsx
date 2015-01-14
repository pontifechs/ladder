
define(['lib/react'], function(React) {

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
    render : function() {
        var messages = []; 

        this.props.messages.forEach(function (entry) {
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
