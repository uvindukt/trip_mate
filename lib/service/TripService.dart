import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripmate/model/Trip.dart';

class TripService {
  String collectionName;

  TripService(this.collectionName);

  // Get trips of an user.
  getTrips() {
    return Firestore.instance.collection(collectionName).snapshots();
  }

  // Add a new trip.
  addTrip(
      String title, String notes, num budget, String date, String location) {
    Trip trip = Trip(
        title: title,
        notes: notes,
        budget: budget,
        location: location,
        date: date);

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
  update(Trip trip, String newTitle) {
    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        await transaction.update(trip.reference, {'title': newTitle});
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
