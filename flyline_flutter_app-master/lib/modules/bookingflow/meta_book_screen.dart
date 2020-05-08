import 'package:flutter/material.dart';
import 'package:motel/modules/menuitems/menu_item_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MetaBookScreen extends StatefulWidget {
  final String url;
  final Map<String, dynamic> retailInfo;

  const MetaBookScreen({
    Key key,
    this.url,
    this.retailInfo,
  }) : super(key: key);

  @override
  _MetaBookScreenState createState() => _MetaBookScreenState();
}

class _MetaBookScreenState extends State<MetaBookScreen> {
  String get baseUrl => 'https://staging.joinflyline.com';

  @override
  Widget build(BuildContext context) {
    print(widget.url);
    return Scaffold(
      body: Column(
        children: <Widget>[
          MenuItemAppBar(title: 'Meta Fare'),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                ),
              ),
              padding: const EdgeInsets.only(left: 38, right: 37, top: 26),
              child: WebView(
                initialUrl: '$baseUrl${widget.url}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
