  // var options = {
  //     user: 'superjeenee',
  //     pass: 'F*w626#*cD@@@'
  // };

  var getDbConnection = function() {
      // switch (process.env.NODE_ENV) {
      //     case 'development':
      //         var db = mongoose.connect('mongodb://localhost/Ngcourse');
      //         return checkMongooseConnection(db)

      //     case 'production':
      //         var db = mongoose.connect('mongodb://localhost/ngcourse', options);
      //         return checkMongooseConnection(db)

      //     default:
      //         var db = mongoose.connect('mongodb://localhost/ngcourse');
      //         return checkMongooseConnection(db)
      // }
  }


  //function to check connection to database server
  // function checkMongooseConnection(db) {
  //     mongoose.connection.on('open', function(ref) {
  //         console.log('Connected to mongo server.');
  //         return db
  //     });
  //     mongoose.connection.on('error', function(err) {
  //         console.log('Could not connect to mongo server!');
  //         console.log(err);
  //     });
  // }

  module.exports.getDbConnection = getDbConnection;
