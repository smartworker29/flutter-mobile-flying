import 'package:flutter/material.dart';

class AppBarFromTo extends StatelessWidget {
  const AppBarFromTo({
    @required this.flyFrom,
    this.flyTo,
  });

  final String flyFrom;
  final String flyTo;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: flyFrom,
            style: TextStyle(
              fontFamily: 'Gilroy',
              color: Color(0xff0e3178),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
          if (flyTo != null)
            TextSpan(
              text: ' - $flyTo',
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xff0e3178),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            ),
        ],
      ),
    );
  }
}
