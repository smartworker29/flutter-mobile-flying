import 'dart:async';

import 'package:flutter/material.dart';
import 'package:motel/appTheme.dart';
import 'package:motel/main.dart';
import 'package:motel/modules/login/loginScreen.dart';
import 'package:motel/modules/signup/signUp.dart';
import 'package:motel/network/blocs.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appTheme.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  var pageController = PageController(initialPage: 0);
  var pageViewModelData = List<PageViewData>();

  Timer sliderTimer;
  var currentShowIndex = 0;

  var isLogin = false;

  void _checkIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("token_data");
    print(data.toString() + "DDDDDDDDDDDDDDDDDDDDDDDDDD");
    if (data != null) {
      if (data.isEmpty) {
        isLogin = true;
        setState(() {});
      } else {
        flyLinebloc.token = data;
        isLogin = false;
        setState(() {});
        flyLinebloc.loginResponse.stream.listen((data) => onLogginResult(data));
      }
    } else {
      isLogin = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    _checkIsLogin();
    pageViewModelData.add(PageViewData(
      style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.bold),
      titleText: 'Stop Paying Retail',
      subText:
          'We source flights from over 250 airlines and sell them directly to you with zero markups.',
      assetsImage: 'assets/images/bg1.png',
    ));

    pageViewModelData.add(PageViewData(
      titleText: 'Virtual Interlining',
      subText:
          'We connect one-way flights from different carriers to deliver the best savings.',
      assetsImage: 'assets/images/bg2.png',
    ));

    pageViewModelData.add(PageViewData(
      titleText: 'Always the Cheapest',
      subText:
          'We will always display the cheapest fare, whether it is a public or FlyLine fare.',
      assetsImage: 'assets/images/bg3.png',
    ));

    super.initState();
  }

  @override
  void dispose() {
    sliderTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: AppTheme.introColor,
        body: SafeArea(
          child: isLogin
              ? Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                  // pageController.animateToPage(
                                  //     (currentShowIndex + 1) % 3,
                                  //     duration: Duration(seconds: 1),
                                  //     curve: Curves.fastOutSlowIn);
                                },
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1.0)),
                                highlightColor: Colors.transparent,
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Already have an account? ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Gilroy',
                                          fontSize: 16,
                                          color: HexColor("#8e969f")),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Log In',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Gilroy-Bold',
                                              fontSize: 16,
                                              color: HexColor("#00AEEF")),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                        child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              color: AppTheme.introColor,
                            ),
                            child: PageIndicatorContainer(
                              child: PageView(
                                controller: pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    currentShowIndex = index;
                                  });
                                },
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  PagePopup(imageData: pageViewModelData[0]),
                                  PagePopup(imageData: pageViewModelData[1]),
                                  PagePopup(imageData: pageViewModelData[2]),
                                ],
                              ),
                              align: IndicatorAlign.bottom,
                              indicatorColor: HexColor("#e7e9f0"),
                              indicatorSelectorColor: HexColor("#0e3178"),
                              padding: EdgeInsets.only(left: 25, right: 25),
                              length: 3,
                              indicatorSpace: 20.0,
                              shape: IndicatorShape.roundRectangleShape(
                                  size: Size(45, 9), cornerSize: Size(4, 4)),
                            )),
//                      Positioned(
//                        bottom: 20.0,
//                        left: 0.0,
//                        right: 0.0,
//                        child: Center(
//                            child: PageIndicator(
//                         // layout: PageIndicatorLayout.SLIDE,
//                          size: 15.0,
//                          controller: pageController,
//                          space: 20.0,
//                          count: 3,
//                          color: HexColor("#e7e9f0"),
//                          activeColor: HexColor("#0e3178"),
//                        )),
//                      ),
                      ],
                    )),
                    currentShowIndex != 2
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 70, right: 70, bottom: 30, top: 37),
                            child: Container(
                              height: 50,
                              width: 235,
                              decoration: BoxDecoration(
                                color: HexColor("00aeef"),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(27.0)),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    pageController.animateToPage(
                                        currentShowIndex + 1,
                                        duration: Duration(seconds: 1),
                                        curve: Curves.fastOutSlowIn);
                                  },
                                  child: Center(
                                    child: Text(
                                      "Next",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Gilroy',
                                          fontSize: 16,
                                          letterSpacing: 1.4,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 70, right: 70, bottom: 30, top: 37),
                            child: Container(
                              height: 50,
                              width: 235,
                              decoration: BoxDecoration(
                                color: HexColor("00aeef"),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(27.0)),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpScreen()),
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      "Continue",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Gilroy-Bold',
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).padding.bottom,
                    // ),
                    currentShowIndex != 2
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 40, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()),
                                      );
                                    },
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(1.0)),
                                    highlightColor: Colors.transparent,
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: HexColor('#0e3178'),
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0),
                                          children: <TextSpan>[
                                            TextSpan(
                                                style: TextStyle(
                                                    fontFamily: 'Gilroy',
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        HexColor('#00aeef'))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 70, right: 70, bottom: 40, top: 10),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: HexColor('#0e3178'),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                  children: <TextSpan>[
                                    TextSpan(
                                        style: TextStyle(
                                            color: HexColor('#00aeef'))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }

  onLogginResult(String data) {
    if (this.mounted)
      // ignore: missing_return
      setState(() {
        if (data != null) {
          if (data.isNotEmpty) {
            isLogin = false;
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.SearchScreen, (Route<dynamic> route) => false);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      });
  }
}

class PagePopup extends StatelessWidget {
  final PageViewData imageData;

  const PagePopup({Key key, this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            child: Image(
              image: AssetImage(imageData.assetsImage),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15, left: 30, right: 30),
          child: Text(
            imageData.titleText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: HexColor("#0e3178"),
              height: 1.58,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15, left: 30, right: 30),
          child: Text(
            imageData.subText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16, color: HexColor("#8e969f"), height: 1.5),
          ),
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}

class PageViewData {
  final String titleText;
  final String subText;
  final String assetsImage;
  final TextStyle style;

  PageViewData({this.titleText, this.subText, this.assetsImage, this.style});
}
