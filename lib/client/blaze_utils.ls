@template =(name, func)~> Template[name] = new Template "Template#name",  func

@SB=~> Spacebars.call it
@SM=~> Spacebars.mustache it
@SI=~> Spacebars.include it
@SL=(that,me)~> Spacebars.call that.lookup me

@pageSession = new ReactiveDict

Template.registerHelper \isUser	   -> !!Meteor.user!
Template.registerHelper \userEmail -> Meteor.user!emails[0].address
Template.registerHelper \userId    -> Meteor.userId!
Template.registerHelper \isAdmin   -> Meteor.user!roles[0]==\1

Template.registerHelper \searchString      -> pageSession.get \SearchString
Template.registerHelper \insertButtonClass -> if !Meteor.user! || Meteor.user!roles[0]!=\1 => \hidden
Template.registerHelper \editButtonClass   -> if !Meteor.user! || Meteor.user!roles[0]!=\1 => \hidden
Template.registerHelper \deleteButtonClass -> if !Meteor.user! || Meteor.user!roles[0]!=\1 => \hidden


@get_search_result = (db)->
	query = pageSession.get \SearchString
	db.find(\tags : \$regex : ".*?#query.*?").fetch!
