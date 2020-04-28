
import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget {
  PremiumPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PremiumPageState createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Color(0xFF0E3178),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: _topTitle(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 36),
              child: _logo(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 36),
              child: _bodyTitle(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: _bodySubTitle(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 36, left: 24, right: 24),
              child: _checkList(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 36, right: 36),
              child: _button1(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 36, right: 36),
              child: _buildSeperate(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 36, right: 36),
              child: _button2(),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _topTitle() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 36.0, left: 36.0),
            child: Text(
              'Continue with FlyLine Basic',
              style: TextStyle(fontSize: 14.0, color: Colors.white,fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logo() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(child:Container(
            padding: EdgeInsets.only(right: 36.0, left: 36.0),
            child: Image.asset('assets/images/ic_logo.png',fit: BoxFit.fitWidth,),),
          ),
        ],
      ),
    );
  }

  Widget _bodyTitle() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 36.0, left: 36.0),
            child: Text(
              'FlyLine Premium',
              style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodySubTitle() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Flexible(
            flex: 2, // to wrap text widget
            child: Container(
              padding: EdgeInsets.only(right: 36.0, left: 36.0),
              child: Text(
                'Get the most savings on FlyLine when you upgrade to Premiun',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkList() {
    List<String> titles = [
      'Exclusive FlyLine Fores',
      '3% - 10% Cash Back',
      'Premium Co-Pilot',
    ];

    return Container(
      child: IntrinsicWidth(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              height: 32.0,
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/check.png',
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                  ),
                  Text(
                    'Exclusive FlyLine Fores',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              height: 32.0,
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/check.png',
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                  ),
                  Text(
                    '3% - 10% Cash Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              height: 32.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/check.png',
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                  ),
                  Text(
                    'Premium Co-Pilot',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                  ),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeperate() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(child:Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 1.0,
              width: 60.0,
              color: Colors.white70,
            ),
          )),
          Text(
            'Or pay annually and save',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(child:Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 1.0,
              width: 60.0,
              color: Colors.white70,
            ),
          ),),
        ],
      ),
    );
  }

  Widget _button1() {
    return Container(
      height: 50,
      child: SizedBox.expand(
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(44.0)),
          elevation: 4.0,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: MaterialButton(
            height: 44.0,
            color: Colors.white,
            child: Text('\$11.99 per month',
                style: TextStyle(fontSize: 16.0, color: Color(0xFF0E3178),fontWeight: FontWeight.w600)),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget _button2() {
    return Container(
      height: 50,
      child: SizedBox.expand(
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(44.0)),
          elevation: 4.0,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: MaterialButton(
            height: 44.0,
            color: Colors.white,
            child: Text('\$59.99 | 12 Months',
                style: TextStyle(fontSize: 16.0, color: Color(0xFF0E3178),fontWeight: FontWeight.w600)),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}









// import 'package:flutter/material.dart';

// class MembershipPlansScreen extends StatefulWidget {
//   MembershipPlansScreen({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _MembershipPlansScreenState createState() => _MembershipPlansScreenState();
// }

// class _MembershipPlansScreenState extends State<MembershipPlansScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Color.fromRGBO(247, 249, 252, 1),
//         body: SingleChildScrollView(
//           child: SafeArea(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         padding: EdgeInsets.all(12),
//                         margin: EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                             color: Color.fromRGBO(255, 255, 255, 1),
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(50))),
//                         child: InkWell(
//                           child: Icon(
//                             Icons.arrow_back_ios,
//                             size: 25,
//                           ),
//                           onTap: (){
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                       Text(
//                         "Subscriptions",
//                         style: TextStyle(
//                             fontFamily: "AvenirNext",
//                             fontWeight: FontWeight.bold,
//                             color: Color.fromRGBO(14, 49, 120, 1),
//                             fontSize: 18),
//                       ),
//                       Container(
//                         padding: EdgeInsets.all(12),
//                         margin: EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Color.fromRGBO(255, 255, 255, 1),
//                           borderRadius: BorderRadius.all(Radius.circular(50)),
//                         ),
//                         child: Image.asset(
//                           'assets/images/question.jpg',
//                           height: 16,
//                           width: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: <Widget>[
//                           Container(
//                             margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15.0),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey[200],
//                                   offset: Offset(0, 0), //(x,y)
//                                   blurRadius: 10.0,
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               children: <Widget>[
//                                 Container(
//                                   padding: EdgeInsets.fromLTRB(30, 24, 30, 12),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[
//                                       Text(
//                                         "Meta Search",
//                                         style: TextStyle(
//                                             fontFamily: "AvenirNext",
//                                             fontWeight: FontWeight.w800,
//                                             color:
//                                                 Color.fromRGBO(14, 49, 120, 1),
//                                             fontSize: 18),
//                                       ),
//                                       Text(
//                                         "Free",
//                                         style: TextStyle(
//                                             fontFamily: "AvenirNext",
//                                             fontWeight: FontWeight.w800,
//                                             color:
//                                                 Color.fromRGBO(14, 49, 120, 1),
//                                             fontSize: 18),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   color: Color.fromRGBO(231, 233, 240, 1),
//                                   height: 1,
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.fromLTRB(30, 24, 20, 20),
//                                   child: Text(
//                                     "Our meta search feature is free, and it always will be, have confidence knowing you are always getting the best price on the net",
//                                     style: TextStyle(
//                                         fontFamily: "AvenirNext",
//                                         fontWeight: FontWeight.normal,
//                                         color: Color.fromRGBO(142, 150, 159, 1),
//                                         fontSize: 13),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15.0),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey[200],
//                                   offset: Offset(0, 0), //(x,y)
//                                   blurRadius: 10.0,
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               children: <Widget>[
//                                 Container(
//                                   padding: EdgeInsets.fromLTRB(30, 24, 30, 12),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[
//                                       Text(
//                                         "FlyLine Basic",
//                                         style: TextStyle(
//                                             fontFamily: "AvenirNext",
//                                             fontWeight: FontWeight.w800,
//                                             color:
//                                                 Color.fromRGBO(14, 49, 120, 1),
//                                             fontSize: 18),
//                                       ),
//                                       Text(
//                                         "\$49.99/yr",
//                                         style: TextStyle(
//                                             fontFamily: "AvenirNext",
//                                             fontWeight: FontWeight.w800,
//                                             color:
//                                                 Color.fromRGBO(14, 49, 120, 1),
//                                             fontSize: 18),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   color: Color.fromRGBO(231, 233, 240, 1),
//                                   height: 1,
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.fromLTRB(30, 24, 20, 20),
//                                   child: Text(
//                                     "Get a taste of the perks and savings FlyLine has to offer with FlyLine Basic",
//                                     style: TextStyle(
//                                         fontFamily: "AvenirNext",
//                                         fontWeight: FontWeight.normal,
//                                         color: Color.fromRGBO(142, 150, 159, 1),
//                                         fontSize: 13),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.fromLTRB(30, 24, 80, 20),
//                                   child: Column(
//                                     children: <Widget>[
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: <Widget>[
//                                           Text(
//                                             "- Meta Fares",
//                                             style: TextStyle(
//                                                 fontFamily: "AvenirNext",
//                                                 fontWeight: FontWeight.normal,
//                                                 color: Color.fromRGBO(
//                                                     14, 49, 120, 1),
//                                                 fontSize: 13),
//                                           ),
//                                           Text(
//                                             "- Max of 6 bookings",
//                                             style: TextStyle(
//                                                 fontFamily: "AvenirNext",
//                                                 fontWeight: FontWeight.normal,
//                                                 color: Color.fromRGBO(
//                                                     14, 49, 120, 1),
//                                                 fontSize: 13),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: <Widget>[
//                                           Text(
//                                             "- FlyLine Fares",
//                                             style: TextStyle(
//                                                 fontFamily: "AvenirNext",
//                                                 fontWeight: FontWeight.normal,
//                                                 color: Color.fromRGBO(
//                                                     14, 49, 120, 1),
//                                                 fontSize: 13),
//                                           ),
//                                           Text(
//                                             "- Deal Alerts",
//                                             style: TextStyle(
//                                                 fontFamily: "AvenirNext",
//                                                 fontWeight: FontWeight.normal,
//                                                 color: Color.fromRGBO(
//                                                     14, 49, 120, 1),
//                                                 fontSize: 13),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.fromLTRB(80, 12, 80, 12),
//                                   margin: EdgeInsets.only(bottom: 20),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                     color: Color.fromRGBO(0, 174, 239, 1),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey[200],
//                                         offset: Offset(0, 0), //(x,y)
//                                         blurRadius: 10.0,
//                                       ),
//                                     ],
//                                   ),
//                                   child: Text(
//                                     "Start 14 Day Free Trial",
//                                     style: TextStyle(
//                                         fontFamily: "AvenirNext",
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white,
//                                         fontSize: 13),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15.0),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey[200],
//                                   offset: Offset(0, 0), //(x,y)
//                                   blurRadius: 10.0,
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               children: <Widget>[
//                                 Container(
//                                   padding: EdgeInsets.fromLTRB(30, 24, 30, 12),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[
//                                       Text(
//                                         "FlyLine Premium",
//                                         style: TextStyle(
//                                             fontFamily: "AvenirNext",
//                                             fontWeight: FontWeight.w800,
//                                             color:
//                                                 Color.fromRGBO(14, 49, 120, 1),
//                                             fontSize: 18),
//                                       ),
//                                       Text(
//                                         "\$79.99/yr",
//                                         style: TextStyle(
//                                             fontFamily: "AvenirNext",
//                                             fontWeight: FontWeight.w800,
//                                             color:
//                                                 Color.fromRGBO(14, 49, 120, 1),
//                                             fontSize: 18),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   color: Color.fromRGBO(231, 233, 240, 1),
//                                   height: 1,
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.fromLTRB(30, 24, 20, 20),
//                                   child: Text(
//                                     "Get the most out of FlyLine with FlyLine Premium. Save time and money.",
//                                     style: TextStyle(
//                                         fontFamily: "AvenirNext",
//                                         fontWeight: FontWeight.normal,
//                                         color: Color.fromRGBO(142, 150, 159, 1),
//                                         fontSize: 13),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.fromLTRB(30, 24, 80, 20),
//                                   child: Column(
//                                     children: <Widget>[
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: <Widget>[
//                                           Text(
//                                             "- Meta Fares",
//                                             style: TextStyle(
//                                                 fontFamily: "AvenirNext",
//                                                 fontWeight: FontWeight.normal,
//                                                 color: Color.fromRGBO(
//                                                     14, 49, 120, 1),
//                                                 fontSize: 13),
//                                           ),
//                                           Text(
//                                             "- Unlimited bookings",
//                                             style: TextStyle(
//                                                 fontFamily: "AvenirNext",
//                                                 fontWeight: FontWeight.normal,
//                                                 color: Color.fromRGBO(
//                                                     14, 49, 120, 1),
//                                                 fontSize: 13),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: <Widget>[
//                                           Text(
//                                             "- FlyLine Fares",
//                                             style: TextStyle(
//                                                 fontFamily: "AvenirNext",
//                                                 fontWeight: FontWeight.normal,
//                                                 color: Color.fromRGBO(
//                                                     14, 49, 120, 1),
//                                                 fontSize: 13),
//                                           ),
//                                           Text(
//                                             "- Additional User",
//                                             style: TextStyle(
//                                                 fontFamily: "AvenirNext",
//                                                 fontWeight: FontWeight.normal,
//                                                 color: Color.fromRGBO(
//                                                     14, 49, 120, 1),
//                                                 fontSize: 13),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.fromLTRB(80, 10, 80, 12),
//                                   margin: EdgeInsets.only(bottom: 20),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                     color: Color.fromRGBO(0, 174, 239, 1),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey[200],
//                                         offset: Offset(0, 0), //(x,y)
//                                         blurRadius: 10.0,
//                                       ),
//                                     ],
//                                   ),
//                                   child: Text(
//                                     "Start 14 Day Free Trial",
//                                     style: TextStyle(
//                                         fontFamily: "AvenirNext",
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white,
//                                         fontSize: 13),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
