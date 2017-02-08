@fs = Npm.require 'fs'
@path = Npm.require 'path'

@DBController = (DB, accessType=\easy, admSection=\null, specFields={})->
	DB.allow do
		switch accessType
			| \hard => do
				insert: (uId,doc)-> MongoAccessGranted uId, admSection, \insert  
				update: (uId,doc)-> 
					if uId == \1 => true
					else if (admSection==\users || admSection==\roles) and doc._id==\1 => false
					else MongoAccessGranted uId, admSection, \update 
				remove: (uId,doc)-> 
					if (admSection==\users || admSection==\roles) and doc._id==\1  => false
					else if admSection==\users and uId==doc._id => false 
					else MongoAccessGranted uId, admSection, \update 
			| \easy => do	
				insert: -> true
				update: -> true
				remove: -> true					 
	DB.before.insert (userId, doc, AllId=[0])~>
		[ AllId.push +obj._id 	for obj in DB.find!fetch! ]
		doc._id = String <| +_.max(AllId) + 1 
		doc.createdAt = new Date
		doc.createdBy = userId
		[ doc.i = specFields.i 	for i of specFields ]




