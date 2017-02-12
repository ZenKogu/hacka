template \users -> D \container,
	div class:\page-header style:'padding-top:0px; margin-top:0px',
		div class:'input-group' style:\width:100%,
			div class:\input-group-addon, h4 'Товарищи ' small 'критерии поиска: '
			input id:\dataview-search-input class:\form-control placeholder:'Введите запрос'
	div	class:\list-group style:'width:100%; padding:0px; margin:0px;',
		Blaze.If (~> SL(@,\isEmpty)),   ~> div class:'alert alert-info', 'Записи отсутствуют'
		Blaze.If (~>SL(@,\isNotFound)), ~> div class:'alert alert-info', strong('Ничего не найдено. '), 'Можно иначе сформулировать?'
		Blaze.Each (~> SL(@,\tableItems)), ~> do
			record_view {username:SL(@,\username); photo:SL(@,\photo); text:SL(@,\text); tags:SL(@,\tags); lvl:SL(@,\lvl); _id:SL(@,\_id); skills:SL(@,\_skills)},
				table tbody tr do
					skill_icon name:\HTML5     lvl:\45 icon:\html5
					skill_icon name:\CSS3      lvl:\29 icon:\css3
					skill_icon name:\Wordpress lvl:\12 icon:\wordpress
					skill_icon name:\Git       lvl:\25 icon:\git

record_view = (o,...args)-> a href:"users/profile/#{o._id}" style:'width:100%; min-height:200px;' class:\list-group-item,
		div style:"width:180px; float:right; border-radius:50%; height:180px; max-height:180px; background-image:url(#{o.photo}); background-repeat:no-repeat; background-position:center center; background-size: 200px auto"
		h4 o.username, small  " #{o.lvl} lvl" ,
			for lbl in (split \| o.tags)
				span style:'margin-left:4px' class:'label label-success', lbl
		p style:'padding-top:5px; min-height:55px', o.text
		table tbody tr do
			if o.skills => for skill in (split \| o.skills)
				skill_icon name:skill

skill_icon = (o={icon:'', name:'', lvl:1})-> td style:'width:80px; align:right', D \media,
	D \media-bottom, i class:"media-object fa fa-#{o.icon}" style:'font-size:50px; color:green'
	D \media-body,
		h5 style:'margin:0px; padding:0px; margin-top:3px;' class:\media-heading, "#{o.name} "
		div style:'margin:0px; padding:0px; font-size:10px;', "#{o.lvl}/100"


Template.users.rendered = ->
	pageSession.set \SearchString ''
	pageSession.set \InfoMessage ''
	pageSession.set \ErrorMessage ''

Template.users.events do
	'keydown #dataview-search-input':->
		if event.which == 13
			event.preventDefault!
			pageSession.set \SearchString $(event.target).val!
		if event.which == 27
			event.preventDefault!
			$(event.target).val ''
			pageSession.set \SearchString ''

	'click .data-search-button':-> pageSession.set \SearchString $(\#dataview-search-input).val!

Template.users.helpers do
	\tableItems   :-> get_search_result @data
	\isEmpty      :-> @data.find({}).fetch!length == 0
	\isNotEmpty   :-> @data and @data.count! > 0
	\isNotFound   :-> @data and pageSession.get(\SearchString) and get_search_result(@data).length== 0 and @data.find({}).fetch!length > 0
