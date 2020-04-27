import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/model/Trip.dart';
import 'package:tripmate/service/TripService.dart';

class Trips extends StatefulWidget {
  Trips() : super();

  final String title = "CloudFireStore Demo";

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
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text(trip.title),
          subtitle: Text(trip.notes),
          contentPadding: EdgeInsets.all(15),
        ),
      ),
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
