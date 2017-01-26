
Template.registerHelper \isUser, -> !!Meteor.user!
Template.registerHelper \userEmail, -> Meteor.user!emails[0].address
Template.registerHelper \userId, -> Meteor.userId!
Template.registerHelper \isAdmin, -> Meteor.user!roles[0]==\1