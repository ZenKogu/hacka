template \login -> div class:'container login_form', 
	error_message that if pageSession.get \ErrorMessage
	if Meteor.userId! => login_message!

	else form id:\login_form class:\account-form role:\form,

		if currentID! == \login    => h2 'Вход в систему', small a class:'btn btn-info' style:'margin-left:10px;float:right' href:'/register', 'Хочу зарегистрироваться'
		if currentID! == \register => h2 'Регистрация',    small a class:'btn btn-info' style:'margin-left:10px;float:right' href:'/login', 'У меня уже есть логин'

		

		div id:"login-with-password" style:"padding-top: 10px;",
			input id:"login_email" type:"text" class:"form-control" placeholder:"Email" required:"" autofocus:""
			if currentID! == \register => input id:"login_name"  type:"text" class:"form-control" placeholder:"Name" required:"" autofocus:""
			input id:"login_password" type:"password" class:"form-control" placeholder:"Пароль" required:""
			button class:"btn btn-lg btn-primary btn-block" type:"submit" data-loading-text:"Пожалуйста, подождите...", 'Войти'		 


error_message =-> 
	div class:'alert alert-danger alert-dismissible' role:\alert,
		button class:\close \data-dismiss :\alert, i class:'fa fa-close'
		strong 'Error. '
		it

login_message =-> h2 Meteor?user()?username+\,, small " вы уже на месте."

Template.login.rendered =-> $('input[autofocus]').focus!
Template.login.created  =-> 
	pageSession.set \errorMessage ''


Template.login.helpers errorMessage:-> pageSession.get \errorMessage
Template.login.events do
	'submit #login_form': (e, t)->
		e.preventDefault!
		pageSession.set \errorMessage ''
		submit_button  = $ t.find \:submit
		login_email    = t.find \#login_email    .value.trim!
		login_password = t.find \#login_password .value
		if currentID! == \register => login_name     = t.find \#login_name     .value
		
		if !isValidEmail login_email # check email
			pageSession.set \errorMessage 'Пожалуйста, введите адрес почты.'
			t.find \#login_email .focus!
					
		if login_password == ''  # check password
			pageSession.set \errorMessage 'Пожалуйста, введите пароль.'
			t.find \#login_email .focus!
			false

		submit_button.button \loading 

		if currentID! == \login => Meteor.loginWithPassword login_email, login_password, (err)->
			submit_button.button \reset
			if err => pageSession.set \errorMessage, err
			else Router.go \/

		if currentID! == \register => Meteor.call 'createUserAccount', {email:login_email; password:login_password; username:login_name; roles:'1'}, (err)->
			submit_button.button \reset
			if err => pageSession.set \errorMessage err
			else Router.go \/