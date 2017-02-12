DBController Unions,       \easy, \unions

Meteor.publish \unions,        -> Unions.find!
Meteor.publish \union,         -> Unions.findOne _id:it
Meteor.publish \union_empty,   -> Unions.findOne _id:null
Meteor.publish \unions_pub,    -> Unions.find!
