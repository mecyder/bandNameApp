import 'package:band_names/models/bands.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: '1', name: 'Ruth Esther Sandoval', votes: 3),
    // Band(id: '2', name: 'Lily Goodman', votes: 5),
    // Band(id: '3', name: 'Rudy Michely', votes: 4),
    // Band(id: '4', name: 'Junior Kelly Marchena', votes: 5),
  ];
  @override
  void initState() {
    super.initState();
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('activeBand', _handleActiveBands);
  }

  _handleActiveBands(dynamic payload) {
    print(payload);
    this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text('BandName'),
          actions: [getStatus(socketService.serverStatus)],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 1,
          onPressed: addNewBand,
          child: Icon(Icons.add),
        ),
        body: Column(
          children: [
            _showGrafic(),
            Expanded(
              child: ListView.builder(
                  itemCount: bands.length,
                  itemBuilder: (context, index) => _bandTitle(bands[index])),
            ),
          ],
        ));
  }

  Widget _bandTitle(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        socketService.socket.emit('deleteBand', {'id': band.id});
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Delete Band',
              style: TextStyle(color: Colors.white),
            )),
      ),
      child: ListTile(
        onTap: () {
          print(Text(band.name));
          socketService.socket.emit('addVotes', {'id': band.id});
        },
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}'),
      ),
    );
  }

  addNewBand() {
    final newBandNameController = TextEditingController();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('New band name'),
            content: TextField(
              controller: newBandNameController,
            ),
            actions: [
              MaterialButton(
                onPressed: () => addBandToList(newBandNameController.text),
                child: Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
              )
            ],
          );
        });
  }

  addBandToList(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      // this
      //     .bands
      //     .add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      // setState(() {});
      socketService.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget getStatus(dynamic status) {
    if (status == ServerStatus.Online) {
      return Container(margin: EdgeInsets.all(10.0), child: Icon(Icons.wifi));
    }
    if (status == ServerStatus.Offline) {
      return Container(
          margin: EdgeInsets.all(
            10.0,
          ),
          child: Icon(Icons.wifi_off_outlined));
    }
    return Container();
  }

  _showGrafic() {
    Map<String, double> dataMap = new Map();
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });
    return Container(
        height: 200, width: double.infinity, child: PieChart(dataMap: dataMap));
  }
}
