import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/model/Trip.dart';
import 'package:tripmate/service/TripService.dart';
import 'package:tripmate/widgets/dialog/TripDeleteDialog.dart';
import 'package:tripmate/widgets/trip/UpdateTrip.dart';
import 'package:tripmate/widgets/trip/ViewTrip.dart';

/// Implementation of the [TripList] widget.
/// Returns a [Scaffold] widget.
class TripList extends StatefulWidget {
  TripList() : super();

  @override
  _TripListState createState() => _TripListState();
}

/// State of the [TripList] widget.
class _TripListState extends State<TripList> {
  TripService _tripService = TripService();

  /// Fetches [Trip]s from the Firebase instance and displays them as a list.
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tripService.getTrips(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print("Trips ${snapshot.data.documents.length}");
          if (snapshot.data.documents.length == 0) {
            return Text(
              'You have no planned trips.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                letterSpacing: 1,
              ),
            );
          } else {
            return _buildList(context, snapshot.data.documents);
          }
        }
        return CircularProgressIndicator();
      },
    );
  }

  /// Returns a empty [Container] with some height to add to the bottom of the list,
  /// to give some reading room to the user, without conflicting
  /// with the [FloatingActionButton] widget on top.
  Widget _getBottomSpace() => Container(height: 80);

  /// Builds a list of [Trip]s.
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    var list = snapshot.map((data) => _buildListItem(context, data)).toList();
    list.add(_getBottomSpace());
    return ListView(
      children: list,
    );
  }

  /// Builds [Trip] items, to display in the list.
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final _trip = Trip.fromSnapshot(data);
    return Padding(
      key: ValueKey(data.documentID),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: <Widget>[
                StreamBuilder(
                  stream: _tripService.getTripLocation(_trip),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        width: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.width * 0.33
                            : MediaQuery.of(context).size.width * 0.16,
                        height: 130,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return Container(
                        width: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.width * 0.33
                            : MediaQuery.of(context).size.width * 0.16,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8)),
                          image: DecorationImage(
                            image: AssetImage(snapshot.data['image']),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      );
                    }
                  },
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.width * 0.6
                          : MediaQuery.of(context).size.width * 0.8,
                      height: 40,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                        child: Text(
                          _trip.title,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.width * 0.6
                          : MediaQuery.of(context).size.width * 0.8,
                      height: 21,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 6),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(right: 4.0, bottom: 1.0),
                                child: Container(
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                ),
                              ),
                              StreamBuilder(
                                stream: _tripService.getTripLocation(_trip),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text(
                                      '...',
                                      style: TextStyle(color: Colors.grey),
                                    );
                                  } else {
                                    return Text(
                                      snapshot.data['name'],
                                      style: TextStyle(color: Colors.grey),
                                    );
                                  }
                                },
                              ),
                            ],
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.width * 0.6
                          : MediaQuery.of(context).size.width * 0.8,
                      height: 15,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(right: 4.0, bottom: 1.0),
                                child: Container(
                                  child: Icon(
                                    Icons.event,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                ),
                              ),
                              Text(
                                _trip.date,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.width * 0.6
                            : MediaQuery.of(context).size.width * 0.8,
                        height: 54,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: ButtonBar(
                            alignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                child: const Text('UPDATE'),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateTrip(trip: _trip)));
                                },
                              ),
                              FlatButton(
                                child: const Text('DELETE'),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onPressed: () => showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) =>
                                      TripDeleteDialog(trip: _trip),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ViewTrip(trip: _trip, tripService: _tripService))),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: Center(
              child: _buildBody(context),
            ),
          ),
        ],
      ),
    );
  }
}
