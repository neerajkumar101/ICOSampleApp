//add Roles in the system
var roles = ['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SUPERADMIN', 'ROLE_SUPPORT']

// Add different accessLevels
var accessLevels = {
    'anonymous': ['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SUPERADMIN', 'ROLE_SUPPORT'],
    'user': ['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SUPERADMIN', 'ROLE_SUPPORT'],
    'support': ['ROLE_ADMIN', 'ROLE_SUPERADMIN', 'ROLE_SUPPORT'],
    'admin': ['ROLE_ADMIN', 'ROLE_SUPERADMIN'],
    'superadmin': ['ROLE_SUPERADMIN']
}

var configVariables = function() {
    switch (process.env.NODE_ENV) {
        case 'development':
            var config = {
                port: 3003,
                host: 'http://localhost:3003/',
                adminhost: 'http://localhost:3000/',
                upload: 'https://staging.jeenees.com/upload/user/',
                verificationUrl: 'https://localhost:3000/verify/',
                awsAccessKeyId: '',
                awsSecretAccessKey: '',
                bucketname: '',
                emailFrom: '"Jeenees" <noreply@jeenees.com>',
                emailUser: 'jeeneesmail@gmail.com',
                emailPass: 'oodles@951',
                verificationEmailSubject: 'Welcome To Jeenees !',
                Merchant_Id: '87842',
                Working_Key: 'A365B26A127A3E3248B4913ADABCADC1',
                Redirect_Url_Payment_GateWay: 'https://localhost:3000/ccavResponseHandler',
                ccAvenueUrl: "https://test.ccavenue.com/transaction/transaction.do?command=initiateTransaction",
                'appID': '155821328129239',
                'appSecret': '391eca3fc17cd69f336de25c50ffd1a1',
                'callbackUrl': 'https://localhost:3000/login/facebook/callback',
                'apnGateway': 'gateway.sandbox.push.apple.com',
                'apnPfx': 'DevelopmentPushNotificationCertificates.p12',
                'ccAvenueWorkingKey': 'D79FB9C9D8B68354F7471CD91FE1DD09',
                'ccAvenueAccessCode': 'AVCW00DK77AW52WCWA',
                gcmApiKey: 'AIzaSyDIYTc7XB9nmkVo9rddYRi-Que7ponbo_0',
                fcmAPIKey: 'AAAAGldU5wQ:APA91bFFsJDHugYmZomFjpOWiLfE0K66PdSNt1oJsAFFEJwexyl2cAVDE1XOdEBYAVBTTRe92iBBM3rP2jGJ2UMQBTBa7TDiS-weEChY_O8lMKzMCUO67XSRV4s0RbhV57Hg4jpPVW8L',
                dbUser: 'superjeenee',
                dbPass: 'F*w626#*cD@@@',
                jeeneesMargin: '6',
                emailBCC: ''

            }
            config.roles = roles
            config.accessLevels = accessLevels
            return config;



        case 'production':
            var config = {
                port: 3003,
                host: 'https://admin.jeenees.com/',
                adminhost: 'https://admin.jeenees.com/',
                upload: 'https://admin.jeenees.com/upload/user/',
                verificationUrl: 'https://api.jeenees.com/api/v1/userapi/verify/',
                awsAccessKeyId: '',
                awsSecretAccessKey: '',
                bucketname: '',
                amazonAccessKeyId: 'AKIAINTW4WYKG6NHCWYA',
                amazonSecretId: 'nY0KtvfbjXBoJTzyQX6CsONzO+U+gVXJo+HRH52U',
                amazonAssociateId: '123412340d-20',
                emailFrom: '"Jeenees" <noreply@jeenees.com>',
                emailUser: 'jeeneesmail@gmail.com',
                emailPass: 'oodles@951',
                verificationEmailSubject: 'Welcome To Jeenees !',
                merchantname: 'roo_87842',
                Merchant_Id: '87842',
                Working_Key: 'A365B26A127A3E3248B4913ADABCADC1',
                ccAvenueUrl: "https://secure.ccavenue.com/transaction/transaction.do?command=initiateTransaction",
                Redirect_Url_Payment_GateWay: 'https://182.71.214.254:3000/ccavResponseHandler',
                'apnGateway': 'gateway.push.apple.com',
                'apnPfx': 'JeeneesProductionPushNotificationCertificate.p12',
                'ccAvenueWorkingKey': '62B2A45AEE494C42220F4FB2028F9205',
                orderUrl: 'http://login.ccavenue.com/apis/servlet/DoWebTrans',
                'ccAvenueAccessCode': 'AVJN63DB87AH15NJHA',
                confirmOrder: 'confirmOrder',
                gcmApiKey: 'AIzaSyDIYTc7XB9nmkVo9rddYRi-Que7ponbo_0',
                dbUser: 'superjeenee',
                dbPass: 'F*w626#*cD@@@',
                jeeneesMargin: '6',
                emailBCC: ''

            }

            config.roles = roles
            config.accessLevels = accessLevels
            return config;





    }
}


module.exports.configVariables = configVariables;
