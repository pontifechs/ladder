

define(['lib/react', 'components/Chat', 'components/Header'], function(React, Chat, Header) {


    var messages = [
        {
            "username" : "WHATHOWISTHISNAMESOFREAKINGLONGBob", "message" : "Message one"
        },
        {
            "username" : "Sue",
            "message" : "awoinboaerinbaoeibni aoeitnbl;krtnblk;fnb;ldkfnhm; dfiohnosfingjopidhsf;lkasdnf;lkansdflk;jansdoiufhnapoebna;eltknbsal;kbnl;dnfb;lkgfnboisnsbo"
        },
        {
            "username" : "Frank",
            "message" : "Message three"
        }
    ];



    var App = React.createClass({
        render: function() {
            return (
                <div>
                    <Header/>
                    <div id="main-ui">
                        <div className="two-column-layout">
                            <div className="left-column">
                            </div>
                            <div className="right-column" id="main-column">
                                <Chat messages={messages}/>                         
                            </div>
                            <div className="clear"></div>
                        </div>
                    </div>
                </div>
            );
        }
    });

    return App;
});

