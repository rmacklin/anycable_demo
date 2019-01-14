App = window.App = {}

connected = true

App.connect = ->
  window.appWorker.postMessage(['connect'])

App.disconnect = ->
  window.appWorker.postMessage(['disconnect'])

App.utils = 
  successMessage: (message) ->
    return unless message
    console.info(message)
    Materialize.toast(message, 2000, 'green')

  errorMessage: (message) ->
    return unless message
    console.warn(message)
    Materialize.toast(message, 4000, 'red')

  simpleMessage: (message) ->
    return unless message
    console.log(message)
    Materialize.toast(message, 4000, 'grey')

  ajaxErrorHandler: (e, data) ->
    message = 'Unknown error'
    if data.status == 401
      message = 'Sign in, please'
    else if data.status == 404
      message = 'Not found'
    else if data.status >= 400 && data.status < 500
      message = data.responseText

    App.utils.errorMessage message

  render: (template, data) ->
    JST["templates/#{template}"](data)

$ ->
  App.utils.successMessage(App.flash?.success)
  App.utils.errorMessage(App.flash?.error)

  $('.online-switch input[type=checkbox]').on 'change', (e) ->
    if @checked
      App.connect()
    else
      App.disconnect()


  appWorker.postMessage([
    'createConsumer',
    createWebSocketURL(
      document.head.querySelector("meta[name='action-cable-url']").getAttribute("content")
    )
  ])

  return unless gon.user_id

  appWorker.postMessage(['enableNotifications', gon.user_id])

  notificationsBtn = $('.notifications-btn')

  notificationsBtn.on 'click', (e) ->
    if notificationsBtn.hasClass('is-disabled')
      appWorker.postMessage(['enableNotifications', gon.user_id])
    else
      appWorker.postMessage(['disableNotifications'])
    notificationsBtn.toggleClass('is-disabled')

