function redirect(apiKey, domain, authURL) {
	var AppBridge = window['app-bridge'];
	var createApp = AppBridge.default;
	var actions = AppBridge.actions;
	const redirectAction = actions.Redirect;
	
	var app = createApp({
						apiKey: apiKey,
						shopOrigin: domain,
						forceRedirect: true
						});
	
	const action = redirectAction.create(app);
	action.dispatch(redirectAction.Action.REMOTE, authURL);
}
