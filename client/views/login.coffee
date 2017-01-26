pageSession = new ReactiveDict
pageSession.set 'errorMessage', ''

Template.Login.rendered = ->
  $('input[autofocus]').focus()


Template.Login.created = ->
  pageSession.set 'errorMessage', ''


Template.Login.events
  'submit #login_form': (e, t) ->
    e.preventDefault()
    pageSession.set 'errorMessage', ''
    submit_button = $(t.find(':submit'))
    login_email = t.find('#login_email').value.trim()
    login_password = t.find('#login_password').value
    # check email
    if !isValidEmail(login_email)
      pageSession.set 'errorMessage', 'Пожалуйста, введите адрес почты.'
      t.find('#login_email').focus()
      return false
    # check password
    if login_password == ''
      pageSession.set 'errorMessage', 'Пожалуйста, введите пароль.'
      t.find('#login_email').focus()
      return false
    submit_button.button 'loading'
    Meteor.loginWithPassword login_email, login_password, (err) ->
      submit_button.button 'reset'
      if err
        pageSession.set 'errorMessage', err.message
      else Router.go '/'
    
Template.Login.helpers errorMessage: ->
  pageSession.get 'errorMessage'
