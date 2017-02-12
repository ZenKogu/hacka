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

@union_view = (o)->a href:"unions/profile/#{o._id}" class:\list-group-item style:'width:100%; min-height:200px;' ,
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
	\isEmpty	  :-> @data.find({}).fetch!length == 0
	\isNotEmpty   :-> @data and @data.count! > 0
	\isNotFound   :-> @data and pageSession.get(\SearchString) and get_search_result(@data).length== 0 and @data.find({}).fetch!length > 0
