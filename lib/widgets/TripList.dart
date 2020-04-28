import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/model/Trip.dart';
import 'package:tripmate/service/TripService.dart';

class Trips extends StatefulWidget {
  Trips() : super();

  @override
  TripsState createState() => TripsState();
}

class TripsState extends State<Trips> {
  bool showTextField = false;
  TextEditingController controller = TextEditingController();
  static String collectionName = "trips";
  bool isEditing = false;
  TripService _tripService = TripService(collectionName);

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tripService.getTrips(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print("Documents ${snapshot.data.documents.length}");
          return buildList(context, snapshot.data.documents);
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data)).toList(),
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data) {
    final trip = Trip.fromSnapshot(data);
    return Padding(
      key: ValueKey(trip.title),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 5, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'http://getdrawings.com/free-icon/google-map-pin-icon-png-68.png',
                    ),
                  ),
                  title: Text(trip.title),
                  subtitle: Text(trip.notes),
                  isThreeLine: true,
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('UPDATE'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onPressed: () {/* ... */},
                    ),
                    FlatButton(
                      child: const Text('DELETE'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onPressed: () {/* ... */},
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: buildBody(context),
          )
        ],
      ),
    );
  }
}
