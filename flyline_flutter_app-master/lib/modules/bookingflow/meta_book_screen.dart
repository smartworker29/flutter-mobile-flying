import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:motel/modules/menuitems/menu_item_app_bar.dart';
import 'package:motel/widgets/loading_screen.dart';

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
  int _stackToView = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _stackToView,
        children: [
          Column(
            children: <Widget>[
              MenuItemAppBar(title: 'Meta Fare'),
              Expanded(
                child: Container(
                  child: InAppWebView(
                    onLoadStart: (controller, str) =>
                        setState(() => _stackToView = 1),
                    onLoadStop: (controller, url) =>
                        setState(() => _stackToView = 0),
                    initialUrl: '$baseUrl${widget.url}',
                    initialOptions: InAppWebViewWidgetOptions(
                      inAppWebViewOptions: InAppWebViewOptions(
                        horizontalScrollBarEnabled: false,
                        verticalScrollBarEnabled: false,
                      ),
                    ),
                    onLoadError: (controller, asd, code, message) {
                      print(code);
                    },
                  ),
                ),
              ),
            ],
          ),
          LoadingScreen(
            message: "Loading Booking Details",
          ),
        ],
      ),
    );
  }
}
