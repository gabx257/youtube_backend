import 'dart:collection';

import 'package:socket_io/socket_io.dart';

class Clients with ListMixin<Socket> {
  List<Socket> c = [];

  @override
  int get length => c.length;

  @override
  Socket operator [](int index) => c[index];

  @override
  void operator []=(int index, Socket value) => c[index] = value;

  @override
  set length(int newLength) => c.length = newLength;

  void emit(String event, [dynamic data]) {
    for (var client in c) {
      client.emit(event, data);
    }
  }

  @override
  void add(Socket element) {
    c.add(element);
  }
}

main() async {
  Clients clients = Clients();

  var io = Server();
  io.on('connection', (client) {
    var c = client as Socket;
    clients.add(c);
    print('connection /');

    client.on('play', (data) {
      print('play');
      clients.emit('play');
    });
    client.on('pause', (data) {
      print('pause');
      clients.emit('pause');
    });
    client.on('stop', (data) {
      print('stop');
      clients.emit('stop');
    });
    client.on('seek', (data) {
      print('seek');
      clients.emit('seek', data);
    });
    client.on('new', (data) {
      print('new $data');
      clients.emit('new', data);
    });
    client.on('confirm', (data) {
      print('client confirmed received => $data');
    });
  });
  io.listen(8080);
}
