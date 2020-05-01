import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/model/Trip.dart';
import 'package:tripmate/service/TripService.dart';

/// Implementation of the [TripDeleteDialog] widget.
/// Takes a [Trip] object as a parameter.
/// Returns a [AlertDialog] widget, with some wrappers around it.
class TripDeleteDialog extends StatefulWidget {
  final Trip trip;

  const TripDeleteDialog({Key key, this.trip}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TripDeleteDialogState();
}

/// State of the [TripDeleteDialog] widget.
class _TripDeleteDialogState extends State<TripDeleteDialog>
    with SingleTickerProviderStateMixin {
  TripService _tripService = TripService();

  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.decelerate);

    _animationController.addListener(() => setState(() {}));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: _animation,
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
                    Flushbar(
                      titleText: Text(
                        'Deleted',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 0.5,
                        ),
                      ),
                      messageText: Text(
                        'Trip deleted successfully',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          letterSpacing: 0.2,
                        ),
                      ),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.green,
                      ),
                      duration: Duration(seconds: 3),
                      flushbarStyle: FlushbarStyle.FLOATING,
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                    ).show(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
