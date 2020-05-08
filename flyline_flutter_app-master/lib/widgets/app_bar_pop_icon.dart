import 'package:flutter/material.dart';

class AppBarPopIcon extends StatelessWidget {
  final Color buttonColor;

  const AppBarPopIcon({
    Key key,
    this.buttonColor = const Color(0xfff7f9fc),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        height: AppBar().preferredSize.height + 10,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: buttonColor,
              ),
              child: Center(
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
