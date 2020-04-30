import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripmate/model/Trip.dart';

class TripService {
  String collectionName = "trips";

  // Get trips of an user.
  getTrips() {
    return Firestore.instance.collection(collectionName).snapshots();
  }

  // Get the location of a trip.
  getTripLocation(Trip trip) {
    return Firestore.instance
        .collection("locations")
        .document(trip.location)
        .snapshots();
  }

  // Add a new trip.
  add(String title, String notes, num budget, String date, String location) {
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
  update(Trip trip, String title, num budget, String notes, String location,
      String date) {
    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        await transaction.update(trip.reference, {
          'title': title,
          'budget': budget,
          'notes': notes,
          'location': location,
          'date': date
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
