Accounts.config sendVerificationEmail: false

Meteor.methods do

	'createUserAccount': (options) ->
		userOptions={}
		userOptions{email,password,username,roles} = options
		AllId=[]
		for usr in Meteor.users.find!fetch!
			AllId.push +usr._id
		id = String <| +_.max(AllId) + 1

		newUser = Accounts.createUser options
		Meteor.users.update {_id: id}, {$set: roles: options.roles}

	'updateUserAccount': (userId, options) ->
		userOptions = {}
		if options.username
			userOptions.username = options.username
		if options.email
			userOptions.emails = [{address:options.email, verified:false}]
		if options.password
			userOptions.password = options.password
		if options.roles
			userOptions.roles = options.roles
		if userOptions.password
			password = userOptions.password
			delete userOptions.password
		if password
			Accounts.setPassword userId, password
		Meteor.users.update {_id:userId}, {$set:userOptions}

	'logoutAndMain':-> App.logout();  Router.go '/'

	'RolesAccess': (rolesArray)->
		out = false
		_.each rolesArray, (role) ->
			op = dbName + '.' + operation
			if _.contains Meteor.roles.findOne({_id: role}).MongoAccessList, op
				out = true
		out
