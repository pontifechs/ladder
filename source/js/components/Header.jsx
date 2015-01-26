
define(['lib/react', 'services/Auth'], function(React, Auth) {


    var Header = React.createClass({
        render : function() {
            return (
                <div className="header">
                    <div className="content left">
                        Guest
                    </div>
                    <div className="content center">
                        SirsiDynix Game Ladder!
                    </div>
                    <div className="content right">
                        Sign in!
                    </div>
                </div>
            );
        }
    });



    return Header;
});


