
DBController Meteor.roles, \hard, \roles
Meteor.publish \users_roles, -> Meteor.users.find {}, fields:\roles : 1
Meteor.publish \roles,  -> Meteor.roles.find!


DBController Users, \easy, \users
Meteor.publish \users,       -> Users.find!
Meteor.publish \user,        -> Users.findOne _id:it
Meteor.publish \user_empty,  -> Users.findOne _id:null
Meteor.publish \users_pub,  -> Meteor.users.find {}, fields:{'username':1,'tags':1, \lvl :1, \text : 1, \photo : 1, \skills :1}
