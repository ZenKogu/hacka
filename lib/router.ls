@currentID=-> last split \/, Router.current!originalUrl

@RouterInit = (name, db)~> do
	template_name = name
	section_pub   = name+\_pub
	path_name     = name

	Router.route name,
		path: path_name
		controller: RouteController.extend do
			template: template_name
			action: -> @render!
		waitOn:->  Meteor.subscribe section_pub
		data:->
			data: db
			params: @params||{}

	Router.route name+\.insert,
		path: name+\/insert
		controller: RouteController.extend do
			template: name+\Insert
			action: -> @render!
		waitOn: -> Meteor.subscribe section_pub
		data: ->
			params: @params || {}
			data: db.findOne _id:null

	Router.route name+\.edit,
		path: name+\/edit/:ID
		controller: RouteController.extend do
			template: name+\Edit
			action: -> @render!
		waitOn: -> Meteor.subscribe section_pub
		data: ->
			params: @params || {}
			data: db.findOne _id:currentID!

	Router.route name+\.profile,
		path: name+\/profile/:ID
		controller: RouteController.extend do
			template: name+\Profile
			action: -> @render!
		waitOn: -> Meteor.subscribe section_pub
		data: ->
			params: @params || {}
			data: db.findOne _id:currentID!



	# Router.route admSection + \.edit,
	# 	path: admSection + "/edit/:#{initial(admSection)}Id"
	# 	controller: RouteController.extend do
	# 		template: capitalize(admSection) + \Edit
	# 		action: ->    
	# 			template = AccessQ(Meteor.userId!, currentID!, admSection, \update)
	# 			if not template then @render! else @render template
	# 	waitOn: ->  Meteor.subscribe admSection #, @params["#{initial(admSection)}Id"]
	# 	data: -> data = 
	# 		params: @params or {}
	# 		"#{initial(admSection)}": "#{capitalize(admSection)}.findOne({ _id:@params[#{initial(admSection)}Id] }, {})"
	# 		user: Users.findOne({ _id: @params.userId }, {})


	# Router.route admSection + \.profile,
	# 	path: admSection + "/profile/:#{initial(admSection)}Id"
	# 	controller: RouteController.extend do
	# 		template: capitalize(admSection) + \Profile
	# 		action: ->    
	# 			template = AccessQ(Meteor.userId!, currentID!, admSection, \update)
	# 			if not template then @render! else @render template
	# 	waitOn: ->  Meteor.subscribe admSection #, @params["#{initial(admSection)}Id"]
	# 	data: -> data = 
	# 		params: @params or {}
	# 		"#{initial(admSection)}": "#{capitalize(admSection)}.findOne({ _id:@params[#{initial(admSection)}Id] }, {})"
			# user: Users.findOne({ _id: @params.userId }, {})


Router.configure do
	templateNameConverter: \upperCamelCase
	routeControllerNameConverter: \upperCamelCase
	layoutTemplate: \layout
	loadingTemplate: \loading 
	notFoundTemplate: \notFound

Router.route \start, path: \/
Router.route \login, path: \/login 

Router.route \register, 
	path: \/register, 
	controller: RouteController.extend template:\login

Router.route \logout, path: \/logout
RouterInit \users Users
RouterInit \unions Unions

# Router.configure waitOn:->
# 	# if Meteor.User!
# 	Meteor.subscribe \current_user


# RouterInit \roles, <[ users_roles ]>
# RouterInit \users, <[ roles ]>,  <[ roles ]>,  <[ roles ]>



# Router.route('/(.*)', where: 'server').get( ->
# 	if  @params[0] == ''
# 		@response.writeHead 301, {'Location': '/estates'}
# 		@response.end!
# 	else @next!
# 		)

	
