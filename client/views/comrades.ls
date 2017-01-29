template \comrades -> D \container,
	div class:\page-header style:'padding-top:0px; margin-top:0px',		
		div class:'input-group' style:\width:100%, 						
			div class:\input-group-addon, h4 'Товарищи ' small 'критерии поиска: '
			input id:\dataview-search-input class:\form-control placeholder:'Введите запрос'
	div	class:\list-group style:'width:100%; padding:0px; margin:0px;',
		Blaze.If (~> SL(@,\isEmpty)),   ~> div class:'alert alert-info', 'Записи отсутствуют'
		Blaze.If (~>SL(@,\isNotFound)), ~> div class:'alert alert-info', strong('Ничего не найдено. '), 'Можно иначе сформулировать?'
		Blaze.Each (~> SL(@,\tableItems)), ~> do
			record_view {name:SL(@,\name); photo:SL(@,\photo); text:SL(@,\text); tags:SL(@,\tags); lvl:SL(@,\lvl)},
				table tbody tr do
					skill_icon name:\HTML5     lvl:\45 icon:\html5
					skill_icon name:\CSS3      lvl:\29 icon:\css3
					skill_icon name:\Wordpress lvl:\12 icon:\wordpress
					skill_icon name:\Git       lvl:\25 icon:\git
					
record_view = (o,...args)-> div style:'width:100%; height:200px;' class:\list-group-item, 
		div style:"width:180px; float:right; border-radius:50%; height:180px; max-height:180px; background-image:url(#{o.photo}); background-repeat:no-repeat; background-position:center center; background-size: 200px auto"
		h4 o.name, small  " #{o.lvl} lvl" ,	
			for lbl in (split \| o.tags)
				span style:'margin-left:4px' class:'label label-success', lbl
		p style:'padding-top:5px; height:70px', o.text
		args
					
skill_icon = (o={icon:'', name:'', lvl:0})-> td style:'width:80px; align:right', D \media, 
	D \media-bottom, i class:"media-object fa fa-#{o.icon}" style:'font-size:50px; color:green'
	D \media-body,
		h5 style:'margin:0px; padding:0px; margin-top:3px;' class:\media-heading, "#{o.name} "
		div style:'margin:0px; padding:0px; font-size:10px;', "#{o.lvl}/100"


pageSession = new ReactiveDict

Template.comrades.rendered = ->	
	pageSession.set 'ComradesListStyle', 'table'
	pageSession.set 'ComradesCriterio', {}
	pageSession.set \ComradesListSearchString ''

Template.comrades.events do

	'keydown #dataview-search-input':->
		if event.which == 13
			event.preventDefault!	
			pageSession.set \ComradesListSearchString $(event.target).val!		
		if event.which == 27
			event.preventDefault!
			$(event.target).val ''
			pageSession.set \ComradesListSearchString ''

	'click .data-search-button':(e, t)-> pageSession.set \ComradesListSearchString $(\#dataview-search-input).val!

Template.comrades.helpers do

	\tableItems   :-> Comrades.find(\tags : \$regex : ".*?#{pageSession.get \ComradesListSearchString }.*?").fetch!

	'isEmpty': ->   !@comrades or @comrades.count() == 0
	'isNotEmpty': -> @comrades and @comrades.count() > 0
	'isNotFound': -> @comrades and pageSession.get('ComradesListSearchString') and Comrades.find(\tags : \$regex : ".*?#{pageSession.get \ComradesListSearchString }.*?").fetch!length == 0
	'searchString': -> pageSession.get 'ComradesListSearchString'
	'insertButtonClass': -> if !Meteor.user() ||	Meteor.user().roles[0]!='1' then 'hidden'
	'editButtonClass': ->	 if !Meteor.user() ||	Meteor.user().roles[0]!='1' then 'hidden'
	'deleteButtonClass': -> if !Meteor.user() ||	Meteor.user().roles[0]!='1' then 'hidden'



