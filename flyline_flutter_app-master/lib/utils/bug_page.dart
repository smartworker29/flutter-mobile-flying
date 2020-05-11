import 'package:flutter/material.dart';
import 'package:motel/modules/menuitems/menu_item_app_bar.dart';

class BugPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          MenuItemAppBar(
            title: '',
            backgroundColor: Colors.transparent,
            buttonColor: Colors.white,
          ),
          Container(
            height: MediaQuery.of(context).size.height * .05,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/bug_page.png",
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .025,
                ),
                Text(
                  "Oops, there's a bug",
                  style: TextStyle(
                    fontSize: 26,
                    color: Color.fromRGBO(14, 49, 120, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .025,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'There seems to have been an issue. Please try again, if the issue continues send us and email ',
                        style: TextStyle(
                          color: Color.fromRGBO(142, 150, 159, 1),
                        ),
                      ),
                      TextSpan(
                        text: 'support@joinflyline.com',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 174, 239, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
