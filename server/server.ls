

Accounts.config sendVerificationEmail: false

Meteor.methods do

		# if !Users.isAdmin(Meteor.userId())
		#   throw new (Meteor.Error)(403, 'Access denied.')
		# userOptions = {}


	'createUserAccount': (options) ->
		userOptions = {}
		if options.username
			userOptions.username = options.username
		if options.email
			userOptions.email = options.email
		if options.password
			userOptions.password = options.password
		if options.roles
			userOptions.roles = options.roles
		AllId=[]
		for usr in Meteor.users.find!fetch!
			AllId.push +usr._id
		id = String <| +_.max(AllId) + 1 


		newUser = Accounts.createUser userOptions

		# Meteor.users.update {_id:\1}, {$set:{roles:[\1]}}
		Meteor.users.update {_id: id}, {$set: roles: userOptions.roles}


	'updateUserAccount': (userId, options) ->


		# if !Users.isAdmin(Meteor.userId())
		# 	keys = Object.keys(options)
		userOptions = {}
		if options.username
			userOptions.username = options.username
		if options.email
			userOptions.emails = [{address:options.email, verified:false}]
		if options.password
			userOptions.password = options.password
		if options.roles
			userOptions.roles = options.roles
		# if options.profile
		# 	userOptions.profile = options.profile
		# if options.profile and options.profile.email
		# 	userOptions.email = options.profile.email

		# if userOptions.email
		# 	email = userOptions.email
		# 	delete userOptions.email
		# 	userOptions.emails = [ { address: email } ]
		# password = ''
		if userOptions.password
			password = userOptions.password
			delete userOptions.password
		# if userOptions
		# 	for key of userOptions
		# 		obj = userOptions[key]
		# 		if _.isObject(obj)
		# 			for k of obj
		# 				userOptions[key + '.' + k] = obj[k]
		# 			delete userOptions[key]
		# 	Users.update userId, $set: userOptions
		if password
			Accounts.setPassword userId, password


		Meteor.users.update {_id:userId}, {$set:userOptions}




		# if !Users.isAdmin(Meteor.userId())
		#   keys = Object.keys(options)
		# userOptions = {}
		# if options.username
		#   userOptions.username = options.username
		# if options.email
		#   userOptions.email = options.email
		# if options.password
		#   userOptions.password = options.password
		# if options.profile
		#   userOptions.profile = options.profile
		# if options.profile and options.profile.email
		#   userOptions.email = options.profile.email
		# if options.roles
		#   userOptions.roles = options.roles
		# if userOptions.email
		#   email = userOptions.email
		#   delete userOptions.email
		#   userOptions.emails = [ { address: email } ]
		# password = ''
		# if userOptions.password
		#   password = userOptions.password
		#   delete userOptions.password
		# if userOptions
		#   for key of userOptions
		#     obj = userOptions[key]
		#     if _.isObject(obj)
		#       for k of obj
		#         userOptions[key + '.' + k] = obj[k]
		#       delete userOptions[key]
		#   Users.update userId, $set: userOptions
		# if password
		#   Accounts.setPassword userId, password
		# return

	'logoutAndMain':->
		Rec event: 'logout'
		App.logout();  Router.go '/main' 

	'RolesAccess': (rolesArray)->
		out = false
		_.each rolesArray, (role) ->
			op = dbName + '.' + operation
			if _.contains Meteor.roles.findOne({_id: role}).MongoAccessList, op
				out = true
		out


UserStatus.events.on("connectionLogin", (fields)-> Rec event: 'login')
# fields contains userId, connectionId, ipAddr, userAgent, and loginTime.

# UserStatus.events.on("connectionLogout", (fields)-> )
# fields contains userId, connectionId, lastActivity, and logoutTime.

UserStatus.events.on("connectionIdle", (fields)-> Rec event: 'idle', lastActivity: fields.lastActivity)
# fields contains userId, connectionId, and lastActivity.

