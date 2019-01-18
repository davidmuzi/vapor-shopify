
function init(domain, apiKey) {
	var AppBridge = window['app-bridge'];
	var createApp = AppBridge.default;
	var actions = AppBridge.actions;
	
	var app = createApp({
						apiKey: apiKey,
						shopOrigin: domain,
						forceRedirect: true
						});
	
	app.getState().then((state) => {
						console.info('App State: %o', state)
						});
	
	var Button = actions.Button;
	var Redirect = actions.Redirect;
	
	var breadcrumb = Button.create(app, {label: 'Products'});
	breadcrumb.subscribe(Button.Action.CLICK, () => {
						 app.dispatch(Redirect.toApp({path: '/products'}));
						 });
	
	
	const saveButton = Button.create(app, {label: 'Save'});
	saveButton.subscribe(Button.Action.CLICK, () => { console.log("x") })
	
	var titleBarOptions = {title: 'Vapor - Products', breadcrumbs: breadcrumb, buttons: { primary: saveButton, }};
	
	var myTitleBar = actions.TitleBar.create(app, titleBarOptions);
	
	const toastOptions = {
		message: 'Product saved',
		duration: 5000,
	};

	const toastNotice = actions.Toast.create(app, toastOptions);
	toastNotice.subscribe(actions.Toast.Action.SHOW, data => {
						  // Do something with the show action
						  console.log("Show")
						  });
	
	toastNotice.subscribe(actions.Toast.Action.CLEAR, data => {
						  // Do something with the clear action
						  console.log("done")
						  });
	
	// Dispatch the show Toast action, using the toastOptions above
	toastNotice.dispatch(actions.Toast.Action.SHOW);
}
