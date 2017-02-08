template \layout -> body do
	nav class:'navbar navbar-default navbar-custom navbar-fixed-top', D \container-fluid,
		D 'navbar-header page-scroll',
			a class:\navbar-brand href:\/, 				
				img style:'height:100%; margin:0px; padding:0px' src: SVG \soviet-star
			ul class: 'nav navbar-nav navbar-left',
				li a href:\/users, \Товарищи
				li a href:\/unions, \Союзы
		if SB @lookup \isUser => ul class: 'nav navbar-nav navbar-right', 
			li a href:"/users/profile/#{Meteor.userId!}", SB @lookup \userEmail
		else ul class: 'nav navbar-nav navbar-right',
			li a class:\page-scroll href:\/register, \Регистрация
			li a class:\page-scroll href:\/login, \Вход
			
	SI @lookupTemplate \yield

Template.layout.helpers \NotEstatesRoute :-> currentID! isnt \estates
Template.layout.events  'click .logout':-> Meteor.logout!; Router.go \/ 


template \start -> D \container, D \jumbotron,
	h1 style:'padding-bottom:10px', 'Время потрудиться' 
	p 'Пришло вреся потрудиться во благо социалистической эволюции. 
	   Вы можете выбрать себе товарищей, союз, или создать свой союз:'
	div class:\container style:'margin:auto;width:400px;',
		B \big-red \/users \Товарищи
		B \big-red \/unions \Союзы

template \loading -> I 'spin fa-2x'

template \notFound -> D \container,
	D \page-header, h2 'Ошибка 404. ' small 'Ресурс не найден'
	B \big-red 'history.back()' \Назад 