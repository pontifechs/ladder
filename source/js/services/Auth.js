


define(["exoskeleton"], function(Backbone) {

    var AuthModel = Backbone.Model.extend({
        urlRoot: '/api/v1/auth'
    });

    var AuthCollection = Backbone.Collection.extend({
        model: AuthModel
    });


    function Auth() {
        var loggedIn = false;
       
        return {
            authToken : function() {
                return window.localStorage.getItem("authToken");
            },

            user: function() {
                return window.localStorage.getItem("username");
            },
            
            loggedIn : function() {
                return window.localStorage.getItem("authToken") !== null;    
            },

            logIn : function(username, password) {
                // TODO:: Find a better / more secure solution to the remember me problem
            
                var authToken = new AuthModel();
                authToken.fetch({
                    data: {
                        username: username,
                        password: password
                    },
                    success : function() {
     
                        window.localStorage.setItem("username", username);
                        window.localStorage.setItem("authToken", authToken.get("authToken"));
                        return true;
                    },
                    error : function() {
                        return false;
                    },

                    processData: true
                });
            }
        };
    }

    return Auth();

});



