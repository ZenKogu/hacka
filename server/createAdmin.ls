if not Meteor.users.find!fetch!?length
	userData = 
		username: 'Василий Админов'
		email: \vasiliy@adminov.com
		password: \ndtrmnmt330
	newUser = Accounts.createUser userData

	Meteor.users.update {_id:\1}, {$set:{roles:[\1]}}

if not Meteor.roles.find!fetch!?length
	Meteor.roles.insert do
		name: \Администратор
		MongoAccessList:[
			\roles.read
			\roles.insert
			\roles.update
			\roles.remove
			\users.read
			\users.insert
			\users.update
			\users.remove
			\materials.read
			\materials.insert
			\materials.update
			\materials.remove
			\collections.read
			\collections.insert
			\collections.update
			\collections.remove
			\news.read
			\news.insert
			\news.update
			\news.remove
			\files.read
			\files.insert
			\files.update
			\files.remove
			\videos.read
			\videos.insert
			\videos.update
			\videos.remove
			\galleries.read
			\galleries.insert
			\galleries.update
			\galleries.remove
			\events.read
			\events.insert
			\events.update
			\events.remove
			\comments.read
			\comments.insert
			\comments.update
			\comments.remove]