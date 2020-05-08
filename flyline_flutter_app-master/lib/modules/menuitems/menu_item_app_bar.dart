import 'package:flutter/material.dart';
import 'package:motel/widgets/app_bar_pop_icon.dart';

class MenuItemAppBar extends StatelessWidget {
  const MenuItemAppBar({
    Key key,
    @required this.title,
    this.backgroundColor = Colors.white,
    this.buttonColor,
  }) : super(key: key);

  final String title;
  final Color backgroundColor;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AppBarPopIcon(
              buttonColor: buttonColor,
            ),
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color.fromRGBO(14, 49, 120, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 40,
              width: 40,
            )
          ],
        ),
      ),
    );
  }
}
