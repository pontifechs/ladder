

define(['lib/react'], function(React) {
    
    var Button = React.createClass({
        render: function() {
            return (
                <div className="util-button"><div className="vertical-center">{this.props.children}</div></div>
            );
        }
    });

    return Button;
});


