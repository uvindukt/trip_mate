import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/service/LocationService.dart';
import 'package:tripmate/service/TripService.dart';

class NewTrip extends StatefulWidget {
  @override
  NewTripState createState() => NewTripState();
}

class NewTripState extends State<NewTrip> {
  static String locationCollection = "locations";
  static String tripCollection = "trips";

  LocationService _locationService = LocationService(locationCollection);
  TripService _tripService = TripService(tripCollection);

  final _formKey = GlobalKey<FormState>();
  String _location;
  DateTime _selectedDate;
  String _title;
  num _budget;
  String _notes;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Trip',
          style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 24.0,
              letterSpacing: 0.25),
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
        builder: (context) => Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: Container(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.width * 0.5
                            : MediaQuery.of(context).size.width * 0,
                        child: FittedBox(
                          child: Image.asset('assets/images/trip_plan.gif'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Enter a name for the new trip.',
                          labelText: 'Title',
                          prefixIcon: Icon(Icons.title),
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(5.0))),
                        ),
                        maxLength: 20,
                        onChanged: (value) {
                          setState(() {
                            _title = value;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a title.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Expected budget for the new trip.',
                          labelText: 'Budget',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(5.0))),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _budget = double.parse(value);
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a budget.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _locationService.getLocations(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error ${snapshot.error}');
                          }
                          if (snapshot.hasData) {
                            print(
                                "Locations ${snapshot.data.documents.length}");
                            return Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 4.0),
                                    child: Container(
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Container(
                                      child: Text(
                                        'Location',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).orientation ==
                                            Orientation.portrait
                                        ? MediaQuery.of(context).size.width *
                                            0.6
                                        : MediaQuery.of(context).size.width *
                                            0.8,
                                    child: DropdownButton<String>(
                                      hint: Text('Select a location'),
                                      isExpanded: true,
                                      value: _location,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black),
                                      underline: Container(
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _location = newValue;
                                        });
                                      },
                                      items: snapshot.data.documents
                                          .map<DropdownMenuItem<String>>(
                                              (DocumentSnapshot document) {
                                        return DropdownMenuItem<String>(
                                          value: document.documentID,
                                          child: Text(document.data['name']),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 8, 0, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: Container(
                              child: Icon(
                                Icons.event,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 54.0),
                            child: Container(
                              child: Text(
                                'Date',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? MediaQuery.of(context).size.width * 0.6
                                : MediaQuery.of(context).size.width * 0.8,
                            child: OutlineButton(
                              onPressed: () => _selectDate(context),
                              child: _selectedDate == null
                                  ? Text('Select a date')
                                  : Text('${_selectedDate.toLocal()}'
                                      .split(' ')[0]),
                              color: Colors.blue,
                              textColor: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        minLines: 3,
                        keyboardType: TextInputType.multiline,
                        maxLength: 100,
                        maxLines: null,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Details of the trip.',
                          labelText: 'Notes',
                          prefixIcon: Icon(Icons.note),
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(5.0))),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _notes = value;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please add a note.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: RaisedButton(
                            color: Colors.green,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () {
                              // Validate returns true if the form is valid, or false
                              // otherwise.
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, display a Snack bar.

                                if (_location != null &&
                                    _selectedDate != null) {
                                  _tripService.addTrip(
                                      _title,
                                      _notes,
                                      _budget,
                                      _selectedDate.toString().split(' ')[0],
                                      _location);

                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text('Trip Saved')));

                                  Navigator.of(context).pop();
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: _location == null
                                          ? Text('Please select a location')
                                          : Text('Please select a date')));
                                }
                              }
                            },
                            child: Container(
                              width: 70,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 4),
                                    child: Container(
                                      child: Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'SAVE',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
