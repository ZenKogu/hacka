# Estates.allow
#   insert: (userId) ->
#       MongoAccessGranted userId,'estates','insert'
#   update: (userId) ->
#     MongoAccessGranted userId,'estates','update'
#   remove: (userId) ->
#     MongoAccessGranted userId,'estates','remove'

# Estates.before.insert (userId, doc) ->
#   AllId = [0]
#   _.each Estates.find({},{}).fetch(), (col) ->
#     AllId.push +col._id
#   maxId = _.max AllId
#   doc._id = String(+maxId + 1)
#   doc.createdAt = new Date
#   doc.createdBy = userId
#   doc.published = 'нет'
  #   col.modifiedAt = col.createdAt
  #   col.modifiedBy = col.createdBy
  # if !col.createdBy
  #     col.createdBy = userId






# Estates.before.update (userId, col, fieldNames, modifier, options) ->
#     modifier.$set = modifier.$set or {}
#     modifier.$set.modifiedAt = new Date
#     modifier.$set.modifiedBy = userId


# Estates.before.upsert (userId, selector, modifier, options) ->
#     modifier.$set = modifier.$set or {}
#     modifier.$set.modifiedAt = new Date
#     modifier.$set.modifiedBy = userId

#     ###BEFORE_UPSERT_CODE###


# Estates.before.remove (userId, col) ->
#   if Projects.find({collection: col.name}).count > 0
#     false
# Estates.after.insert (userId, col) ->
# Estates.after.update (userId, col, fieldNames, modifier, options) ->
# Estates.after.remove (userId, col) ->
#     Estates.remove parentId: col._id







# Meteor.publish 'estates', (estateId) ->
#   Estates.find {
#     # estateId: estateId
#     # createdBy: @userId
#   }, sort: [ 'filename' ]
# Meteor.publish 'file', (fileId) ->
#   Estates.find {
#     _id: fileId
#     createdBy: @userId
#   }, {}


# Meteor.publish 'estates', ->
#   Estates.find {}, {}
# Meteor.publish 'estate', (estateId) ->
#   Estates.find {
#     _id: estateId
#   }, {}
# Meteor.publish 'estate_empty', ->
#   Estates.find {
#     _id: null
#   }, {}


