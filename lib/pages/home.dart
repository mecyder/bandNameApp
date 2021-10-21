import 'package:band_names/models/bands.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Ruth Esther Sandoval', votes: 3),
    Band(id: '2', name: 'Lily Goodman', votes: 5),
    Band(id: '3', name: 'Rudy Michely', votes: 4),
    Band(id: '4', name: 'Junior Kelly Marchena', votes: 5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text('BandName'),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 1,
          onPressed: addNewBand,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (context, index) => _bandTitle(bands[index])));
  }

  Widget _bandTitle(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        //TODO:llamar metodo del api para eliminar
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
        builder: (context) {
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
    if (name.length > 1) {
      this
          .bands
          .add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
