import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
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

  LocationService _locationService = LocationService(locationCollection);
  TripService _tripService = TripService();

  final _formKey = GlobalKey<FormState>();
  String _location;
  DateTime _date;
  String _title;
  num _budget;
  String _notes;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (pickedDate != null && pickedDate != _date)
      setState(() => _date = pickedDate);
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
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 25, 20, 10),
                  child: Container(
                    child: Form(
                      key: _formKey,
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
                                child:
                                    Image.asset('assets/images/new_trip.gif'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              expands: false,
                              autofocus: false,
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
                              onChanged: (value) =>
                                  setState(() => _title = value),
                              validator: (value) =>
                                  value.isEmpty ? 'Please enter a title' : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              expands: false,
                              autofocus: false,
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
                              onChanged: (value) => setState(() => _budget =
                                  value == "" ? null : double.parse(value)),
                              validator: (value) => value.isEmpty
                                  ? 'Please enter a budget'
                                  : null,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                  color: Colors.grey,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .orientation ==
                                                  Orientation.portrait
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                          child: DropdownButton<String>(
                                            hint: Text('Select a location'),
                                            isExpanded: true,
                                            value: _location,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 24,
                                            elevation: 16,
                                            style:
                                                TextStyle(color: Colors.black),
                                            underline: Container(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                _location = newValue;
                                              });
                                            },
                                            items: snapshot.data.documents.map<
                                                    DropdownMenuItem<String>>(
                                                (DocumentSnapshot document) {
                                              return DropdownMenuItem<String>(
                                                value: document.documentID,
                                                child:
                                                    Text(document.data['name']),
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
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18),
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
                                    child: _date == null
                                        ? Text('Select a date')
                                        : Text(
                                            '${_date.toLocal()}'.split(' ')[0]),
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
                              autofocus: false,
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
                              onChanged: (value) =>
                                  setState(() => _notes = value),
                              validator: (value) =>
                                  value.isEmpty ? 'Please add a note' : null,
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
                                    if (_formKey.currentState.validate()) {
                                      if (_location != null && _date != null) {
                                        _tripService.add(
                                            _title,
                                            _notes,
                                            _budget,
                                            _date.toString().split(' ')[0],
                                            _location);
                                        Navigator.of(context).pop();
                                        Flushbar(
                                          titleText: Text(
                                            'Saved',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          messageText: Text(
                                            'Trip added successfully',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          ),
                                          duration: Duration(seconds: 3),
                                          flushbarStyle: FlushbarStyle.FLOATING,
                                          margin: EdgeInsets.all(8),
                                          borderRadius: 8,
                                        ).show(context);
                                      } else {
                                        Flushbar(
                                          titleText: Text(
                                            'Error',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          messageText: Text(
                                            _location == null
                                                ? 'Please select a location'
                                                : 'Please select a date',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                          duration: Duration(seconds: 3),
                                          flushbarStyle: FlushbarStyle.FLOATING,
                                          margin: EdgeInsets.all(8),
                                          borderRadius: 8,
                                        ).show(context);
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
                                              color: Colors.white,
                                              fontSize: 15),
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
              )),
    );
  }
}
