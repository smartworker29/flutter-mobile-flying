


import 'package:flutter/material.dart';

class MembershipPlansScreen extends StatefulWidget {
  MembershipPlansScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MembershipPlansScreenState createState() => _MembershipPlansScreenState();
}

class _MembershipPlansScreenState extends State<MembershipPlansScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 249, 252, 1),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: InkWell(
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 25,
                          ),
                          onTap: (){
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Text(
                        "Subscriptions",
                        style: TextStyle(
                            fontFamily: "AvenirNext",
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(14, 49, 120, 1),
                            fontSize: 18),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Image.asset(
                          'assets/images/question.jpg',
                          height: 16,
                          width: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[200],
                                  offset: Offset(0, 0), //(x,y)
                                  blurRadius: 10.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(30, 24, 30, 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Meta Search",
                                        style: TextStyle(
                                            fontFamily: "AvenirNext",
                                            fontWeight: FontWeight.w800,
                                            color:
                                                Color.fromRGBO(14, 49, 120, 1),
                                            fontSize: 18),
                                      ),
                                      Text(
                                        "Free",
                                        style: TextStyle(
                                            fontFamily: "AvenirNext",
                                            fontWeight: FontWeight.w800,
                                            color:
                                                Color.fromRGBO(14, 49, 120, 1),
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color.fromRGBO(231, 233, 240, 1),
                                  height: 1,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(30, 24, 20, 20),
                                  child: Text(
                                    "Our meta search feature is free, and it always will be, have confidence knowing you are always getting the best price on the net",
                                    style: TextStyle(
                                        fontFamily: "AvenirNext",
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromRGBO(142, 150, 159, 1),
                                        fontSize: 13),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[200],
                                  offset: Offset(0, 0), //(x,y)
                                  blurRadius: 10.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(30, 24, 30, 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "FlyLine Basic",
                                        style: TextStyle(
                                            fontFamily: "AvenirNext",
                                            fontWeight: FontWeight.w800,
                                            color:
                                                Color.fromRGBO(14, 49, 120, 1),
                                            fontSize: 18),
                                      ),
                                      Text(
                                        "\$49.99/yr",
                                        style: TextStyle(
                                            fontFamily: "AvenirNext",
                                            fontWeight: FontWeight.w800,
                                            color:
                                                Color.fromRGBO(14, 49, 120, 1),
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color.fromRGBO(231, 233, 240, 1),
                                  height: 1,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(30, 24, 20, 20),
                                  child: Text(
                                    "Get a taste of the perks and savings FlyLine has to offer with FlyLine Basic",
                                    style: TextStyle(
                                        fontFamily: "AvenirNext",
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromRGBO(142, 150, 159, 1),
                                        fontSize: 13),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(30, 24, 80, 20),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "- Meta Fares",
                                            style: TextStyle(
                                                fontFamily: "AvenirNext",
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromRGBO(
                                                    14, 49, 120, 1),
                                                fontSize: 13),
                                          ),
                                          Text(
                                            "- Max of 6 bookings",
                                            style: TextStyle(
                                                fontFamily: "AvenirNext",
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromRGBO(
                                                    14, 49, 120, 1),
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "- FlyLine Fares",
                                            style: TextStyle(
                                                fontFamily: "AvenirNext",
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromRGBO(
                                                    14, 49, 120, 1),
                                                fontSize: 13),
                                          ),
                                          Text(
                                            "- Deal Alerts",
                                            style: TextStyle(
                                                fontFamily: "AvenirNext",
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromRGBO(
                                                    14, 49, 120, 1),
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(80, 12, 80, 12),
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Color.fromRGBO(0, 174, 239, 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[200],
                                        offset: Offset(0, 0), //(x,y)
                                        blurRadius: 10.0,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "Start 14 Day Free Trial",
                                    style: TextStyle(
                                        fontFamily: "AvenirNext",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 13),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[200],
                                  offset: Offset(0, 0), //(x,y)
                                  blurRadius: 10.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(30, 24, 30, 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "FlyLine Premium",
                                        style: TextStyle(
                                            fontFamily: "AvenirNext",
                                            fontWeight: FontWeight.w800,
                                            color:
                                                Color.fromRGBO(14, 49, 120, 1),
                                            fontSize: 18),
                                      ),
                                      Text(
                                        "\$79.99/yr",
                                        style: TextStyle(
                                            fontFamily: "AvenirNext",
                                            fontWeight: FontWeight.w800,
                                            color:
                                                Color.fromRGBO(14, 49, 120, 1),
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color.fromRGBO(231, 233, 240, 1),
                                  height: 1,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(30, 24, 20, 20),
                                  child: Text(
                                    "Get the most out of FlyLine with FlyLine Premium. Save time and money.",
                                    style: TextStyle(
                                        fontFamily: "AvenirNext",
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromRGBO(142, 150, 159, 1),
                                        fontSize: 13),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(30, 24, 80, 20),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "- Meta Fares",
                                            style: TextStyle(
                                                fontFamily: "AvenirNext",
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromRGBO(
                                                    14, 49, 120, 1),
                                                fontSize: 13),
                                          ),
                                          Text(
                                            "- Unlimited bookings",
                                            style: TextStyle(
                                                fontFamily: "AvenirNext",
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromRGBO(
                                                    14, 49, 120, 1),
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "- FlyLine Fares",
                                            style: TextStyle(
                                                fontFamily: "AvenirNext",
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromRGBO(
                                                    14, 49, 120, 1),
                                                fontSize: 13),
                                          ),
                                          Text(
                                            "- Additional User",
                                            style: TextStyle(
                                                fontFamily: "AvenirNext",
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromRGBO(
                                                    14, 49, 120, 1),
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(80, 10, 80, 12),
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Color.fromRGBO(0, 174, 239, 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[200],
                                        offset: Offset(0, 0), //(x,y)
                                        blurRadius: 10.0,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "Start 14 Day Free Trial",
                                    style: TextStyle(
                                        fontFamily: "AvenirNext",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 13),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
