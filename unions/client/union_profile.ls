template \unionsProfile -> div class:\container style:'padding-left:10px; padding-right:150px',
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
			replicate 20 div class:'alert-info' style:'background-color:white; font-size:120px', 'A'

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
