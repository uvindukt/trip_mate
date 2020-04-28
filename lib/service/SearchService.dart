import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripmate/service/LocationService.dart';
import 'package:tripmate/model/Location.dart';

class SearchService extends SearchDelegate<String> {
  Location _location;

  @override
  List<Widget> buildActions(BuildContext context) {
    return[
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.black45,
        ),
        onPressed: () {
          query = "";
        },
      ),
      IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.black45,
        ),
        onPressed: () {},
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black45,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 2 / 4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_location.image),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Container(
            alignment: Alignment.bottomCenter,
            child:Container(
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
                    _location.name,
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
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    String collectionName = "locations";
    LocationService _locationService = LocationService(collectionName);

    return StreamBuilder<QuerySnapshot>(
      stream: _locationService.getLocations(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          List<DocumentSnapshot> snapshots = snapshot.data.documents;
          List<Location> locations = snapshots
              .map((data) => Location.fromSnapshot(data)).toList();
          locations = query.isEmpty ? locations : _locationMach(locations);
          return ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(locations[index].name),
                  onTap: () {
                    _location = Location(
                        name: locations[index].name,
                        image: locations[index].image
                    );
                    query = locations[index].name;
                    showResults(context);
                  },
                );
              }
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  List<Location> _locationMach(List<Location> locations) {
    List<Location> temp = List();

    for (int i = 0; i < locations.length; i++) {
      if (locations[i].name.toLowerCase().startsWith(query)) {
        temp.add(locations[i]);
      }
    }

    return temp;
  }
}