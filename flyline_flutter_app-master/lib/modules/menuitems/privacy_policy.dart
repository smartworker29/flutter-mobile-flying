import 'package:flutter/material.dart';



class PrivacyPolicyPage extends StatefulWidget {
  PrivacyPolicyPage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFF7F9FC),
        leading: Center(
          child: Ink(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Color(0xff0e3178),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: new Text("Privacy Policy",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Gilroy',
              color: Color(0xff3a3f5c),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            )),
      ),
      body: new Container(
        color: Color(0xFFF7F9FC),
        child: new Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                )),
            child: Padding(
              padding: const EdgeInsets.only(left: 38, right: 37, top: 26),
              child: ListView(
                children: [
                  new Text(
                    "",

                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff707070),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ))
                ],
              ),
            )),
      ),
    );
  }
}
