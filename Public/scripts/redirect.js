function redirect(apiKey, domain, url) {
	var AppBridge = window['app-bridge'];
	var createApp = AppBridge.default;
	var actions = AppBridge.actions;
	const redirectAction = actions.Redirect;
	
	var app = createApp({apiKey: apiKey, shopOrigin: domain});
	
	const action = redirectAction.create(app);
	action.dispatch(redirectAction.Action.REMOTE, url);
}
