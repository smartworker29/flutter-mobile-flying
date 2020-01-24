import 'package:flutter/material.dart';
import 'package:motel/appTheme.dart';
import 'package:motel/modules/login/userInfoScreen.dart';
import 'loginScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool valid = true;
  String home;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        // backgroundColor: AppTheme.getTheme().backgroundColor,
        body: Form(
          key: _formKey,
          child: InkWell(
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
                                Expanded(
                                  child: getFTButton(),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: getFTButton(isFacebook: false),
                                ),
                                SizedBox(
                                  width: 24,
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.getTheme().backgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: AppTheme.getTheme().dividerColor,
                                  blurRadius: 8,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Container(
                                height: 58.0,
                                child: Center(
                                  child: TextFormField(
                                    maxLines: 1,
                                    onChanged: (String txt) {},
                                    // ignore: missing_return
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Fill this field';
                                      }
                                    },
                                    onSaved: (String value) {
                                      home = value;
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    cursorColor:
                                        AppTheme.getTheme().primaryColor,
                                    decoration: new InputDecoration(
                                      errorText: null,
                                      border: InputBorder.none,
                                      hintText: "Home Airport",
                                      hintStyle: TextStyle(
                                          color: AppTheme.getTheme()
                                              .disabledColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.getTheme().backgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: AppTheme.getTheme().dividerColor,
                                  blurRadius: 8,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Container(
                                height: 58.0,
                                child: Center(
                                  child: TextFormField(
                                    maxLines: 1,
                                    onChanged: (String txt) {
                                      email = txt;
                                    },
                                    // ignore: missing_return
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Fill this field';
                                      }
                                    },
                                    onSaved: (String value) {
                                      email = value;
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    cursorColor:
                                        AppTheme.getTheme().primaryColor,
                                    decoration: new InputDecoration(
                                      errorText: null,
                                      border: InputBorder.none,
                                      hintText: "Email Address",
                                      hintStyle: TextStyle(
                                          color: AppTheme.getTheme()
                                              .disabledColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.getTheme().backgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: AppTheme.getTheme().dividerColor,
                                  blurRadius: 8,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Container(
                                height: 58,
                                child: Center(
                                  child: TextFormField(
                                    obscureText: true,
                                    maxLines: 1,
                                    onChanged: (String txt) {},
                                    // ignore: missing_return
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Fill this field';
                                      }
                                    },
                                    onSaved: (String value) {
                                      password = value;
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    cursorColor:
                                        AppTheme.getTheme().primaryColor,
                                    decoration: new InputDecoration(
                                      errorText: null,
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                          color: AppTheme.getTheme()
                                              .disabledColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 8, top: 24),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.getTheme().primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: AppTheme.getTheme().dividerColor,
                                  blurRadius: 8,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24.0)),
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  // Navigator.pushNamedAndRemoveUntil(
                                  //     context,
                                  //     Routes.TabScreen,
                                  //     (Route<dynamic> route) => false);
                                  if (!_formKey.currentState.validate()) {
                                    return;
                                  }
                                  _formKey.currentState.save();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserInfoScreen(home, email, password),
                                    ),
                                  );
                                  //   Navigator.pushNamed(
                                  //       context, '/userInfoScreen');
                                },
                                child: Center(
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "By signing up, you agreed with our terms of\nServices and privacy Policy",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.getTheme().disabledColor,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Already have account?.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.getTheme().disabledColor,
                              ),
                            ),
                            InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.getTheme().primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 24,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getFTButton({bool isFacebook: true}) {
    return Container(
      height: 4,
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
            padding: EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 24),
          child: Text(
            "Get Started",
            style: new TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
