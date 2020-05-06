import 'package:flutter/material.dart';

class CategoryInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 68,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Click',
              style: TextStyle(
                color: Color.fromRGBO(177, 177, 177, 1),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
            TextSpan(
              text: ' HERE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 174, 239, 1),
                fontSize: 10,
              ),
            ),
            TextSpan(
              text:
                  ' to learn the difference between a FlyLine Fare, FlyLine Exclusive and Meta Fare',
              style: TextStyle(
                color: Color.fromRGBO(177, 177, 177, 1),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
