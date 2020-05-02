import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Color.fromRGBO(58, 63, 92, 1),
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
      body: WebView(
        key: _key,
        initialUrl: 'https://intercom.help/flyline/en',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
