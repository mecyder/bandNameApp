import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  const StatusPage();

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.socket.emit('mensaje-flutter',
              {'nombre': 'Flutter', 'mensaje': 'hola desde flutter'});
        },
        child: Icon(Icons.message),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Estado Servidor: ${socketService.serverStatus}'),
          getStatus(socketService.serverStatus)
        ],
      )),
    );
  }

  Widget getStatus(dynamic status) {
    if (status == ServerStatus.Online) {
      return CircleAvatar(backgroundColor: Colors.green);
    }
    if (status == ServerStatus.Offline) {
      return CircleAvatar(backgroundColor: Colors.red);
    }
    return Container();
  }
}
