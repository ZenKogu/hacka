pageSession = new ReactiveDict

EstatesListItems = (cursor) ->
  if !cursor
    return []
  searchString = pageSession.get('EstatesListSearchString')
  sortBy = pageSession.get('EstatesListSortBy')
  sortAscending = pageSession.get('EstatesListSortAscending')
  if typeof sortAscending == 'undefined'
    sortAscending = true
  raw = cursor.fetch()
  # filter
  filtered = []
  if !searchString or searchString == ''
    filtered = raw
  else
    searchString = searchString.replace('.', '\\.')
    regEx = new RegExp(searchString, 'i')
    searchFields = [
      'name'
      'description'
    ]
    filtered = _.filter(raw, (item) ->
      match = false
      _.each searchFields, (field) ->
        value = (getPropertyValue(field, item) or '') + ''
        match = match or value and value.match(regEx)
        if match
          return false
        return
      match
    )
  # sort
  if sortBy
    filtered = _.sortBy(filtered, sortBy)
    # descending?
    if !sortAscending
      filtered = filtered.reverse()
  filtered

EstatesListExport = (cursor, fileType) ->
  data = EstatesListItems(cursor)
  exportFields = []
  str = convertArrayOfObjects(data, exportFields, fileType)
  filename = 'export.' + fileType
  downloadLocalResource str, filename, 'application/octet-stream'
  return


Template.Estates.rendered = ->  
  pageSession.set 'EstatesListStyle', 'table'
  pageSession.set 'EstatesCriterio', {}

Template.Estates.events
  'submit #dataview-controls': (e, t) ->
    false
  'click #dataview-search-button': (e, t) ->
    e.preventDefault()
    form = $(e.currentTarget).parent()
    if form
      searchInput = form.find('#dataview-search-input')
      if searchInput
        searchInput.focus()
        searchString = searchInput.val()
        pageSession.set 'EstatesListSearchString', searchString
    false
  'keydown #dataview-search-input': (e, t) ->
    `var form`
    `var searchInput`
    if e.which == 13
      e.preventDefault()
      form = $(e.currentTarget).parent()
      if form
        searchInput = form.find('#dataview-search-input')
        if searchInput
          searchString = searchInput.val()
          pageSession.set 'EstatesListSearchString', searchString
      return false
    if e.which == 27
      e.preventDefault()
      form = $(e.currentTarget).parent()
      if form
        searchInput = form.find('#dataview-search-input')
        if searchInput
          searchInput.val ''
          pageSession.set 'EstatesListSearchString', ''
      return false
    true
  'click .dataview-insert-button': (e, t) ->
    e.preventDefault()
    Router.go 'estates.insert', {}
    return
  'click .th-sortable': (e, t) ->
    e.preventDefault()
    oldSortBy = pageSession.get('EstatesListSortBy')
    newSortBy = $(e.target).attr('data-sort')
    pageSession.set 'EstatesListSortBy', newSortBy
    if oldSortBy == newSortBy
      sortAscending = pageSession.get('EstatesListSortAscending') or false
      pageSession.set 'EstatesListSortAscending', !sortAscending
    else
      pageSession.set 'EstatesListSortAscending', true
    return

  'click li': (e, t) ->
    e.preventDefault()
    Router.go 'estates',
      estateId: @_id
      fileId: null
    false
  'click .delete-button': (e, t) ->
    e.preventDefault()
    me = this
    bootbox.dialog
      message: 'Вы действительно хотите удалить?'
      title: 'Удалить'
      animate: false
      buttons:
        success:
          label: 'Да'
          className: 'btn-success'
          callback: -> Estates.remove _id: me._id

        danger:
          label: 'Нет'
          className: 'btn-default'
    false


  'click .data-search-button': (e, t) -> 
    pageSession.set('EstatesCriterio', {'_id':'43'})
    EstatesListItems Estates.find(  pageSession.get('EstatesCriterio')   )
    # text = $('#data-search-input').val()
    


  'click .edit-button': (e, t) ->
    e.preventDefault()
    Router.go 'estates.edit',
      estateId: @_id
      fileId: null
    false


Template.Estates.helpers
  'tableItems': -> EstatesListItems Estates.find(  pageSession.get('EstatesCriterio')   )
  'gallery_tail':(it)-> compact tail lines it
  'gallery_head':(it)-> prelude.head lines it
  'gallery_num':(it)->  [1 ... lines(it).length-2]



  'isEmpty': -> !@estates or @estates.count() == 0
  'isNotEmpty': -> @estates and @estates.count() > 0
  'isNotFound': ->  @estates and pageSession.get('EstatesListSearchString') and EstatesListItems(@estates).length == 0
  'searchString': -> pageSession.get 'EstatesListSearchString'
  'viewAsTable': -> pageSession.get('EstatesListStyle') == 'table'
  'viewAsList': ->  pageSession.get('EstatesListStyle') == 'list'
  'viewAsGallery': -> pageSession.get('EstatesListStyle') == 'gallery'
  'insertButtonClass': -> if !Meteor.user() ||  Meteor.user().roles[0]!='1' then 'hidden'

  'checked': (value) -> if value then 'checked' else ''
  'editButtonClass': ->   if !Meteor.user() ||  Meteor.user().roles[0]!='1' then 'hidden'
  'deleteButtonClass': -> if !Meteor.user() ||  Meteor.user().roles[0]!='1' then 'hidden'
