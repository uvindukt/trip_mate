import 'package:cloud_firestore/cloud_firestore.dart';

/// [Trip] data model.
class Trip {
  String title;
  num budget;
  String notes;
  String date;
  String location;
  String userId;
  DocumentReference reference;

  Trip(
      {this.title,
      this.budget,
      this.notes,
      this.location,
      this.date,
      this.userId});

  /// Mapping to [Trip] model from a [Map].
  Trip.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        title = map['title'],
        assert(map['budget'] != null),
        budget = map['budget'],
        assert(map['notes'] != null),
        notes = map['notes'],
        assert(map['date'] != null),
        date = map['date'],
        assert(map['userId'] != null),
        userId = map['userId'],
        assert(map['location'] != null),
        location = map['location'];

  /// Mapping to [Trip] model from a [DocumentSnapshot]
  Trip.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  /// Mapping the [Trip] model to a JSON
  toJson() {
    return {
      'title': title,
      'budget': budget,
      'notes': notes,
      'date': date,
      'location': location,
      'userId': userId
    };
  }
}
