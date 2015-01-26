
require.config({
    paths: {
        jquery: 'lib/jquery-2.1.3'
    }
});

require(['lib/react', 'components/App'], function(React, App) {
    React.render(<App/>, document.body);    
});


