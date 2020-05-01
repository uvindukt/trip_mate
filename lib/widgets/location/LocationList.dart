import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/model/Location.dart';
import 'package:tripmate/service/LocationService.dart';
import 'package:tripmate/widgets/place/PlaceList.dart';

/// Implementation of the [LocationList] widget.
/// Returns a [Scaffold] widget.
class LocationList extends StatefulWidget {
  @override
  _LocationListState createState() => _LocationListState();
}

/// State of the [LocationList] widget.
class _LocationListState extends State<LocationList> {
  static String collectionName = "locations";
  LocationService _locationService = LocationService(collectionName);

  /// Fetches [Location]s from the Firebase instance and displays them as a list.
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _locationService.getLocations(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return _buildList(context, snapshot.data.documents);
        }
        return CircularProgressIndicator();
      },
    );
  }

  /// Builds a list of [Location]s.
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  /// Builds [Location] items, to display in the list.
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final location = Location.fromSnapshot(data);
    return Container(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: InkWell(
          child: Container(
            height: MediaQuery.of(context).size.width * 2 / 4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(location.image),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[
                      Colors.black.withAlpha(0),
                      Colors.black38,
                      Colors.black45
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      location.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    Icon(
                      Icons.location_on,
                      color: Colors.white70,
                    )
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlaceList(
                          docId: data.documentID,
                          location: location.name,
                        )));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBody(context),
    );
  }
}
