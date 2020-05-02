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
                            size: 20,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Text(
                        "FlyLine Premium",
                        style: TextStyle(
                            fontFamily: "Gilroy",
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(14, 49, 120, 1),
                            fontSize: 20),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ],
                  ),
                  SubscriptionItem(
                    title: 'FlyLine Basic',
                    items: [
                      'FlyLine Meta Search',
                      'Direct Airline Booking',
                      'Co - Pilot Lite',
                      'Up to 3 Travelers on a Booking',
                    ],
                    onSignup: () {
                      print('do FlyBasic');
                    },
                    onLearnMore: () {
                      print('do learnMore Basic');
                    },
                  ),
                  SubscriptionItem(
                    title: 'FlyLine Premium',
                    items: [
                      'Cash Back Booking - 6% Max',
                      'FlyLine Meta Search',
                      'Direct Airline Booking',
                      'Co - Pilot Pro',
                    ],
                    onSignup: () {
                      print('do Premium');
                    },
                    onLearnMore: () {
                      print('do learnMore Premium');
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class CheckedLineItem extends StatelessWidget {
  final String content;

  const CheckedLineItem({Key key, this.content: ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 8),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/check.png',
            height: 20,
            width: 20,
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            '$content',
            style: TextStyle(
                fontFamily: "Gilroy",
                color: Color.fromRGBO(58, 63, 92, 1),
                fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class SubscriptionItem extends StatelessWidget {
  final String title;
  final List<String> items;
  final VoidCallback onSignup;
  final VoidCallback onLearnMore;
  const SubscriptionItem(
      {Key key, this.title, this.items, this.onSignup, this.onLearnMore})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.fromLTRB(20, 9, 20, 9),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(27, 19, 27, 11),
              alignment: Alignment.topLeft,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '$title',
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(14, 49, 120, 1),
                          fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  GestureDetector(
                    onTap: onLearnMore,
                    child: Text(
                      'Learn More',
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(0, 174, 239, 1),
                          fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: .5,
            ),
            SizedBox(
              height: 10,
            ),
            ...items.map(
              (e) => CheckedLineItem(
                content: e,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
              height: 45,
              width: 350,
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
              child: FlatButton(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontFamily: "Gilroy",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                ),
                onPressed: onSignup,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
