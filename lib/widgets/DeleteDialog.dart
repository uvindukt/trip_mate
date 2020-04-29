import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/model/Trip.dart';
import 'package:tripmate/service/TripService.dart';

class DeleteDialog extends StatefulWidget {
  final Trip trip;

  DeleteDialog(this.trip);

  @override
  State<StatefulWidget> createState() => DeleteDialogState();
}

class DeleteDialogState extends State<DeleteDialog>
    with SingleTickerProviderStateMixin {
  static String tripCollection = "trips";
  TripService _tripService = TripService(tripCollection);

  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
            scale: animation,
            child: AlertDialog(
              title: Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 24,
              content: Text('Do you want to delete ${widget.trip.title}?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('NO'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                    child: Text('YES'),
                    onPressed: () {
                      _tripService.delete(widget.trip);
                      Navigator.of(context).pop();
                    }),
              ],
            )),
      ),
    );
  }
}
