import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String title;
  double budget;
  String notes;
  DateTime startDate;
  DateTime endDate;
  DocumentReference user;
  DocumentReference location;
  DocumentReference reference;

  Trip(
      {this.title,
      this.budget,
      this.notes,
      this.location,
      this.startDate,
      this.endDate,
      this.user});

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
        location = map['location'],
        assert(map['user'] != null),
        user = map['user'];

  Trip.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {
      'name': title,
      'budget': budget,
      'notes': notes,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'user': user
    };
  }
}
