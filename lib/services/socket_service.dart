import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  Socket _socket;
  ServerStatus _serverStatus = ServerStatus.Connecting;
  Socket get socket => this._socket;

  ServerStatus get serverStatus => this._serverStatus;
  SocketService() {
    this._initConfig();
  }
  void _initConfig() {
    this._socket = io(
        'http://192.168.8.110:6300/',
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());

    this._socket.on('connect', (_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      this._socket.emit('mensaje', 'dispositivo movil conectado');
      notifyListeners();
    });

    this._socket.on('disconnect', (data) {
      this._serverStatus = ServerStatus.Offline;
      this._socket.emit('mensaje', 'dispositivo movil desconectado');
      notifyListeners();
    });

    this._socket.on('mensaje', (data) {
      print(data);
      this.socket.emit('mensaje', 'gracias por recibirme de nuevo servidor');
    });

    this._socket.connect();
  }
}
