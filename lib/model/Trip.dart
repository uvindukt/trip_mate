import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String title;
  num budget;
  String notes;
  String date;
  String location;
  DocumentReference reference;

  Trip({this.title, this.budget, this.notes, this.location, this.date});

  Trip.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        title = map['title'],
        assert(map['budget'] != null),
        budget = map['budget'],
        assert(map['notes'] != null),
        notes = map['notes'],
        assert(map['date'] != null),
        date = map['date'],
        assert(map['location'] != null),
        location = map['location'];

  Trip.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {
      'title': title,
      'budget': budget,
      'notes': notes,
      'date': date,
      'location': location
    };
  }
}
