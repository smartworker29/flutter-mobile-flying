import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    Key key,
    this.message = "Loading Booking Details",
  }) : super(key: key);

  final String message;

  double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Color(0xFF113377),
        ),
        Positioned(
          top: screenHeight(context) / 2,
          left: screenWidth(context) / 2.2,
          child: CupertinoTheme(
            data: CupertinoTheme.of(context).copyWith(
                primaryColor: Colors.white, brightness: Brightness.dark),
            child: CupertinoActivityIndicator(
              radius: 20,
            ),
          ),
        ),
        Positioned(
          top: screenHeight(context) / 2.2,
          left: screenWidth(context) / 4.2,
          child: Material(
            color: Color(0xFF113377),
            child: new Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        )
      ],
    );
  }
}
