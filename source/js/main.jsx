
require.config({
    paths: {
        jquery: 'lib/jquery-2.1.3'
    },
    
});


require(['lib/react', 'components/Chat', 'models/User'], function(React, Chat, User) {

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

    var user = new User();

    var userDetails = {
        username: 'jaime.steren@sirsidynix.com',
        password: 'password'
    };
    
    user.save(userDetails, {
        success: function (user) {
            console.log(user);
        }
    })

    React.render(<Chat messages={messages}/>, document.getElementById('main-column'));    
});




