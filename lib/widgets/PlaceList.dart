import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripmate/service/PlaceService.dart';
import 'package:tripmate/model/Place.dart';

class Places extends StatefulWidget {
  final String docId;
  final String location;

  const Places({Key key, this.docId, this.location}) : super(key: key);

  @override
  _PlacesState createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  final snackBar = SnackBar(content: Text('Clicked!'));
  var _icon = Icons.favorite_border;
  var _color = Colors.black45;
  var _clicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.location,
          style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 24.0,
              letterSpacing: 0.25),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),

      body: Center(
        child: buildBody(context),
      )
    );
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: PlaceService(widget.docId).getLocations(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print("Locations ${snapshot.data.documents.length}");
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
    final place = Place.fromSnapshot(data);
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
                  fontWeight: FontWeight.w500
                ),
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
                      if (!_clicked) {
                        Scaffold.of(context).showSnackBar(snackBar);
                        setState(() {
                          _icon = Icons.favorite;
                          _color = Colors.red;
                          _clicked = true;
                        });
                      } else {
                        setState(() {
                          _icon = Icons.favorite_border;
                          _color = Colors.black45;
                          _clicked = false;
                        });
                      }
                    },
                  )
                ],
              )
            ),
            Container(
              margin: EdgeInsets.only(left: 16.0, bottom: 24.0, right: 16.0),
              child: Text(
                place.description,
                style: TextStyle(
                  fontSize: 14.0,
                  letterSpacing: 0.25,
                  color: Colors.black45
                ),
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
