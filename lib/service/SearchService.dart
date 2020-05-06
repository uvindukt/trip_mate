import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/model/Location.dart';
import 'package:tripmate/service/LocationService.dart';
import 'package:tripmate/widgets/place/PlaceList.dart';
import 'package:tripmate/widgets/app/LoadingScreen.dart';

/// Implementation of the [SearchService].
class SearchService extends SearchDelegate<String> {
  static String collectionName = "locations";
  LocationService _locationService = LocationService(collectionName);

  ///Create search bar action buttons
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
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
        onPressed: () {
          showResults(context);
        },
      ),
    ];
  }

  ///Create search bar back button
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

  ///Returns search results
  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Container(
          child: Text(
            'Search field is empty!',
            style: TextStyle(color: Colors.black45, fontSize: 20.0),
          ),
        ),
      );
    }
    return StreamBuilder<QuerySnapshot>(
      stream: _locationService.getLocation(query),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        } else if (snapshot.hasData) {
          if (snapshot.data.documents.isEmpty) {
            return Center(
              child: Text(
                'Location is not available',
                style: TextStyle(color: Colors.black45, fontSize: 20.0),
              ),
            );
          }

          List<DocumentSnapshot> snapshots = snapshot.data.documents;
          List<Location> locations =
              snapshots.map((data) => Location.fromSnapshot(data)).toList();

          return ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    child: InkWell(
                      child: Container(
                        height: MediaQuery.of(context).size.width * 2 / 4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(locations[index].image),
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
                                  locations[index].name,
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
                        String location = locations[index].name;
                        String docId = locations[index].reference.documentID;

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PlaceList(docId: docId, location: location);
                        }));
                      },
                    ),
                  ),
                );
              });
        } else {
          return LoadingScreen();
        }
      },
    );
  }

  ///Returns suggestions to show in search
  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _locationService.getLocations(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          List<DocumentSnapshot> snapshots = snapshot.data.documents;
          List<Location> locations =
              snapshots.map((data) => Location.fromSnapshot(data)).toList();

          locations = query.isEmpty ? locations : _locationMatch(locations);
          return ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(locations[index].name),
                  onTap: () {
                    query = locations[index].name;
                    showResults(context);
                  },
                );
              });
        }
        return CircularProgressIndicator();
      },
    );
  }

  ///Returns a location list which has a match to the search query
  List<Location> _locationMatch(List<Location> locations) {
    List<Location> temp = List();

    for (int i = 0; i < locations.length; i++) {
      if (locations[i].name.toLowerCase().startsWith(query)) {
        temp.add(locations[i]);
      }
    }
    return temp;
  }
}
