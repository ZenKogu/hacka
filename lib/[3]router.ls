@currentID=-> last split \/, Router.current!originalUrl

@RouterInit = (admSection, mainSub=[], editSub=[], insertSub=[])~> do
	Router.route admSection,
		path: admSection
		controller: RouteController.extend do
			template: capitalize(admSection)
			action: ->    
				template = AccessQ(Meteor.userId!, '', admSection, \read)
				if not template then @render! else @render template
		waitOn: ->  subsSet flatten [mainSub, admSection]
		data: -> data = 
			params: @params || {}
			"#{admSection}": eval "#{capitalize(admSection)}.find({})"

	Router.route admSection + \.insert,
		path: admSection + \/insert
		controller: RouteController.extend do
			template: capitalize(admSection) + \Edit
			action: ->    
				template = AccessQ(Meteor.userId!, '', admSection, \edit)
				if not template then @render! else @render template
		waitOn: ->  subsSet flatten [mainSub, admSection]
		data: -> data = 
			params: @params || {}
			"#{admSection}": eval "#{capitalize(admSection)}.find({})"

	Router.route admSection + \.edit,
		path: admSection + "/edit/:#{initial(admSection)}Id"
		controller: RouteController.extend do
			template: capitalize(admSection) + \Edit
			action: ->    
				template = AccessQ(Meteor.userId!, currentID!, admSection, \update)
				if not template then @render! else @render template
		waitOn: ->  Meteor.subscribe admSection #, @params["#{initial(admSection)}Id"]
		data: -> data = 
			params: @params or {}
			"#{initial(admSection)}": "#{capitalize(admSection)}.findOne({ _id:@params[#{initial(admSection)}Id] }, {})"
			comrade: Comrades.findOne({ _id: @params.comradeId }, {})

	# Router.route initial admSection,
	# 	path: initial(admSection) + "/:#{initial(admSection)}Id"
	# 	controller: RouteController.extend do
	# 		template: initial capitalize(admSection)
	# 		action: ->    
	# 			template = AccessQ(Meteor.userId!, currentID!, admSection, \update)
	# 			if not template then @render! else @render template
	# 	waitOn: ->  Meteor.subscribe admSection #, @params["#{initial(admSection)}Id"]
	# 	data: -> data = 
	# 		params: @params or {}
	# 		"#{initial(admSection)}": "#{capitalize(admSection)}.findOne({ _id:@params[#{initial(admSection)}Id] }, {})"
	# 		comrade: Comrades.findOne({ _id: @params.comradeId }, {})




Router.route \comrade,
	path: "/comrade/:id"
	controller: RouteController.extend do
		template: \comrade
	waitOn: ->  Meteor.subscribe \user, @params.id


Router.configure do
	templateNameConverter: \upperCamelCase
	routeControllerNameConverter: \upperCamelCase
	layoutTemplate: \layout
	loadingTemplate: \loading 
	notFoundTemplate: \notFound

# Router.configure waitOn:->
# 	Meteor.subscribe`map`<[ current_user_data estates ]>
Router.route \start, path: \/
Router.route \login, path: \/login 
Router.route \logout, path: \/logout
RouterInit \comrades 
RouterInit \unions
RouterInit \roles, <[ users_roles ]>
RouterInit \users, <[ roles ]>,  <[ roles ]>,  <[ roles ]>



# Router.route('/(.*)', where: 'server').get( ->
# 	if  @params[0] == ''
# 		@response.writeHead 301, {'Location': '/estates'}
# 		@response.end!
# 	else @next!
# 		)

	
