import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripmate/model/Trip.dart';

/// Implementation of the [TripService].
class TripService {
  String collectionName = "trips";

  // Get trips of the current user.
  Stream<QuerySnapshot> getTrips() async* {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    yield* Firestore.instance
        .collection(collectionName)
        .where('userId', isEqualTo: user.uid)
        .snapshots();
  }

  getUser() async {}

  // Get the location of a trip.
  getTripLocation(Trip trip) {
    return Firestore.instance
        .collection("locations")
        .document(trip.location)
        .snapshots();
  }

  // Add a new trip.
  add(String title, String notes, num budget, String date,
      String location) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Trip trip = Trip(
        title: title,
        notes: notes,
        budget: budget,
        location: location,
        date: date,
        userId: user.uid);

    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        await Firestore.instance
            .collection(collectionName)
            .document()
            .setData(trip.toJson());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Change an existing trip.
  update(Trip trip, String title, num budget, String notes, String location,
      String date) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        await transaction.update(trip.reference, {
          'title': title,
          'budget': budget,
          'notes': notes,
          'location': location,
          'date': date,
          'userId': user.uid
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Delete an existing trip.
  delete(Trip trip) {
    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        await transaction.delete(trip.reference);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
