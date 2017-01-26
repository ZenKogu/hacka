
DBController Meteor.roles, \hard, \roles
DBController Meteor.users, \hard, \users
DBController Estates,   \easy, \estates

Meteor.publish \users_roles, -> Meteor.users.find {}, fields:\roles : 1
Meteor.publish \images, -> Images.find!
Meteor.publish \users,  -> Meteor.users.find! # {}, fields:{'roles':1,'name':1,'email':1}
Meteor.publish \roles,  -> Meteor.roles.find!
Meteor.publish \estates,  -> Estates.find!
Meteor.publish \estate,  -> Estates.findOne _id:it
Meteor.publish \estate_empty,  -> Estates.findOne _id:null

Images.allow do
	insert:   -> true
	update:   -> true
	remove:   -> true
	download: -> true


# DBController ShortLinks,   \easy, \shortLinks 
# Meteor.publish \materials_collections, -> Materials.find {}, fields:\collection : 1
# Meteor.publish \documents, -> Documents.find!
# Meteor.publish \materials, -> Materials.find!
# Meteor.publish \projects,  -> Projects.find!

# Meteor.publish \blockedDocs, -> BlockedDocs.find!
# Meteor.publish \shortLinks, -> ShortLinks.find!

#DBController BlockedDocs,  \easy, \blockedDocs, absTime:Date.now!
# DBController ShortLinks,   \easy, \shortLinks
# DBController Collections,  \hard, \collections, unpublished:false
# DBController Materials,    \easy, \materials, published:false
# DBController Projects,     \easy, \projects

# DBController News, \hard, \news 
# DBController Events, \hard, \events
# DBController Videos, \hard, \videos
# DBController Galleries, \hard, \galleries
# DBController Files, \hard, \files
# DBController Comments, \hard, \comments

# Meteor.publish \collections, -> Collections.find!
# Meteor.publish \news, -> News.find!
# Meteor.publish \events, -> Events.find!
# Meteor.publish \galleries, -> Galleries.find!
# Meteor.publish \files, -> Files.find!
# Meteor.publish \videos, -> Videos.find!
# Meteor.publish \comments, -> Comments.find!
# Meteor.publish initial(admSection),  (id)-> DB.find {_id:String(id)},obj
# Meteor.publish admSection+\_empty,  -> DB.find {_id:null},obj


# Documents.allow do
# 	insert:   -> true
# 	update:   -> true
# 	remove:   -> true
# 	download: -> true
# RecData.allow do
# 	insert: -> true
# 	update: -> false
# 	remove: -> false

# RecData.before.insert (userId, doc) ->
# 	userData = UserStatus.connections.findOne({'userId': userId})
# 	if userData
# 		doc.userAgent = userData.userAgent
# 		doc.userIp = userData.ipAddr
# 		doc.userId = userId
# 		doc.date = Date()
# 		doc.absTime = Date.now()
# 	else return false

