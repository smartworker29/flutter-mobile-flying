import 'package:flutter/material.dart';
import 'package:motel/network/blocs.dart';

class AppBarFromTo extends StatelessWidget {
  const AppBarFromTo({
    this.flyTo = false,
  });

  final bool flyTo;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: flyLinebloc.flightsExclusiveItems.value.first.flyFrom,
            style: TextStyle(
              fontFamily: 'Gilroy',
              color: Color(0xff0e3178),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
          if (flyTo)
            TextSpan(
              text: ' - ${flyLinebloc.flightsExclusiveItems.value.first.flyTo}',
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
