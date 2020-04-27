import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String title;
  double budget;
  String notes;
  DateTime startDate;
  DateTime endDate;
  DocumentReference location;
  DocumentReference reference;

  Trip({this.title, this.budget});

  Trip.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        title = map['name'],
        assert(map['budget'] != null),
        budget = map['budget'],
        assert(map['notes'] != null),
        notes = map['notes'],
        assert(map['startDate'] != null),
        startDate = map['startDate'],
        assert(map['endDate'] != null),
        endDate = map['endDate'],
        assert(map['location'] != null),
        location = map['location'];

  Trip.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {
      'name': title,
      'budget': budget,
      'notes': notes,
      'startDate': startDate,
      'endDate': endDate
    };
  }
}
