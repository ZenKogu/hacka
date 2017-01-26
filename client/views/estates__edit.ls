pageSession = new ReactiveDict

Template.EstatesEdit.rendered =-> do
	pageSession.set \estatesEditFormInfoMessage ''
	pageSession.set \estatesEditFormErrorMessage ''

Template.EstatesEdit.events do
	\submit :(e,t)->
		submitAction=(msg)!-> 
			estatesEditFormMode = \update
			if !t.find \#form-cancel-button
				switch estatesEditFormMode
					when \insert => $(e.target)[0].reset!
					when \update 
						message = msg or \Saved.
						pageSession.set \estatesEditFormInfoMessage, message
			Router.go \estates

		errorAction=(msg='')!->
			pageSession.set \estatesEditFormErrorMessage, msg?message||msg||\Error.

		e.preventDefault!
		pageSession.set \estatesEditFormInfoMessage ''
		pageSession.set \estatesEditFormErrorMessage ''

		validateForm $(e.target), !->, !->, (values)->
				| currentID! == \insert => newId = Estates.insert values, ->
					if it => errorAction it else submitAction!
				|_ => Estates.update {_id:currentID!}, {$set:values}, ->
					if it => errorAction it else submitAction!

	'click #form-cancel-button':(e,t)!-> e.preventDefault!; Router.go \estates
		
Template.EstatesEdit.helpers do
	\infoMessage  :-> pageSession.get \estatesEditFormInfoMessage
	\errorMessage :-> pageSession.get \estatesEditFormErrorMessage

