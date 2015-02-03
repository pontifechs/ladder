
define(['lib/react', 'services/Auth', 'components/util/Button'], function(React, Auth, Button) {

    var Header = React.createClass({
        render : function() {
            return (
                <div className="header">
                    <div className="content left vertical-center">
                        Guest
                    </div>
                    <div className="content center vertical-center">
                        SirsiDynix Game Ladder!
                    </div>
                    <div className="content right vertical-center">
                        <Button>Sign In!</Button> 
                    </div>
                </div>
            );
        }
    });

    return Header;
});


