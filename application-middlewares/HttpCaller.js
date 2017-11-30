module.exports.HttpCaller = (function () {

   
    var get = function (url, next) {
        request.get({
                    url:url,
                    headers: {
                        'Content-Type': 'application/json'
                    },
                }, function(error, res){
                 //   console.log("Response  ", res.body);
            if(res == null){
                    var result_data = null;
            }else{
                var result_data = JSON.parse(res.body);
            }
                    next(error, result_data)
            })
    }
    var post = function (url, data, next) {
        request.post({
                    url:url,
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: data
                }, function(err, res){
                    result = res.body
                    var result_data = JSON.parse(result);
                    next(result_data.error, result_data)
            })
    }
    var put = function (url, data, next) {
        request.put({
                    url:url,
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: data
                }, function(error, res){
                    result = res.body
                    var data = JSON.parse(result);
                    next(data.error, data)
            })
    }

    var get_with_access_token = function (url, access_token, next) {
        request.get({
                    url:url,
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': access_token
                    }
                }, function(error, res){
                    console.log("Response  ", res.body)
                    next(error, res.body)
            })
    }
    var post_with_access_token = function (url, data, access_token, next) {
        request.post({
                    url:url,
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': access_token
                    },
                    body: data
                }, function(error, res){
                    result = res.body
                    var data = JSON.parse(result);
                    next(data.error, data)
            })
    }
    var put_with_access_token = function (url, data, access_token, next) {
        request.put({
                    url:url,
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': access_token
                    },
                    body: JSON.stringify({user:data.user})
                }, function(error, res){
                    result = res.body
                    var data = JSON.parse(result);
                    next(data.error, data)
            })
    }

    //public methods are  return
    return {
        get: get,
        post: post,
        put: put,
        get_with_access_token:get_with_access_token,
        post_with_access_token:post_with_access_token,
        put_with_access_token:put_with_access_token
    };
})();
