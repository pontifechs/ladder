

define(["exoskeleton"], function(Exoskeleton) {
    
    var User = Exoskeleton.Model.extend({
        urlRoot: '/api/v1/users'
    });

    return User;
});

