function redirect(domain, apiKey, redirect) {
	var AppBridge = window['app-bridge'];
	var createApp = AppBridge.default;
	var actions = AppBridge.actions;
	const redirect = actions.Redirect;
	
	var app = createApp({
						apiKey: apiKey,
						shopOrigin: domain,
						forceRedirect: true
						});
	
	const path = '/oauth/authorize?client_id=' + apiKey + '&scope=read_products,read_orders&redirect_uri=' + redirect + '/auth'//&state=399C79' //
	const red = redirect.create(app);
	red.dispatch(redirect.Action.ADMIN_PATH, path);

}
