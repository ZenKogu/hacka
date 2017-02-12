template \usersEdit	-> user_edit_page type:\edit
template \usersInsert  -> user_edit_page type:\insert

Template.usersEdit.events	=-> user_events type:\edit
Template.usersInsert.events  =-> user_events type:\insert

U =-> Users.findOne(_id:currentID!)

user_page =(o)-> D \container,
	D \page-header,
		h2 if o.type==\edit => U!?username||\Несуществующий else 'Новый пользователь',
			small style:'padding-left:10px', if o.type==\edit =>'редактирование' else 'создание',
			edit_buttons!
	text_input {addon_text:\Имя			      name:\name   editable:\true,  type:\text, value:U!?username}
	text_input {addon_text:\Описание	 	  name:\text   editable:\true,  type:\text, value:U!?text}
	text_input {addon_text:\Таги			  name:\tags   editable:\true,  type:\text, value:U!?tags}
	text_input {addon_text:\Уровень		      name:\lvl	   editable:\false, type:\text, value:U!?lvl}
	text_input {addon_text:'Ссылка на аватар' name:\src	   editable:\true,  type:\text, value:U!?photo}
	text_input {addon_text:'Навыки'		      name:\skills editable:\true,  type:\text, value:U!?skills}
	error_message that if pageSession.get \ErrorMessage
	info_message  that if pageSession.get \InfoMessage

text_input =(o)-> D 'input-group input-group-section form-group',
	D \input-group-addon, o.addon_text
	div class:\input_element,
		div {class:'input-div form-control text-input', name:o.name, contenteditable:o.editable, type:o.type}, o.value

edit_buttons =-> div class:\btn-group style:'float:right',
	a class:'btn btn-success save', i class:'fa fa-save'
	a class:'btn btn-primary exit',  i class:'fa fa-remove'

link_edit_button =~> div class:\btn-group style:'float:right',
	a class:'btn btn-success save' href:"/users/edit/#{currentID!}", i class:'fa fa-edit'
	a class:'btn btn-info save' onclick:'Meteor.logout()', \Выйти

error_message =-> div class:'alert alert-danger alert-dismissible' role:\alert,
	button class:\close \data-dismiss :\alert, i class:'fa fa-close'
	strong 'Error. '
	it

info_message =-> div class:'alert alert-success alert-dismissible' role:\alert,
	button class:\close \data-dismiss :\alert, i class:'fa fa-close'
	strong 'Готово. '
	it

user_events =(o)->
	'click .save':->
		pageSession.set \InfoMessage ''
		pageSession.set \ErrorMessage ''
		values = {}
		[ values[$(val).attr(\name)] = $(val).text! for val in $(\.input-div) ]
		if o.type == \edit => Users.update {_id:currentID!}, {$set:values}, (err)->
			if err => pageSession.set \ErrorMessage message
			else
				pageSession.set \InfoMessage 'Изменения сохранены.'
				Router.go \/users/profile/ + currentID!

		if o.type == \insert => Users.insert values, (err)->
				if err => pageSession.set \ErrorMessage err
				else	  Router.go \users

	'click .exit':->
		unless $(\.alert-success).length => bootbox.dialog do
				message: 'Удалить все изменения?'
				title: 'Удалить изменения и выйти'
				animate: false
				buttons:
					success:
						label: 'Да'
						className: 'btn-success'
						callback: -> Router.go \users
					danger:
						label: 'Нет'
						className: 'btn-default'
		else Router.go \users

	'click .input-div':->
		$(\.alert-dismissible).fadeOut(1000, -> $(@).remove!)
