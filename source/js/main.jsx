
require.config({
    paths: {
        jquery: 'lib/jquery-2.1.3'
    },
    
});


require(['lib/react', 'components/Chat'], function(React, Chat, Auth) {

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
    React.render(<Chat messages={messages}/>, document.getElementById('main-column'));    
});




