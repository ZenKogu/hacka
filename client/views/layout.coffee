Template.layout.helpers
	'rolesRoute':    -> if Meteor.userId()=='1' then '' else 'hidden'
	'usersRoute':    -> if Meteor.userId()=='1' then '' else 'hidden'
	'colRoute':      -> if Meteor.userId()=='1' then '' else 'hidden'
	'materialRoute': -> '' #if Meteor.userId()=='1' then '' else 'hidden'
	# 'newRoute':    -> if MongoAccessGranted Meteor.userId(), 'news',       'read' then '' else 'hidden'
	# 'eventRoute':    -> if MongoAccessGranted Meteor.userId(), 'events',       'read' then '' else 'hidden'
	# 'videoRoute':      -> if MongoAccessGranted Meteor.userId(), 'videos', 'read' then '' else 'hidden'
	# 'fileRoute': -> if MongoAccessGranted Meteor.userId(), 'files',   'read' then '' else 'hidden'
	# 'gallerieRoute':    -> if MongoAccessGranted Meteor.userId(), 'galleries',       'read' then '' else 'hidden'
	# 'commentRoute':    -> if MongoAccessGranted Meteor.userId(), 'comments',       'read' then '' else 'hidden'


Template.layout.helpers
	'isPrivateLayout':-> true #orList map ((it)->it=='admin'||'doc'), split('/', Router.current().originalUrl)
	'common_layout':-> currentID() == 'estates'
	'NotEstatesRoute':-> currentID() != 'estates'
Template.layout.events
	'click .logout':-> Meteor.logout(); Router.go '/' #Meteor.call 'logoutAndMain'



# @resizeElements = ()->
# 	if window.innerWidth > 1280
# 		shift = ((window.innerWidth-1280)/2);
# 		$('.siteWrapper').attr 'style', 'position:absolute; left:'+shift+'px; right:'+shift+'px;'
# 		$('.footer-social-background').attr 'style', 'position:absolute; left:-'+shift+'px; right:-'+shift+'px; width:'+window.innerWidth+'px; height:88px;  background-color:#3673e6; position:absolute'
# 		$('.footer-links-background').attr 'style', 'position:absolute; left:-'+shift+'px; right:-'+shift+'px; width:'+window.innerWidth+'px; height:231px; top:88px; background-color:#0f0f0f; position:absolute'
# 		$('.nav-main-background').attr 'style', 'left:-'+shift+'px; right:-'+shift+'px; width:'+window.innerWidth+'px;  position:absolute;  height:140px; background-color:rgb(65,132,242)'
# 		$('.nav-links-background').attr 'style', 'left:-'+shift+'px; right:-'+shift+'px; width:'+window.innerWidth+'px;  height:60px; position:absolute; top:140px;  background: linear-gradient(to right, rgb(26,82,189) 0%,rgb(58,120,233) 100%);'
# 		$('.content').attr 'style', 'min-height:'+window.innerHeight+'px;  width:1280px'
# 		$('.gray-background').attr 'style', 'left:-'+shift+'px; right:-'+shift+'px; width:'+window.innerWidth+'px;  position:absolute;  top:200px; height:532px; background-color:rgb(231,227,227)'




# Template.layout.rendered = ->	resizeElements()
# $( window ).resize ()-> resizeElements()


# Template.grayBackground.rendered = ->
# 		$('.gray-background').attr 'style', 'left:-'+shift+'px; right:-'+shift+'px; width:'+window.innerWidth+'px;  position:absolute;  top:200px; height:532px; background-color:rgb(231,227,227)'
 

# Template.PrivateLayoutLeftMenuPrivate.helpers
#   'menu': ->
# 	if Router.current().route.getName() == 'materials.edit' then 'navbar-cell-creator' else ''



# Template.PrivateLayout.rendered = ->
# 	sec = (db,text)-> 
# 		if MongoAccessGranted(Meteor.userId(), db, 'read')
# 			'<li><a href="/admin/' + db + '"><span class ' + text + ' </a></li>'
# 		else ''
# 		$('.navbar-right').html ''
# 		$('.navbar-right').append( 
# 			sec('users','Пользователи') + 
# 			sec('materials','Материалы') + 
# 			sec('collections','Коллекции') +
# 			sec('roles','Роли') +
# 			sec('news','Новости') +
# 			sec('videos','Видео') +
# 			sec('files','Файлы') +
# 			sec('events','События') +
# 			sec('galleries','Галереи') +
# 			sec('comments','Комментарии') 
# 		)
# 	$('.navbar-right').append '<li><a class = "logout">Выйти</a></li>'




	
# Template.PrivateLayout.events
# 	'click .logout': () -> Meteor.logout(); Router.go '/' #Meteor.call 'logoutAndMain'

# 	'click': ->
# 		sec = (db,text)-> 
# 			if MongoAccessGranted(Meteor.userId(), db, 'read')
# 				'<li><a href="/admin/' + db + '"> ' + text + ' </a></li>'
# 			else ''
# 		$('.navbar-right').html ''
# 		$('.navbar-right').append( 
# 			sec('users','Пользователи') + 
# 			sec('materials','Материалы') + 
# 			sec('collections','Коллекции') +
# 			sec('roles','Роли') +
# 			sec('news','Новости') +
# 			sec('videos','Видео') +
# 			sec('files','Файлы') +
# 			sec('events','События') +
# 			sec('galleries','Галереи') +
# 			sec('comments','Комментарии') 
# 			)
# 		$('.navbar-right').append '<li><a class = "logout">Выйти</a></li>'

# 			