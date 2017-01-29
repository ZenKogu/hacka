

Template.\Login = new Template \Template.Login,-> div class:'container login_form', 
	if SB @lookup \isUser => h2 "Вы уже вошли как " + SB @lookup \userEmail
	else form id:\login_form class:\account-form role:\form,
		h2 'Вход в систему'
		if SB @lookup \errorMessage
			div class:'alert alert-warning', 
				Blaze.View \lookup:errorMessage, -> SM @lookup \errorMessage
		div id:"login-with-password" style:"padding-top: 10px;",
			input id:"login_email" type:"text" class:"form-control" placeholder:"Email" required:"" autofocus:""
			input id:"login_password" type:"password" class:"form-control" placeholder:"Пароль" required:""
			button class:"btn btn-lg btn-primary btn-block" type:"submit" data-loading-text:"Пожалуйста, подождите...", 'Войти'		 


pageSession = new ReactiveDict

Template.Login.rendered =-> $('input[autofocus]').focus!

Template.Login.created  =-> pageSession.set \errorMessage ''

Template.Login.helpers errorMessage:-> pageSession.get \errorMessage


Template.Login.events do
	'submit #login_form': (e, t)->
		e.preventDefault!
		pageSession.set \errorMessage ''
		submit_button  = $ t.find \:submit
		login_email    = t.find \#login_email .value.trim!
		login_password = t.find \#login_password .value
		
		if !isValidEmail login_email # check email
			pageSession.set 'errorMessage', 'Пожалуйста, введите адрес почты.'
			t.find('#login_email').focus()
			false
		
		if login_password == ''  # check password
			pageSession.set \errorMessage, 'Пожалуйста, введите пароль.'
			t.find \#login_email .focus!
			false

		submit_button.button \loading
		Meteor.loginWithPassword login_email, login_password, (err)->
			submit_button.button \reset
			if err => pageSession.set \errorMessage, err.message
			else Router.go \/
		

