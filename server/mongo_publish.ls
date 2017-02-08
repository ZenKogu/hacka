
DBController Meteor.roles, \hard, \roles
DBController Users, \easy, \users
# DBController Users,      \easy, \users 
DBController Unions,       \easy, \unions


Meteor.publish \users_roles, -> Meteor.users.find {}, fields:\roles : 1
# Meteor.publish \images, -> Images.find!
# Meteor.publish \users,  -> Meteor.users.find! # {}, fields:{'roles':1,'name':1,'email':1}
Meteor.publish \roles,  -> Meteor.roles.find!


Meteor.publish \users,       -> Users.find!
Meteor.publish \user,        -> Users.findOne _id:it
Meteor.publish \user_empty,  -> Users.findOne _id:null

Meteor.publish \users_pub,  -> Meteor.users.find {}, fields:{'username':1,'tags':1, \lvl :1, \text : 1, \photo : 1, \skills :1}



Meteor.publish \unions,        -> Unions.find!
Meteor.publish \union,         -> Unions.findOne _id:it
Meteor.publish \union_empty,   -> Unions.findOne _id:null
Meteor.publish \unions_pub,    -> Unions.find!




	# 	Rec event:\database operation:\insert, dbName:admSection, document:doc._id

	# DB.before.update (uId, doc)-> Rec event:\database, operation:\update, dbName:admSection, document:doc._id
	# DB.before.remove (uId, doc)-> Rec event:\database, operation:\remove, dbName:admSection, document:doc._id
