@template =(name, func)~> Template[name] = new Template "Template#name",  func

@SB =~> Spacebars.call it
@SM =~> Spacebars.mustache it
@SI =~> Spacebars.include it
@SL =(that,me)~> Spacebars.call that.lookup me



Template.registerHelper \isUser	   -> !!Meteor.user!
Template.registerHelper \userEmail -> Meteor.user!emails[0].address
Template.registerHelper \userId    -> Meteor.userId!
Template.registerHelper \isAdmin   -> Meteor.user!roles[0]==\1