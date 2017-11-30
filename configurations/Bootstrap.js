    var initApp = function() {
        // console.log("config" + configurationHolder.config.accessLevels["anonymous"]);
        // createSuperAdmin()
        bootApplication();

    }

    // function createSuperAdmin() {
    //     var saltString = uuid.v1()
    //     var password = crypto.createHmac('sha1', saltString).update("F*w626#*cD@@@").digest('hex')

    //     domain.User.findOne({
    //         email: 'superadmin@jeenees.com',
    //         deleted: false
    //     }, function(err, doc) {
    //         if (!err && doc == null) {
    //             var superAdminUser = new domain.User({
    //                 fullName: 'SuperAdmin',
    //                 email: 'superadmin@jeenees.com',
    //                 salt: saltString,
    //                 password: password,

    //             })

    //             superAdminUser.save(function(err, user) {
    //                 if (err) {
    //                     console.log(err);
    //                 } else {
    //                     bootApplication()
    //                 }
    //             })
    //         } else {
    //             bootApplication()
    //         }
    //     });
    // }


    // code to start the server
    function bootApplication() {
        console.log("Express server listening on port %d in %s mode");
        console.log("loading files succesfully")
        console.log("server started on port 3003 ...")
        console.log("...")
        console.log("done .!!")

        app.listen(3003, function() {

        });


    }

    module.exports.initApp = initApp
