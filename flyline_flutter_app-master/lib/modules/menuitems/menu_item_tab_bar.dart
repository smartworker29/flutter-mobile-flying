import 'package:flutter/material.dart';

class MenuItemTabBar extends StatelessWidget {
  const MenuItemTabBar({
    Key key,
    @required this.tabs,
  }) : super(key: key);

  final List<String> tabs;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: TabBar(
        indicatorColor: Colors.transparent,
        labelColor: Color(0xFF0E3178),
        unselectedLabelColor: Color(0xFF0E3178).withOpacity(.5),
        labelStyle: TextStyle(
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.bold,
          fontSize: 14,
          height: 2,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.bold,
          fontSize: 14,
          height: 2,
        ),
        labelPadding: EdgeInsets.zero,
        tabs: [
          ...tabs.map(
            (t) => (tabs.length - 1) != tabs.indexOf(t)
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color.fromRGBO(231, 233, 240, 1),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: Tab(
                      child: Text(t),
                    ),
                  )
                : Tab(
                    child: Text(t),
                  ),
          ),
        ],
      ),
    );
  }
}
