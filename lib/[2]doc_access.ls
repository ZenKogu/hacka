
@MongoAccessGranted=(userId, dbName, operation,out=false)-> true
	# if Meteor.users.findOne(_id:Meteor.userId!)?roles
	# 	for role in Meteor.users.findOne(_id:Meteor.userId!).roles
	# 		if Meteor.roles?findOne(_id:role)?MongoAccessList && contains Meteor.roles.findOne(_id: role).MongoAccessList, dbName+'.'+operation => out:= true
	# 	if Meteor.users.findOne(_id:userId).blocked => out:= false
	# out

@AccessQ = (usrID, docID, dbName, operation) -> ''
	# template = ''
	# if not Meteor.userId()
	# 	Rec event: 'error', errorType: 'not user', operation: operation, dbName: dbName, document: docID
	# 	Router.go 'login'

	# doc = {docId: docID, mongoCol: dbName, userId: usrID}
	# zisDoc = BlockedDocs.findOne({docId: docID, mongoCol: dbName})

	# switch operation
	# 	when 'update'   
	# 		if not MongoAccessGranted  Meteor.userId(), dbName, operation 
	# 			template ='accessDenied'
	# 			Rec event: 'error', errorType: 'access denied', operation: operation, dbName: dbName, document: docID
	# 		else if not oneResourceQ usrID, docID, dbName 
	# 			template = 'editingOtherResource'
	# 			Rec event: 'error', errorType: 'editing other resourse', operation: operation, dbName: dbName, document: docID
	# 		else if not oneEditorQ   usrID, docID, dbName 
	# 			template = 'docEditing'
	# 			Rec event: 'error', errorType: 'document already blocked', operation: operation, dbName: dbName, document: docID
	# 		else 
	# 			blockRecord  usrID, docID, dbName 
	# 			Rec event: 'access granted', operation: operation, dbName: dbName, document: docID
	# 		return template

	# 	when 'read', 'insert'
	# 		if not MongoAccessGranted usrID, dbName, operation
	# 			template = 'accessDenied'
	# 			Rec event: 'error', errorType: 'access denied', operation: operation, dbName: dbName, document: docID
	# template

@TranslitRusEng = (text, translit = '') -> #GOST_7.79-2000
	mapping= {\а :\a, \б :\b, \в :\v, \г :\g, \д :\d, \е :\e, \ё :\e, \ж :\zh, \з :\z, \и :\i, \й :\i, \к :\k, \л :\l, \м :\m, \н :\n, \о :\o, \п :\p, \р :\r, \с :\s, \т :\t, \у :\y, \ф :\f, \х :\kh, \ц :\tc, \ч :\ch, \ш :\sh, \щ :\shch, \ь :'', \ы :\y, \ъ :'', \э :\e, \ю :\iu, \я :\ia, ' ':\-, \1 :\1, \2 :\2, \3 :\3, \4 :\4, \5 :\5, \6 :\6, \7 :\7, \8 :\8, \9 :\9, \0 :\0 , \_ :'', \- :''}
	for letter in text.split('')
		translit += mapping[letter.toLowerCase!]||''
	translit

@subsSet = (set)->
	subOut = []
	for sub in flatten set 
		subOut.push(Meteor.subscribe(sub))
	subOut

@oneResourceQ=(userID, docID, dbName)-> true #BlockedDocs.find({userId:userID, mongoCol:dbName, docId:$ne:docID}).count()==0
@oneEditorQ=(userID, docID, dbName)->   true #BlockedDocs.find({docId:docID, mongoCol:dbName, userId:$ne:userID}).count()==0
@blockRecord=(userID, docID, dbName)->  true #if BlockedDocs.find({docId: docID, mongoCol: dbName}).count()==0  => BlockedDocs.insert docId: docID, mongoCol: dbName
@removeBlock=(usrID, dbName)->          true #BlockedDocs.remove _id:BlockedDocs.findOne({userId:usrID, mongoCol:dbName})._id
@isValidPassword=(value, min_length)->  if !value or value == '' or value.length < min_length => false else true  
@Rec=(opt={})->          # RecData.insert opt
@CountUp=(linkObj)->     # ShortLinks.update {_id:linkObj._id}, $set: {convCount:linkObj.convCount+1} 
@isValidEmail=(value)->  if /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/.test(value) => true else false
