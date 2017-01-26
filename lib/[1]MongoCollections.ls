@ShortLinks 	= new Mongo.Collection \shortLinks
@Collections    = new Mongo.Collection \collections 
@RecData        = new Mongo.Collection \recData 
@BlockedDocs    = new Mongo.Collection \blockedDocs 
@News 	        = new Mongo.Collection \news 
@Files          = new Mongo.Collection \files
@Videos 	    = new Mongo.Collection \videos
@Galleries 	    = new Mongo.Collection \galleries
@Events 		= new Mongo.Collection \events
@Comments 		= new Mongo.Collection \comments 
@Materials      = new Mongo.Collection \materials 
@Projects       = new Mongo.Collection \projects 
@Estates = new Mongo.Collection \estates 
@Images = new FS.Collection \images, 
	stores: [new (FS.Store.FileSystem)('images', path: '~/www/legacy.school2100.com/pics')]
	filter:  allow: contentTypes: [ 'image/*' ], extensions: <[ png jpg jpeg jpeg2000 bmp gif ]>

@Documents = new FS.Collection \documents,
	stores: [new (FS.Store.FileSystem)(\documents, path: '~/www/legacy.school2100.com/docs')]
	filter: allow: extensions: <[ doc docx pdf zip rar ppt pptx xls xlsx ]>

# @Images = new FS.Collection \images, 
# 	stores: [new (FS.Store.FileSystem)('images', path: '~/www/node.school2100.com/server/pics')]
# 	filter:  allow: contentTypes: [ 'image/*' ], extensions: <[ png jpg jpeg jpeg2000 bmp gif ]>

# @Documents = new FS.Collection \documents,
# 	stores: [new (FS.Store.FileSystem)(\documents, path: '~/www/node.school2100.com/server/docs')]
# 	filter: allow: extensions: <[ doc docx pdf zip rar ppt pptx xls xlsx ]>
