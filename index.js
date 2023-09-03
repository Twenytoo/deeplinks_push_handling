var express = require('express');
var server = express();

server.get('/.well-known/apple-app-site-association', function(request, response) {
  response.sendFile(__dirname +  '/apple-app-site-association.json');
});

server.listen(80)