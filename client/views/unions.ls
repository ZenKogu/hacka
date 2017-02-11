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
	\isEmpty	  :-> @data.find({}).fetch!length == 0
	\isNotEmpty   :-> @data and @data.count! > 0
	\isNotFound   :-> @data and pageSession.get(\SearchString) and get_search_result(@data).length== 0 and @data.find({}).fetch!length > 0


template \unionsProfile -> union_profile_page!
template \unionsEdit	-> union_edit_page type:\edit
template \unionsInsert  -> union_edit_page type:\insert

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
				else	  Router.go \unions

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

#-——————————————————————————————————————— UNION EDIT

Template.unionsProfile.events = union_events type:\profile
Template.unionsEdit.events	= union_events type:\edit
Template.unionsInsert.events  = union_events type:\insert

U =-> Unions.findOne(_id:currentID!)

union_edit_page =(o)->
	page = switch o.type
		| \edit	=> title:U!?name||\Несуществующее; small_title:'редактирование' edit:true
		| \insert  => title:'Новый союз';			 small_title:'создание'	   edit:true
	D \container,
		D \page-header,
			h2 page.title,
				small style:'padding-left:10px', page.small_title,
				edit_buttons! if page.edit
				link_edit_button! if (U!?createdBy == Meteor.userId! or Meteor.userId! == \1) and (o.type==\profile)
		text_input {addon_text:\Название		name:\name	editable:page.edit, type:\text, value:U!?name}
		text_input {addon_text:\Описание		name:\text	editable:page.edit, type:\text, value:U!?text}
		text_input {addon_text:\Таги			name:\tags	editable:page.edit, type:\text, value:U!?tags}
		text_input {addon_text:\Участники	   name:\members editable:page.edit, type:\text, value:''}
		text_input {addon_text:'Ссылка на лого' name:\src	 editable:page.edit, type:\text, value:U!?src}
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

#-——————————————————————————————————————— UNION PROFILE

union_profile_page =-> div class:\container style:'padding-left:10px; padding-right:150px',
	union_timeline!
	union_description!
	union_team!
	union_news_list!
	union_finance!
	union_analitics!
	union_custom!

union_timeline =->
	div style:'position:fixed; right:10px; height:100%; width:145px; overflow-y:scroll;',
		div style:'float:center',
			div class:'alert-info' style:'background-color:white; font-size:120px', 'A'
			div class:'alert-info' style:'background-color:white; font-size:120px', 'B'
			div class:'alert-info' style:'background-color:white; font-size:120px', 'C'
			div class:'alert-info' style:'background-color:white; font-size:120px', 'D'
			div class:'alert-info' style:'background-color:white; font-size:120px', 'E'
			div class:'alert-info' style:'background-color:white; font-size:120px', 'F'
			div class:'alert-info' style:'background-color:white; font-size:120px', 'G'
			div class:'alert-info' style:'background-color:white; font-size:120px', 'H'
			div class:'alert-info' style:'background-color:white; font-size:120px', 'I'
			div class:'alert-info' style:'background-color:white; font-size:120px', 'J'
			div class:'alert-info' style:'background-color:white; font-size:120px', 'K'
			div class:'alert-info' style:'background-color:white; font-size:120px', 'L'


union_member_big = (o={src:'https://pp.vk.me/c305707/v305707222/4949/qJXr5hxBLoM.jpg',name:'Анонимус', role:'Участник'})->
	div style:'display:inline-block; white-space:pre-wrap; margin:15px; width:200px;',
		div class:\thumbnail,
			img style:' border-radius:50%; height:180px;' src:'https://pp.vk.me/c305707/v305707222/4949/qJXr5hxBLoM.jpg'
			div class:\caption,
				h4 class:\media-heading, 'Media heading'
				replicate 40 'Cras sit amet nibh libero, in gravida nulla.'

union_member_lil = (o={src:'https://pp.vk.me/c305707/v305707222/4949/qJXr5hxBLoM.jpg',name:'Анонимус', role:'Участник'})->
	div style:'display:inline-block; white-space:pre-wrap; margin:5px; width:50px;',
		img style:' border-radius:50%; height:50px;' src:'https://pp.vk.me/c305707/v305707222/4949/qJXr5hxBLoM.jpg'

union_description =-> div class:\union_description,
		div class:\header,
			h1 class:'union_header_text' style:'font-size:50px;', 'Суперкоманда Тимура',
				small ' ОАО'
		div class:\header  style:'margin-top:30px; margin-bottom:30px',
			h2 class:'union_header_text' style:'font-size:30px',
				'Стадия'
				span style:'margin:5px' class:'label label-info', 'Планирование'
				'Бюджет'
				span style:'margin:5px' class:'label label-info', '100 рублей'
				'Участников'
				span style:'margin:5px' class:'label label-info', '120'

		div style:'height:300px; display:inline-block; margin-top:10px',
			div class:'union_short_description' style:'width:48%; max-height:300px; display:inline-block; overflow-y:scroll; margin-right:15px; font-size:18px; padding-left:10px;',
				replicate 40 'Вы не спите ночами, мечтаете о стартапе и думаете, а не создать ли мне нечто такое, что перевернет интернет бизнес и сделает вас миллионерами. '
			div class:'union_logo' style:'width:49%; padding-top:15px; padding-left:20px; height:300px; display:inline-block; min-height:100px; background-image:url(http://www.laser-bulat.ru/upload/iblock/0c5/0c5635909ae250028d20d853befa5492.jpg); background-size:cover'

union_team =-> div class:\union_team style:'margin-top:30px',
	div class:\header,
		h2 class:'union_header_text' style:'font-size:30px',
			'Участники',
			span style:'margin:5px' class:'label label-success', '122'
			'Подписчики'
			span style:'margin:5px' class:'label label-primary', '18 564'
			'Вакансии'
			span style:'margin:5px' class:'label label-info', '14'
	div  style:'overflow-x:scroll; margin-top:20px',
		replicate 75 union_member_lil!

union_news_list =-> div class:\union_news style:'margin-top:30px',
		div class:\header,
			h2 class:'union_header_text' style:'font-size:30px',
				'Новости'
				span style:'margin:5px' class:'label label-primary', '184'

		div  style:'white-space:nowrap; overflow-x:scroll; margin-top:20px',
			replicate 10 union_news!


union_news=-> div style:'display:inline-block; white-space:pre-wrap; margin:5px; width:32.5%',
	div class:\thumbnail,
		img style:'max-height:280px; min-height:100px; width:100%; border-radius:5%' src:'http://media3.s-nbcnews.com/j/msnbc/components/video/201607/a_ov_rnc_trump_mashup_160722__872382.nbcnews-ux-1080-600.jpg'
		div class:\caption,
			h4 class:\media-heading, 'Media heading'
			'Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis.'



union_finance =-> 	div class:\union_finance style:'margin-top:30px; margin-bottom:30px',
	div class:\header,
		h2 class:'union_header_text' style:'font-size:30px',
			'Финансы'
			span style:'margin:5px' class:'label label-primary', '12 000 000'
	div style:'margin-top:30px; height:300px; overflow:scroll',
		table class:'table table-bordered',
			thead tr do
				th 'Статья расходов'
				th 'Потрачено'
				th 'Комментарий'
			replicate 15 tbody do
				tr(td('Свистелки'), td('100 рублей'), td('Для Винни'))
				tr(td('Опилки'), td('200 рублей'), td('Для Винни'))
				tr(td('Неправильный мёд'), td('600 рублей'), td('Для Ослика'))
				tr(td('Ружьё'), td('2000 рублей'), td('Для Свиньи'))



union_analitics =-> 	div class:\union_analitics style:'margin-top:30px; margin-bottom:30px',
		div class:\header,
			h2 class:'union_header_text' style:'font-size:30px',
				'Аналитика'
				span style:'margin:5px' class:'label label-primary', 'Суперуспешно'
		div style:'margin-top:30px; height:600px; overflow:scroll; background-image:url(http://www.zerkalo.lv/wp-content/uploads/2014/05/vinni_puh_citati.jpg); background-size:cover'


union_custom =-> div class:\union_custom

# 1. Каким будет таймлайн?
# 2. Какой будет аналитика?
# 3. Таблица расходов — как это сделать? Как будут вносить данные по расходам, насколько подробно?
# 4. С описанием как будем? Сколько ифномрации там будет содержаться?
# 5. Кастомные блоки — что там будет? Нужны какие-то варианты. Как это вообще будет?
# 6. Этапы как будут фиксироваться? Нужно для каждого раздела продумать не толькол то, как он будет выглядеть, но и интерфейс редактирования/добавления записи. Что-то может автоматически генерироваться, что-то нужно будет загружать в виде файлов (например, таблица с расходами в json формате). Какие-то данные вводить вручную.
