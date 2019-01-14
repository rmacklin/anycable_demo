class self.Notifications
  on: (user_id) ->
    return if @active

    @active = true

    @notificationChannel = App.cable.subscriptions.create(
      { channel: 'NotificationChannel', id: user_id },
      NotificationChannel
    )

    @notificationChannel.handle_message = (type, data) ->
      if type is 'alert'
        postMessage(['errorMessage', data])
      else if type is 'success'
        postMessage(['successMessage', data])
      else
        postMessage(['simpleMessage', data])
  
  off: ->
    return unless @active

    @active = false
    @notificationChannel.unsubscribe()
