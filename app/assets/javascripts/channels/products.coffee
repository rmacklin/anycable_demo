#= require ./base

self.ProductsChannel = Object.assign({
  handle_connected: ->
    @perform 'follow', id: this.basket_id
  handle_message: (type, data) ->
    postMessage(['ProductsChannel.handle_message', type, data])
  name: -> 'ProductsChannel'
}, BaseChannel)

