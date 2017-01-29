template \layout -> body do
	nav class:'navbar navbar-default navbar-custom navbar-fixed-top', D \container-fluid,
		D 'navbar-header page-scroll',
			a class:\navbar-brand href:\/, 				
				img style:'height:100%; margin:0px; padding:0px' src: SVG \soviet-star
			ul class: 'nav navbar-nav navbar-left',
				li a href:\/comrades, \Товарищи
				li a href:\/unions, \Союзы

		ul class: 'nav navbar-nav navbar-right',
			if SB @lookup \isUser 
				li a href:"/comrade/#{Meteor.userId!}", SB @lookup \userEmail
			else 
				li a class:\page-scroll href:\/login, \Вход
	SI @lookupTemplate \yield

Template.layout.helpers do
	\NotEstatesRoute :-> currentID! isnt \estates

Template.layout.events do
	'click .logout':-> Meteor.logout!; Router.go \/ 
