#= require ./base

self.BasketsChannel = Object.assign({
  handle_connected: -> @perform 'follow',
  handle_message: (type, data) ->
    postMessage(['BasketsChannel.handle_message', type, data])
  name: -> 'BasketsChannel'
}, BaseChannel)

