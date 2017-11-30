module.exports = function(app) {
	var controllers = app.controllers,
		views = app.views;

	return {
		"/": [{
			method: "GET",
			action: app.controllers.userController.home,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/deploy": [{
			method: "GET",
			action: app.controllers.userController.setUpDeploy,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/setmaxsupply": [{
			method: "POST",
			action: app.controllers.userController.setMaxSupply,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/setpricesfortokenspereth": [{
			method: "POST",
			action: app.controllers.userController.setPricesForTokensPerEth,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/buytokensthroughethers": [{
			method: "POST",
			action: app.controllers.userController.buyTokensThroughEthers,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/payEthersToContract": [{
			method: "POST",
			action: app.controllers.userController.payEthersToContract,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/selltokens": [{
			method: "POST",
			action: app.controllers.userController.sellTokensFrom,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/sendtokens": [{
			method: "POST",
			action: app.controllers.userController.sendTokens,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/mint": [{
			method: "POST",
			action: app.controllers.userController.mint,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/transfertokens": [{
			method: "POST",
			action: app.controllers.userController.transferTokens,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/approve": [{
			method: "POST",
			action: app.controllers.userController.approve,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/transfertokensFrom": [{
			method: "POST",
			action: app.controllers.userController.transferTokensFrom,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/increaseApproval": [{
			method: "POST",
			action: app.controllers.userController.increaseApproval,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/decreaseApproval": [{
			method: "POST",
			action: app.controllers.userController.decreaseApproval,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/allowance": [{
			method: "POST",
			action: app.controllers.userController.allowance,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/burn": [{
			method: "POST",
			action: app.controllers.userController.burn,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/startFirstICOSale": [{
			method: "GET",
			action: app.controllers.userController.startFirstICOSale,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/getSalesCount": [{
			method: "GET",
			action: app.controllers.userController.getSalesCount,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/getTokenBalance": [{
			method: "POST",
			action: app.controllers.userController.getTokenBalance,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}],
		"/api/v1/userapi/getEtherBalance": [{
			method: "POST",
			action: app.controllers.userController.getEtherBalance,
			middleware: [],
			views: {
				json: views.jsonView
			}
		}]
	};
};
