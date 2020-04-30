import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/model/Trip.dart';
import 'package:tripmate/service/TripService.dart';

class ViewTrip extends StatelessWidget {
  final Trip trip;
  final TripService tripService;

  const ViewTrip({Key key, this.trip, this.tripService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TripMate',
          style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 24.0,
              letterSpacing: 2),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                StreamBuilder(
                  stream: tripService.getTripLocation(trip),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 238,
                            child: Card(
                              margin: EdgeInsets.all(0),
                              elevation: 24,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(snapshot.data['image']),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(
                                left: 20.0, top: 28.0, bottom: 5.0),
                            child: Text(
                              snapshot.data['name'],
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 18.0, bottom: 10.0),
                  child: Text(
                    trip.title,
                    style: TextStyle(
                      fontSize: 24.0,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Expected Budget   :   ',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Rs. ${trip.budget}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Date   :   ',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          trip.date,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 18.0, top: 28.0, bottom: 20.0, right: 18.0),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(bottom: 1.0),
                        child: Text(
                          'NOTES',
                          style: TextStyle(
                            fontSize: 14.0,
                            letterSpacing: 4,
                            color: Colors.grey[900],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Text(
                        trip.notes,
                        style: TextStyle(
                          fontSize: 14.0,
                          letterSpacing: 0.25,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
