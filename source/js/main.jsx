require.config({
    baseUrl: 'js',
    paths: {
        jquery: 'lib/jquery-2.1.3',
    },
    shim: {
        "lib/exoskeleton": {
            deps: ["jquery"],
            exports: "Backbone"  //attaches "Backbone" to the window object
        }
    }
});



require(['lib/react', 'components/Chat', 'lib/exoskeleton'], function(React, Chat, Backbone) {

    var messages = [
        {
            "username" : "WHATHOWISTHISNAMESOFREAKINGLONGBob",
            "message" : "Message one"
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
    console.log(Backbone); 
    
    React.render(<Chat messages={messages}/>, document.getElementById('main-column'));    
});




