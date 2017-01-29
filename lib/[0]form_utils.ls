@isValidEmail = (value) ->
  filter = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
  if filter.test(value)
    return true
  false

@isValidPassword = (value, min_length) ->
  if !value or value == '' or value.length < min_length
    return false
  true

@isValidIPv4 = (value) ->
  filter = /^(\d{1,3}\.){3}(\d{1,3})$|^(0x[\da-fA-F]{2}\.){3}(0x[\da-fA-F]{2})$|^(0[0-3][0-7]{2}\.){3}(0[0-3][0-7]{2})|^0x[\da-fA-F]{8}$|^[0-4]\d{9}$|^0[0-3]\d{10}$/
  if filter.test(value)
    return true
  false

@isValidIPv6 = (value) ->
  filter = /^([\da-fA-F]{1,4}:){7}([\da-fA-F]{1,4})$/
  if filter.test(value)
    return true
  false

@isValidIP = (value) ->
  if isValidIPv4(value) or isValidIPv6(value)
    return true
  false

@timeToSeconds = (timeStr, timeFormat) ->
  t = timeStr or '12:00 am'
  tf = timeFormat or 'h:mm a'
  m = moment.utc('01/01/1970 ' + t, 'MM/DD/YYYY ' + tf)
  if !m.isValid()
    return null
  m.unix()

@secondsToTime = (seconds, timeFormat) ->
  s = seconds or 0
  tf = timeFormat or 'h:mm a'
  if String(s).toUpperCase() == 'NOW'
    return moment(new Date).format(tf)
  moment.unix(s).utc().format tf

@validateForm = (formObject, validationCallback, errorCallback, submitCallback) ->
  values = {}
  error = false
  formObject.find('input,select,textarea').each ->
    skipValue = false
    inputObject = $(this)
    formGroup = inputObject.closest('.form-group')
    fieldName = inputObject.attr('name')
    labelObject = formGroup.find('label[for=\'' + fieldName + '\']')
    errorLabel = formGroup.find('#error-text')
    fieldValue = inputObject.val()
    dataType = if inputObject.attr('data-type') then inputObject.attr('data-type').toUpperCase() else 'STRING'
    dataFormat = inputObject.attr('data-format') or ''

    validationError = (errorMessage) ->
      formGroup.addClass 'has-error'
      inputObject.focus()
      if errorLabel
        errorLabel.text(errorMessage).removeClass('hidden').addClass 'visible'
        errorLabel.closest('.field').addClass 'error'
      if errorCallback
        errorCallback errorMessage
      error = true
      return

    if !fieldName
      skipValue = true
    if inputObject.attr('type') == 'checkbox'
      # auto set data type for checkbox
      if !inputObject.attr('data-type')
        # single checkbox with that name means dataType="BOOL" else it is "ARRAY"
        if formObject.find('input[name=\'' + fieldName + '\']').length == 1
          dataType = 'BOOL'
        else
          dataType = 'ARRAY'
      if dataType == 'BOOL'
        fieldValue = inputObject.is(':checked')
      if dataType == 'ARRAY'
        fieldValue = if inputObject.is(':checked') then fieldValue else ''
    # radio has value only if checked
    if inputObject.attr('type') == 'radio'
      fieldValue = if inputObject.is(':checked') then fieldValue else ''
      if dataType != 'ARRAY' and !fieldValue
        skipValue = true
    minValue = inputObject.attr('data-min')
    maxValue = inputObject.attr('data-max')
    labelText = if inputObject.attr('placeholder') then inputObject.attr('placeholder') else ''
    if !labelText
      labelText = if labelObject then labelObject.text() else fieldName
    # hide error message from previous call
    formGroup.removeClass 'has-error'
    if errorLabel
      errorLabel.text('').removeClass('visible').addClass 'hidden'
      errorLabel.closest('.field').removeClass 'error'
    if !skipValue
      # Check required
      if inputObject.attr('required') and !fieldValue
        validationError labelText + ' is required'
        return false
      # checkbox doesn't have required property, so I set parent container's data-required to true
      if inputObject.attr('type') == 'checkbox'
        checkboxContainer = inputObject.closest('.input-div')
        req = checkboxContainer.attr('data-required')
        if req
          atLeastOneChecked = false
          checkboxContainer.find('input[type=\'checkbox\']').each ->
            if $(this).is(':checked')
              atLeastOneChecked = true
            return
          if !atLeastOneChecked
            validationError labelText + ' is required'
            return false
      # Convert to bool
      if dataType == 'BOOL'
        if fieldValue == 'true'
          fieldValue = true
        else
          if fieldValue == 'false'
            fieldValue = false
          else
            fieldValue = if fieldValue then true else false
      # Check Integer, also min and max value
      if dataType == 'INTEGER'
        if fieldValue == ''
          fieldValue = null
        else
          intValue = parseInt(fieldValue)
          if isNaN(intValue)
            validationError labelText + ': Invalid value entered'
            return false
          if minValue and !isNaN(parseInt(minValue)) and intValue < parseInt(minValue)
            if maxValue and !isNaN(parseInt(maxValue))
              validationError labelText + ' must be between ' + minValue + ' and ' + maxValue
            else
              validationError labelText + ' must be equal or greater than ' + minValue
            return false
          if maxValue and !isNaN(parseInt(maxValue)) and intValue > parseInt(maxValue)
            if minValue and !isNaN(parseInt(minValue))
              validationError labelText + ' must be between ' + minValue + ' and ' + maxValue
            else
              validationError labelText + ' must be equal or less than ' + maxValue
            return false
          fieldValue = intValue
      # Check Float, also Min and Max value
      if dataType == 'FLOAT'
        if fieldValue == ''
          fieldValue = null
        else
          floatValue = parseFloat(fieldValue)
          if isNaN(floatValue)
            validationError labelText + ': Invalid value entered'
            return false
          if minValue and !isNaN(parseFloat(minValue)) and floatValue < parseFloat(minValue)
            validationError labelText + ' must be equal or greater than ' + minValue
            return false
          if maxValue and !isNaN(parseFloat(maxValue)) and floatValue > parseFloat(maxValue)
            validationError labelText + ' must be equal or less than ' + maxValue
            return false
          fieldValue = floatValue
      # Check valid E-mail address
      if dataType == 'EMAIL'
        if fieldValue and !isValidEmail(fieldValue)
          validationError labelText + ': please enter valid e-mail address'
          return false
      if dataType == 'IP'
        if fieldValue and !isValidIP(fieldValue)
          validationError labelText + ': please enter valid IPv4 or IPv6 address'
          return false
      if dataType == 'IPV4'
        if fieldValue and !isValidIPv4(fieldValue)
          validationError labelText + ': please enter valid IPv4 address'
          return false
      if dataType == 'IPV6'
        if fieldValue and !isValidIPv6(fieldValue)
          validationError labelText + ': please enter valid IPv6 address'
          return false
      if dataType == 'ARRAY'
        if !_.isArray(fieldValue)
          newValue = if values[fieldName] then values[fieldName] else []
          if fieldValue
            newValue.push fieldValue
          fieldValue = newValue
      # TIME (user input "12:30 am" produces "1800" that is number of seconds from midnight)
      if dataType == 'TIME'
        if fieldValue == ''
          fieldValue = null
        seconds = timeToSeconds(fieldValue, dataFormat)
        if isNaN(parseInt(seconds))
          validationError labelText + ': Invalid value entered.'
          return false
        fieldValue = seconds
      if dataType == 'DATE'
        if fieldValue == ''
          fieldValue = null
        else
          date = moment(fieldValue, dataFormat)
          if !date.isValid()
            validationError labelText + ': Invalid value entered.' + (if dataFormat then ' Date is expected in format "' + dataFormat + '"' else '')
            return false
          fieldValue = date.toDate()
      if dataType == 'STRING'
        if _.isArray(fieldValue)
          fieldValue = fieldValue.toString()
      # Custom validation
      if validationCallback
        errorMessage = validationCallback(fieldName, fieldValue)
        if errorMessage
          validationError errorMessage
          return false
      values[fieldName] = fieldValue
    return
  if error
    return
  values = deepen(values)
  if submitCallback
    submitCallback values
  return

Handlebars.registerHelper 'itemIsChecked', (desiredValue, itemValue) ->
  if !desiredValue and !desiredValue == false and !itemValue and !itemValue == false
    return ''
  if _.isArray(desiredValue)
    return if desiredValue.indexOf(itemValue) >= 0 then 'checked' else ''
  if desiredValue == itemValue then 'checked' else ''
Handlebars.registerHelper 'optionIsSelected', (desiredValue, itemValue) ->
  if !desiredValue and !desiredValue == false and !itemValue and !itemValue == false
    return ''
  if _.isArray(desiredValue)
    return if desiredValue.indexOf(itemValue) >= 0 then 'selected' else ''
  if desiredValue == itemValue then 'selected' else ''

@bootboxDialog = (template, data, options) ->
  tmpl = null
  if _.isString(template)
    tmpl = Template[template]
  else
    tmpl = template
  div = document.createElement('div')
  Blaze.renderWithData tmpl, data, div
  options.message = div
  bootbox.dialog options
  return





########### OBJECT UTILS

@getPropertyValue = (propertyName, obj) ->
  propertyName.split('.').reduce ((o, i) ->
    o[i]
  ), obj

@deepen = (o) ->
  oo = {}
  t = undefined
  parts = undefined
  part = undefined
  for k of o
    t = oo
    parts = k.split('.')
    key = parts.pop()
    while parts.length
      part = parts.shift()
      t = t[part] = t[part] or {}
    t[key] = o[k]
  oo

@convertArrayOfObjects = (data, exportFields, fileType) ->
  data = data or []
  fileType = fileType or 'csv'
  exportFields = exportFields or []
  str = ''
  # export to JSON
  if fileType == 'json'
    tmp = []
    _.each data, (doc) ->
      obj = {}
      _.each exportFields, (field) ->
        obj[field] = doc[field]
        return
      tmp.push obj
      return
    str = JSON.stringify(tmp)
  # export to CSV or TSV
  if fileType == 'csv' or fileType == 'tsv'
    columnSeparator = ''
    if fileType == 'csv'
      columnSeparator = ','
    if fileType == 'tsv'
      # "\t" object literal does not transpile correctly to coffeesctipt
      columnSeparator = String.fromCharCode(9)
    _.each exportFields, (field, i) ->
      if i > 0
        str = str + columnSeparator
      str = str + '"' + field + '"'
      return
    #\r does not transpile correctly to coffeescript
    str = str + String.fromCharCode(13) + '\n'
    _.each data, (doc) ->
      _.each exportFields, (field, i) ->
        if i > 0
          str = str + columnSeparator
        value = getPropertyValue(field, doc) + ''
        value = value.replace(/"/g, '""')
        if typeof value == 'undefined'
          str = str + '""'
        else
          str = str + '"' + value + '"'
        return
      #\r does not transpile correctly to coffeescript
      str = str + String.fromCharCode(13) + '\n'
      return
  str