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
			estate: Estates.findOne({ _id: @params.estateId }, {})


Router.route \userPage,
	path: "/user/:id"
	controller: RouteController.extend do
		template: \userDetails
	# waitOn: ->  Meteor.subscribe \user, @params.id


Router.configure do
	templateNameConverter: \upperCamelCase
	routeControllerNameConverter: \upperCamelCase
	layoutTemplate: \layout
	loadingTemplate: \loading

# Router.configure waitOn:->
# 	Meteor.subscribe`map`<[ current_user_data estates ]>

Router.route \login, path: \/login 
Router.route \logout, path: \/logout
RouterInit \roles, <[ users_roles ]>
RouterInit \users, <[ roles ]>,  <[ roles ]>,  <[ roles ]>

RouterInit \estates 



Router.route('/(.*)', where: 'server').get( ->
	if  @params[0] == ''
		@response.writeHead 301, {'Location': '/estates'}
		@response.end!
	else @next!
		)

	
