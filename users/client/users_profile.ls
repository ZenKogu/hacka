template \usersProfile -> D \container,
	user_header!
	user_description!
	user_project!
	user_experience!
	user_skills!

Template.usersProfile.events = {}

user_header =-> div class:\header,
		h1 class:'user_header_text' style:'font-size:30px', 'Йцукен Фывапролджэв',
			span style:'margin:5px' class:'label label-info', 'Стартапер'
			span style:'margin:5px' class:'label label-info', '99 lvl'

user_description =-> div class:\user_description,
	div style:'height:300px; display:inline-block; margin-top:10px',
		div class:'user_short_description' style:'width:48%; max-height:300px; display:inline-block; overflow-y:scroll; margin-right:15px; font-size:18px; padding-left:10px;',
			replicate 40 'Вы не спите ночами, мечтаете о стартапе и думаете, а не создать ли мне нечто такое, что перевернет интернет бизнес и сделает вас миллионерами. '
		div class:'user_logo' style:'width:49%; border-radius:5%; padding-top:15px; padding-left:20px; height:300px; display:inline-block; min-height:100px; background-image:url(http://cdn.tvc.ru/pictures/o/197/497.jpg); background-size:cover'

user_experience =-> div class:\user_experience style:'margin-top:30px',
	div class:\header,
		h2 class:'union_header_text' style:'font-size:30px',
			'Навыков'
			span style:'margin:5px' class:'label label-primary', '48'
			'Эксперт'
			span style:'margin:5px' class:'label label-primary', '4'
			'Профи'
			span style:'margin:5px' class:'label label-primary', '12'
	div style:'margin-top:30px',
		map skill-icon(50,_,\success), <[ adn amazon android angellist apple bandcamp behance behance-square bitbucket bitbucket-square bitcoin black-tie bluetooth bluetooth-b btc buysellads cc-amex cc-diners-club cc-discover cc-jcb cc-mastercard cc-paypal cc-stripe cc-visa chrome codepen codiepie connectdevelop contao css3 dashcube delicious deviantart digg dribbble dropbox drupal edge eercast empire envira etsy expeditedssl facebook facebook-official facebook-square firefox first-order flickr font-awesome fonticons fort-awesome forumbee foursquare free-code-camp get-pocket gg gg-circle git git-square ]>

skill-icon =->
	i class:"fa fa-#{&1} alert-#{&2}" style:"font-size:#{&0}px; background-color:white; display:inline-block; white-space:pre-wrap; margin:5px; width:#{+&1*1.3}px;"


user_project =~> div class:\user_project style:'margin-top:30px',
	div class:\header,
		h2 class:'union_header_text' style:'font-size:30px',
			'Основной проект'


	div style:'margin-top:30px', union_view do
		name:  'The WebAssembly Community Group',
		tags:  'веб-стартап\nпоиск инвесторов\nстадия тестирования',
		src: 'https://raw.githubusercontent.com/dcodeIO/WebAssembly/master/WebAssembly_uni.png',
		text: 'The WebAssembly Community Group has an initial (MVP) binary format release candidate and JavaScript API which are implemented in several browsers. It defines a WebAssembly binary format, which is not designed to be used by humans, as well as a human-readable "Linear Assembly Bytecode" format that resembles traditional assembly languages. The table below represents 3 different views of the same source code input from the left, as it is converted to a wasm intermediate format, then to wasm binary.',
		members:[
			{name:'Tetya Motya',   role:'SEO', src:'http://www.ouicestchic.com/wp-content/uploads/2015/03/Katrina-Turnbull-circle-avatar.png'},
			{name:'Eric Helgeson', role:'Team lead', src:'http://nathanrhale.com/wp-content/uploads/2015/01/round-avatar.png'},
			{name:'Alex Robinson', role:'Web design', src:'http://zenithonlinemarketing.co/wp-content/uploads/2015/08/Alex-Avatar-Circular1.png'}
		]


user_skills =-> div class:\user_skills style:'margin-top:30px',
	div class:\header,
		h2 class:'union_header_text' style:'font-size:30px',
			'Проектов'
			span style:'margin:5px' class:'label label-primary', '7'
			'Успешных'
			span style:'margin:5px' class:'label label-primary', '5'
	div style:'margin-top:30px',
		map skill-icon(80,_,\info), <[ adn amazon android angellist apple bandcamp behance behance-square bitbucket bitbucket-square bitcoin black-tie bluetooth bluetooth-b btc buysellads  deviantart digg dribbble dropbox drupal edge eercast empire envira etsy expeditedssl facebook facebook-official facebook-square firefox first-order flickr font-awesome fonticons fort-awesome forumbee foursquare free-code-camp get-pocket gg gg-circle git git-square ]>




# ## Окно "люди".
# #### Разные категории:
# 1. Специалист
# 2. Стартапер
# 3. Владелец бизнеса

# #### Блоки:
# 0. Картинка
# 1. О себе
# 2. Проект (возможно ли вставлять проект из категории проект, если он там есть?)
# 3. Прошлый опыт (с кнопочкой отправки запроса подтверждения соучастия по прошлым проектам)
# 4. Навыки (с бейджиками, подтверждающими их)
