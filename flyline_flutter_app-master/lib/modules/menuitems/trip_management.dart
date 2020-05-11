import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:motel/modules/menuitems/menu_item_app_bar.dart';
import 'package:motel/modules/menuitems/menu_item_tab_bar.dart';
import 'package:motel/widgets/round_primary_bottun.dart';
import 'package:motel/widgets/round_textfield.dart';

class TripScreen extends StatefulWidget {
  @override
  _TripScreen createState() => _TripScreen();
}

class _TripScreen extends State<TripScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFF7F9FC),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MenuItemAppBar(title: 'Trip Management'),
              MenuItemTabBar(tabs: ["Upcoming", "Completed"]),
              Container(
                height: 300,
              )
            ],
          ),
        ),
      ),
    );
  }
}
