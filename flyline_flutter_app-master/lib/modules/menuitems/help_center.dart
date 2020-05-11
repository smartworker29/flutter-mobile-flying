import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HelpCenterScreen extends StatelessWidget {
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(247, 249, 252, 1),
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            shape: new CircleBorder(),
            child: InkWell(
              child: Image.asset(
                'assets/images/back-arrow.png',
                scale: 34,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: Text(
          "Help Center",
          style: TextStyle(
              fontFamily: "Gilroy",
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E3178),
              fontSize: 20),
        ),
        centerTitle: true,
        actions: <Widget>[
          Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(8.0),
          )
        ],
      ),
      body: InAppWebView(
        initialOptions: InAppWebViewWidgetOptions(
            inAppWebViewOptions: InAppWebViewOptions(
          horizontalScrollBarEnabled: false,
          verticalScrollBarEnabled: false,
        )),
        key: _key,
        initialUrl: 'https://intercom.help/flyline/en',
      ),
    );
  }
}
