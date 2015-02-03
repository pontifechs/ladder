

define(['lib/react'], function(React) {
    
    var TwoColumnLayout = React.createClass({

        getDefaultProps: function() {
            return {
                leftWidth : 1,
                rightWidth : 1
            };
        },

        render: function () {
                        
            var totalWidth = this.props.leftWidth + this.props.rightWidth;

            var containerStyle = {
                height: '100%',
                width: '100%'
            };

            var leftStyle = {
                width: (this.props.leftWidth / totalWidth) * 100 + '%',
                height: '100%',
                position: 'absolute',
            };

            var rightStyle = {
                marginLeft: (this.props.leftWidth / totalWidth) * 100 + '%',
                float: 'left',
                height: '100%',
                width: (this.props.rightWidth / totalWidth) * 100 + '%',
            }

            
            return (
                <div style={containerStyle}>
                    <div style={leftStyle}>
                        {this.props.leftBody}
                    </div>
                    <div style={rightStyle}>
                        {this.props.rightBody}
                    </div>
                    <div className="clear"/>
                </div>
            )
        }
    });

    return TwoColumnLayout
});
