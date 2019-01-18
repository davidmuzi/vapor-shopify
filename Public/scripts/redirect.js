function redirect(domain, apiKey) {
	var AppBridge = window['app-bridge'];
	var createApp = AppBridge.default;
	var actions = AppBridge.actions;
	const redirect = actions.Redirect;
	
	var app = createApp({
						apiKey: apiKey,
						shopOrigin: domain,
						forceRedirect: true
						});
	
	const path = '/oauth/authorize?client_id=' + apiKey + '&scope=read_products,read_orders&redirect_uri=https://26a9e713.ngrok.io/auth'//&state=399C79' //
	const red = redirect.create(app);
	red.dispatch(redirect.Action.ADMIN_PATH, path);

}
