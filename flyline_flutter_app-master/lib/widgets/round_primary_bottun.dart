import 'package:flutter/material.dart';

class RoundPrimaryButton extends StatelessWidget {
  final String text;

  RoundPrimaryButton({@required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(27)),
        child: FlatButton(
          color: Color(0xFF00AEEF),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          onPressed: () {
            
          },
        ),
      ),
    );
  }
}
