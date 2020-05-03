import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/model/Place.dart';
import 'package:tripmate/service/PlaceService.dart';

/// Implementation of the [PlaceList] widget.
/// Returns a [Scaffold] widget.
class PlaceList extends StatefulWidget {
  final String docId;
  final String location;

  const PlaceList({Key key, this.docId, this.location}) : super(key: key);

  @override
  _PlaceListState createState() => _PlaceListState();
}

/// State of the [PlaceList] widget.
class _PlaceListState extends State<PlaceList> {
  final snackBar = SnackBar(content: Text('Clicked!'));
  var _icon = Icons.favorite_border;
  var _color = Colors.black45;

  PlaceService _placeService;

  /// Updates a place.
  _updatePlace(Place place) async {
    await _placeService.updatePlaceDocument(
        place.reference.documentID, place.toJson());
  }

  @override
  Widget build(BuildContext context) {
    _placeService = PlaceService(widget.docId);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.location,
            style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontSize: 24.0,
                letterSpacing: 0.25),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          brightness: Brightness.light,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: _buildBody(context),
        ));
  }

  /// Fetches [Place]s from the Firebase instance and displays them as a list.
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _placeService.streamPlaceCollection(),
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

  /// Builds a list of [Place]s.
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  /// Builds [Place] items, to display in the list.
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final place = Place.fromSnapshot(data);

    if (place.favourite) {
      _icon = Icons.favorite;
      _color = Colors.red;
    } else {
      _icon = Icons.favorite_border;
      _color = Colors.black45;
    }

    return Container(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: <Widget>[
            Image.asset(
              place.image,
              fit: BoxFit.fill,
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                place.location,
                style: TextStyle(
                    fontSize: 12.0,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      place.name,
                      style: TextStyle(
                        fontSize: 24.0,
                        letterSpacing: 0.0,
                      ),
                    ),
                    IconButton(
                      icon: Icon(_icon, color: _color),
                      onPressed: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: place.favourite
                                ? Text('${place.name} removed from favourites')
                                : Text('${place.name} added to favourites')));

                        Place updPlace = Place.fromMap({
                          'name': place.name,
                          'image': place.image,
                          'location': place.location,
                          'description': place.description,
                          'favourite': !place.favourite,
                        }, reference: place.reference);

                        _updatePlace(updPlace);
                      },
                    )
                  ],
                )),
            Container(
              margin: EdgeInsets.only(left: 16.0, bottom: 24.0, right: 16.0),
              child: Text(
                place.description,
                style: TextStyle(
                    fontSize: 14.0, letterSpacing: 0.25, color: Colors.black45),
              ),
            )
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      ),
    );
  }
}
