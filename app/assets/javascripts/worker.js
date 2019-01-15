//= require action_cable
//= require ./shared/notifications
//= require_tree ./channels

const App = self.App = {};

let connected = true;
let notifications,
  basketsChannel,
  productsChannel;

function connect() {
  if (connected) { return; }
  App.cable.connection.monitor.reconnectAttempts = 2;
  App.cable.connection.monitor.start();
  connected = true;
}

function disconnect() {
  if (!connected) { return; }
  App.cable.connection.monitor.stop();
  // to make sure that it won't try to reconnect
  App.cable.connection.monitor.reconnectAttempts = 2;
  App.cable.connection.close();
  connected = false;
}

onmessage = function(e) {
  switch (e.data[0]) {
    case 'connect':
      connect();
      break;
    case 'disconnect':
      disconnect();
      break;
    case 'createConsumer':
      if (!App.cable) {
        App.cable = ActionCable.createConsumer(e.data[1]);
      }
      break;
    case 'createBasketsChannel':
      if (!basketsChannel) {
        basketsChannel = App.cable.subscriptions.create('BasketsChannel', BasketsChannel);
      }
      break;
    case 'createProductsChannel':
      if (!productsChannel) {
        productsChannel = App.cable.subscriptions.create('ProductsChannel', ProductsChannel);
      }
      productsChannel.basket_id = e.data[1];
      break;
    case 'enableNotifications':
      if (!notifications) {
        notifications = new Notifications();
      }
      notifications.on(e.data[1]);
      break;
    case 'disableNotifications':
      if (notifications) {
        notifications.off();
      }
      break;
    default:
      console.log(`Unknown case ${e.data}`);
  }
};
