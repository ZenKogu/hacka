@Unions    = new Mongo.Collection \unions 
@Comrades   = new Mongo.Collection \comrades
@Images = new FS.Collection \images, 
	stores: [new (FS.Store.FileSystem)('images', path: '~/hacka/pics')]
	filter:  allow: contentTypes: [ 'image/*' ], extensions: <[ png jpg jpeg jpeg2000 bmp gif ]>

@Documents = new FS.Collection \documents,
	stores: [new (FS.Store.FileSystem)(\documents, path: '~/hacka/docs')]
	filter: allow: extensions: <[ doc docx pdf zip rar ppt pptx xls xlsx ]>

# @Images = new FS.Collection \images, 
# 	stores: [new (FS.Store.FileSystem)('images', path: '~/www/node.school2100.com/server/pics')]
# 	filter:  allow: contentTypes: [ 'image/*' ], extensions: <[ png jpg jpeg jpeg2000 bmp gif ]>

# @Documents = new FS.Collection \documents,
# 	stores: [new (FS.Store.FileSystem)(\documents, path: '~/www/node.school2100.com/server/docs')]
# 	filter: allow: extensions: <[ doc docx pdf zip rar ppt pptx xls xlsx ]>
