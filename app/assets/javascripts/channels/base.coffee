after = (time, fn) ->
  setTimeout(fn, time)

self.BaseChannel = {
  log: (msg) ->
    postMessage(['successMessage', "[ActionCable##{@name()}] #{msg}"])

  connected: ->
    @log 'Connected'
    after 100, => @handle_connected?()

  disconnected: ->
    @log 'Disconnected'

  received: (data) ->
    @log 'Message Received'
    @handle_message?(data.type, data.data)
}
