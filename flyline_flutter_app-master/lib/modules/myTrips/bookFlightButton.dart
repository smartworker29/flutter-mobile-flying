import 'package:flutter/material.dart';

import '../../appTheme.dart';

class BookFlightButton extends StatelessWidget {
  const BookFlightButton({
    Key key,
  }) : super(key: key);

  void onTap() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: InkWell(
        onTap: onTap,
        child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppTheme.getTheme().dividerColor.withAlpha(100),
                  offset: Offset(1, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Center(
                child: Text(
              'Book a Flight',
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(color: Colors.white),
            ))),
      ),
    );
  }
}
