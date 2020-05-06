import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:motel/appTheme.dart';
import 'package:motel/introductionScreen.dart';
import 'package:motel/main.dart';
import 'package:motel/modules/login/forgotPassword.dart';
import 'package:motel/network/blocs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoggingIn = false;
  bool isCalledOnce = false;
  var emailpressed = false; // This is the press variable
  var passwordpressed = false;
  var isLogginClicked = false;

  @override
  void initState() {
    super.initState();
    // passwordController.text = "Mgoblue123";
    //emailController.text = "zach@joinflyline.com";
    flyLinebloc.loginResponse.stream.listen((data) => onLogginResult(data));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: AppTheme.introColor,
        body: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: appBar(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 24,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              SizedBox(
                                width: 24,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppTheme.getTheme().backgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                // border: Border.all(
                                //   color: HexColor("#757575").withOpacity(0.6),
                                // ),
                                // boxShadow: <BoxShadow>[
                                //   BoxShadow(
                                //     color: AppTheme.getTheme().dividerColor,
                                //     blurRadius: 8,
                                //     offset: Offset(4, 4),
                                //   ),
                                // ],
                              ),
                              child: Center(
                                child: TextField(
                                  maxLines: 1,
                                  onChanged: (String txt) {
                                    setState(() {
                                      if (txt == "")
                                        emailpressed = false;
                                      else
                                        emailpressed =
                                            true; // update the state of the class to show color change
                                      isLogginClicked = false;
                                    });
                                  },
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: Color(0xff3a3f5c),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    // color: AppTheme.dark_grey,
                                  ),
                                  cursorColor: AppTheme.getTheme().primaryColor,
                                  decoration: InputDecoration(
                                    hintText: "Enter your email",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 16, bottom: 8),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 68,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 0, top: 0, bottom: 22),
                                    child: SizedBox(
                                      height: double.infinity,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.getTheme()
                                              .backgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          // boxShadow: <BoxShadow>[
                                          //   BoxShadow(
                                          //     color: AppTheme.getTheme().dividerColor,
                                          //     blurRadius: 8,
                                          //     offset: Offset(4, 4),
                                          //   ),
                                          // ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 68,
                                  child: TextField(
                                    obscureText: true,
                                    maxLines: 1,
                                    controller: passwordController,
                                    keyboardType: TextInputType.text,
                                    onChanged: (String txt) {
                                      setState(() {
                                        if (txt == "")
                                          passwordpressed = false;
                                        else
                                          passwordpressed =
                                              true; // update the state of the class to show color change
                                        isLogginClicked = false;
                                      });
                                    },
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xff3a3f5c),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      // color: AppTheme.dark_grey,
                                    ),
                                    cursorColor:
                                        AppTheme.getTheme().primaryColor,
                                    decoration: new InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      // errorText: isLogginClicked?"Please enter a valid password":null,
                                      contentPadding:
                                          const EdgeInsets.all(15.0),
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(15.0),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(15.0),
                                        ),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(15.0),
                                        ),
                                        borderSide: BorderSide(
                                            color: HexColor("#0e3178"),
                                            width: 1.0),
                                      ),
                                      errorBorder: isLogginClicked
                                          ? OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(15.0),
                                              ),
                                              borderSide: BorderSide(
                                                  color: HexColor("#ff6784"),
                                                  width: 1.0),
                                            )
                                          : null,
                                      hintText: "Enter your password",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Gilroy",
                                          color: Color(0xFFC7C9D1)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 8, top: 16),
                        child: isLoggingIn
                            ? Container(
                                margin: EdgeInsets.only(
                                    left: 40.0,
                                    right: 40.0,
                                    top: 30.0,
                                    bottom: 30.0),
                                child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            const Color(0xFF00AFF5)),
                                    strokeWidth: 3.0),
                                height: 40.0,
                                width: 40.0,
                              )
                            : Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: emailpressed || passwordpressed
                                      ? HexColor("#00AEEF")
                                      : HexColor("#c7c9d1"),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(27.0)),
                                  // boxShadow: <BoxShadow>[
                                  //   BoxShadow(
                                  //     color: AppTheme.getTheme().dividerColor,
                                  //     blurRadius: 8,
                                  //     offset: Offset(4, 4),
                                  //   ),
                                  // ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(1.0)),
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        isLogginClicked =
                                            true; // update the state of the class to show color change
                                      });
                                      isCalledOnce = true;
                                      flyLinebloc.tryLogin(
                                          emailController.text.toString(),
                                          passwordController.text.toString());

                                      // Navigator.pushAndRemoveUntil(context, Routes.SPLASH, (Route<dynamic> route) => false);
                                      // Navigator.pushReplacementNamed(context, Routes.TabScreen);
                                    },
                                    child: Center(
                                      child: Text(
                                        "Log In",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Gilroy Bold',
                                            fontSize: 16,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, right: 16, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen()),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Forgot your password?",
                                  style: TextStyle(
                                    fontFamily: "Gilroy",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.getTheme().disabledColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: AppBar().preferredSize.height,
          child: Padding(
            padding: EdgeInsets.only(top: 16, left: 16),
            child: Container(
              width: AppBar().preferredSize.height - 16,
              height: AppBar().preferredSize.height - 16,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppBar().preferredSize.height - 16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(1.0),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IntroductionScreen()));
                    // Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          // height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 60, bottom: 10),
            child: Text(
              "Log In",
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: HexColor("#0e3178"),
                fontFamily: "Gilroy",
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          // height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              "Log into your FlyLine Account ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: HexColor("#8E969F"),
                fontSize: 16,
                fontFamily: "Gilroy",
              ),
            ),
          ),
        )
      ],
    );
  }

  onLogginResult(String data) async {
    if (data != null) {
      if (data != "") {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.SearchScreen, (Route<dynamic> route) => false);
        _initTokenData(data);
      } else {
        //isLoggingIn = false;
        setState(() {});
        if (passwordController.text != "") {
          showErrorMsg();
        }
      }
    } else {
      isLoggingIn = false;
      setState(() {});
      if (passwordController.text != "") {
        showErrorMsg();
      }
    }
    setState(() {});
  }

  void showErrorMsg() {
    Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blueAccent,
        ),
        messageText: Text("Credentials are incorrect.",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 14.0)),
        duration: Duration(seconds: 3),
        isDismissible: true)
      ..show(context);
  }

  void _initTokenData(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token_data", data);
  }
}
