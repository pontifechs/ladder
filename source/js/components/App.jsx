

define(['lib/react', 'components/Chat', 'components/Header', 'components/util/TwoColumnLayout', 'components/AvailableGames'], 
        function(React, Chat, Header, TwoColumnLayout, AvailableGames) {


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

            var navBar = (
                <div className="nav-bar">
                    <div>Links</div>
                    <div>Links</div>
                    <div>Links</div>
                    <div>Links</div>
                </div>
            );

            var content = (
                <TwoColumnLayout leftBody={<Chat messages={messages}/>}
                                 rightBody={<AvailableGames/>}
                                 leftWidth={2}
                                 rightWidth={3}/>
            );


            return (
                <div style={{'height' : '100%;'}}>
                    <Header/>
                    <div id="main-ui">
                        <TwoColumnLayout leftBody={navBar} 
                                         rightBody={content}
                                         leftWidth={1}
                                         rightWidth={12}/>
                    </div>
                </div>
            );
        }
    });

    return App;
});

