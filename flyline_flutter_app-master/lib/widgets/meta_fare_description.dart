import 'package:flutter/material.dart';

class MetaFareDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Color(0xff8e969f),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: 'Meta fares, ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text:
                  'are flights we source from our suppliers. We will always display the cheapest flights when you search on FlyLine',
            ),
          ],
        ),
      ),
    );
  }
}
