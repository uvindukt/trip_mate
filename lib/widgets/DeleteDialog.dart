import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/model/Trip.dart';
import 'package:tripmate/service/TripService.dart';

class DeleteDialog extends StatefulWidget {
  final Trip trip;

  const DeleteDialog({Key key, this.trip}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DeleteDialogState();
}

class DeleteDialogState extends State<DeleteDialog>
    with SingleTickerProviderStateMixin {
  TripService _tripService = TripService();

  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.decelerate);

    animationController.addListener(() => setState(() {}));

    animationController.forward();
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 24,
            content: Text('Do you want to delete ${widget.trip.title}?'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text('YES'),
                  onPressed: () async {
                    await _tripService.delete(widget.trip);
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
