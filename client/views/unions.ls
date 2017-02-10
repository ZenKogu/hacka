template \unions -> D \container,
	div class:\page-header style:'padding-top:0px; margin-top:0px',
		div class:'input-group' style:\width:100%,
			div class:\input-group-addon, h4 'Союзы ' small 'критерии поиска: '
			input id:\dataview-search-input class:\form-control placeholder:'Введите запрос'
	div	class:\list-group style:'width:100%; padding:0px; margin:0px;',
		Blaze.If (~> SL(@,\isEmpty)),   ~> div class:'alert alert-info', 'Записи в базе данных отсутствуют.'
		Blaze.If (~>SL(@,\isNotFound)), ~> div class:'alert alert-info', strong('Ничего не найдено. '), 'Можно иначе сформулировать?'
		Blaze.Each (~> SL(@,\tableItems)), ~> do
			union_view {name:SL(@,\name); src:SL(@,\src); text:SL(@,\text); tags:SL(@,\tags); lvl:SL(@,\lvl); members:SL(@,\members); _id:SL(@,\_id)}

union_view = (o)->a href:"unions/profile/#{o._id}" class:\list-group-item style:'width:100%; min-height:200px;' ,
	div style:"width:20%; float:right; vertical-align:center; height:180px; max-height:180px;  background-image:url(#{o.src}); background-repeat:no-repeat; background-position:center center; background-size: 180px auto"
	h4 o.name,
		for lbl in (split \, o.tags)
			span style:'margin-left:4px' class:'label label-success', lbl
	p style:'padding-top:5px; min-height:55px', o.text
	table style:'width:600px;', tbody tr do
		for member in o.members
			td union_member username:member.username, role:member.role, src:member.src

union_member = (o={src:'',name:'Анонимус', role:'Участник'})-> D \media, 
	D 'media-left media-middle', img class:\media-object style:\height:50px src:o.src
	D \media-body,
		h6 class:\media-heading, o.username
		div o.role


Template.unions.rendered = ->
	pageSession.set \SearchString ''
	pageSession.set \InfoMessage ''
	pageSession.set \ErrorMessage ''

Template.unions.events do
	'keydown #dataview-search-input':->
		if event.which == 13
			event.preventDefault!
			pageSession.set \SearchString $(event.target).val!
		if event.which == 27
			event.preventDefault!
			$(event.target).val ''
			pageSession.set \SearchString ''

	'click .data-search-button':-> pageSession.set \SearchString $(\#dataview-search-input).val!

Template.unions.helpers do
	\tableItems   :-> get_search_result @data
	\isEmpty      :-> @data.find({}).fetch!length == 0
	\isNotEmpty   :-> @data and @data.count! > 0
	\isNotFound   :-> @data and pageSession.get(\SearchString) and get_search_result(@data).length== 0 and @data.find({}).fetch!length > 0


template \unionsProfile -> union_page type:\profile
template \unionsEdit    -> union_page type:\edit
template \unionsInsert  -> union_page type:\insert

union_events =(o)->
	'click .save':->
		pageSession.set \InfoMessage ''
		pageSession.set \ErrorMessage ''
		values = {}
		[ values[$(val).attr(\name)] = $(val).text! for val in $(\.input-div) ]
		if o.type == \edit => Unions.update {_id:currentID!}, {$set:values}, (err)->
			if err => pageSession.set \ErrorMessage message
			else
				pageSession.set \InfoMessage 'Изменения сохранены.'
				Router.go \/unions/profile/ + currentID!

		if o.type == \insert => Unions.insert values, (err)->
				if err => pageSession.set \ErrorMessage err
				else      Router.go \unions

	'click .exit':->
		unless $(\.alert-success).length => bootbox.dialog do
				message: 'Удалить все изменения?'
				title: 'Удалить изменения и выйти'
				animate: false
				buttons:
					success:
						label: 'Да'
						className: 'btn-success'
						callback: -> Router.go \unions
					danger:
						label: 'Нет'
						className: 'btn-default'
		else Router.go \unions

	'click .input-div':->
		$(\.alert-dismissible).fadeOut(1000, -> $(@).remove!)

Template.unionsProfile.events = union_events type:\profile
Template.unionsEdit.events    = union_events type:\edit
Template.unionsInsert.events  = union_events type:\insert

union_page =(o)->
	U =-> Unions.findOne(_id:currentID!)

	page = switch o.type
		| \profile => title:U!?name||\Несуществующий; small_title:'профиль'        edit:false
		| \edit    => title:U!?name||\Несуществующее; small_title:'редактирование' edit:true
		| \insert  => title:'Новый союз';             small_title:'создание'       edit:true

	D \container,
		D \page-header,
			h2 page.title,
				small style:'padding-left:10px', page.small_title,
				edit_buttons! if page.edit
				link_edit_button! if (U!?createdBy == Meteor.userId! or Meteor.userId! == \1) and (o.type==\profile)

		text_input {addon_text:\Название        name:\name    editable:page.edit, type:\text, value:U!?name}
		text_input {addon_text:\Описание        name:\text    editable:page.edit, type:\text, value:U!?text}
		text_input {addon_text:\Таги            name:\tags    editable:page.edit, type:\text, value:U!?tags}
		text_input {addon_text:\Участники       name:\members editable:page.edit, type:\text, value:''}
		text_input {addon_text:'Ссылка на лого' name:\src     editable:page.edit, type:\text, value:U!?src}
		error_message that if pageSession.get \ErrorMessage
		info_message  that if pageSession.get \InfoMessage


text_input =(o)->
	D 'input-group input-group-section form-group',
		D \input-group-addon, o.addon_text
		div class:\input_element,
			div {class:'input-div form-control text-input', name:o.name, contenteditable:o.editable, type:o.type}, o.value

edit_buttons =->
	div class:\btn-group style:'float:right',
		a class:'btn btn-success save', i class:'fa fa-save'
		a class:'btn btn-primary exit',  i class:'fa fa-remove'

link_edit_button =->
	div class:\btn-group style:'float:right',
		a class:'btn btn-success save' href:"/unions/edit/#{currentID!}", i class:'fa fa-edit'


error_message =->
	div class:'alert alert-danger alert-dismissible' role:\alert,
		button class:\close \data-dismiss :\alert, i class:'fa fa-close'
		strong 'Error. '
		it

info_message =->
	div class:'alert alert-success alert-dismissible' role:\alert,
		button class:\close \data-dismiss :\alert, i class:'fa fa-close'
		strong 'Готово. '
		it
