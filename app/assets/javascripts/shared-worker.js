//= require ./worker

onconnect = function(e) {
  const port = e.ports[0];

  port.onmessage = onmessage;

  self.postMessage = port.postMessage.bind(port);
};
