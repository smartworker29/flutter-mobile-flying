import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motel/appTheme.dart';
import '../../main.dart';
import 'loginScreen.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class UserInfoScreen extends StatefulWidget {
  String home;
  String email;
  String password;
  UserInfoScreen(this.home, this.email, this.password);
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String plan;
  String home;
  String email;
  String password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> planList = [
    "Basic (\$49.99/yr)",
    "Pro (\$79.99/yr)",
  ];
  final Map<String, dynamic> _formData = {
    'home_airport': null,
    'email': null,
    'password': null,
    'first_name': null,
    'last_name': null,
    'promo_code': null,
    'zip': null,
    'card_number': null,
    'expiry': null,
    'cvc': null,
    'plan': null,
  };
  @override
  void initState() {
    super.initState();
  }

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
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                  text: '- As a reminder we\'ll email you',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' 3 days',
                                      style: TextStyle(
                                        color: AppTheme.getTheme().primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Before.',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 24),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                  text: '- No Commitments.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' Cancel',
                                      style: TextStyle(
                                        color: AppTheme.getTheme().primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' at anytime.',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    )
                                  ]),
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
                                height: 58,
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
                                      _formData['first_name'] = value;
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    cursorColor:
                                        AppTheme.getTheme().primaryColor,
                                    decoration: new InputDecoration(
                                      errorText: null,
                                      border: InputBorder.none,
                                      hintText: "First Name",
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
                                height: 58,
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
                                      _formData['last_name'] = value;
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    cursorColor:
                                        AppTheme.getTheme().primaryColor,
                                    decoration: new InputDecoration(
                                      errorText: null,
                                      border: InputBorder.none,
                                      hintText: "Last Name",
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
                              left: 24, right: 24, bottom: 16.0),
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
                                  child: DropdownButtonFormField<String>(
                                    items: planList
                                        .map((String dropDownStringItem) {
                                      return DropdownMenuItem<String>(
                                        value: dropDownStringItem,
                                        child: Text(dropDownStringItem),
                                      );
                                    }).toList(),
                                    onChanged: (String newValueSelected) {
                                      plan = newValueSelected;
                                    },
                                    onSaved: (String value) {
                                      _formData['plan'] = value;
                                    },
                                    decoration:
                                        InputDecoration.collapsed(hintText: ''),
                                    hint: Text(
                                      'Select a Plan',
                                      style: TextStyle(
                                          color: AppTheme.getTheme()
                                              .disabledColor),
                                    ),
                                    value: plan,
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
                                height: 58,
                                child: Center(
                                  child: TextFormField(
                                    maxLines: 1,
                                    onChanged: (String txt) {},
                                    onSaved: (String value) {
                                      _formData['promo_code'] = value;
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    cursorColor:
                                        AppTheme.getTheme().primaryColor,
                                    decoration: new InputDecoration(
                                      errorText: null,
                                      border: InputBorder.none,
                                      hintText: "Promo Code",
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
                                height: 58,
                                child: Center(
                                  child: TextFormField(
                                    maxLines: 1,
                                    onChanged: (String txt) {},
                                    onSaved: (String value) {
                                      _formData['zip'] = value;
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    cursorColor:
                                        AppTheme.getTheme().primaryColor,
                                    decoration: new InputDecoration(
                                      errorText: null,
                                      border: InputBorder.none,
                                      hintText: "Billing Zip",
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
                                height: 58,
                                child: Center(
                                  child: TextFormField(
                                    maxLines: 1,
                                    onChanged: (String txt) {},
                                    onSaved: (String value) {
                                      _formData['card_number'] = value;
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    cursorColor:
                                        AppTheme.getTheme().primaryColor,
                                    decoration: new InputDecoration(
                                      errorText: null,
                                      border: InputBorder.none,
                                      hintText: "Credit Card Number",
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
                        Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 12, bottom: 16),
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
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: Container(
                                      height: 58,
                                      child: Center(
                                        child: TextFormField(
                                          maxLines: 1,
                                          onChanged: (String txt) {},
                                          onSaved: (String value) {
                                            _formData['expiry'] = value;
                                          },
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                          cursorColor:
                                              AppTheme.getTheme().primaryColor,
                                          decoration: new InputDecoration(
                                            errorText: null,
                                            border: InputBorder.none,
                                            hintText: "Exp Date",
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
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 24, bottom: 16),
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
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: Container(
                                      height: 58,
                                      child: Center(
                                        child: TextFormField(
                                          maxLines: 1,
                                          onChanged: (String txt) {},
                                          onSaved: (String value) {
                                            _formData['expiry'] = value;
                                          },
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                          cursorColor:
                                              AppTheme.getTheme().primaryColor,
                                          decoration: new InputDecoration(
                                            errorText: null,
                                            border: InputBorder.none,
                                            hintText: "CCV Code",
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
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 8, top: 24),
                          child: Container(
                            height: 58,
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
                                  register(_formData);

                                  //   Navigator.pushNamedAndRemoveUntil(
                                  //       context,
                                  //       Routes.TabScreen,
                                  //       (Route<dynamic> route) => false);
                                },
                                child: Center(
                                  child: Text(
                                    "Get Started",
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
                            "By signing up, you agree to FlyLine Terms of\nServices and Privacy Policy.",
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

  void register(Map<String, dynamic> _formData) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    FocusScope.of(context).requestFocus(FocusNode());
    print("aaappppiii");
    print(widget.home);
    print(_formData['first_name']);
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final params = jsonEncode({
      'home_airport': widget.home,
      'email': widget.email,
      'password': widget.password,
      'first_name': _formData['first_name'],
      'last_name': _formData['last_name'],
      'promo_code': _formData['promo_code'],
      'zip': _formData['zip'],
      'card_number': _formData['card_number'],
      'expiry': _formData['expiry'],
      'cvc': _formData['cvc'],
      'plan': _formData['plan'],
    });
    http
        .post(
      'https://staging.joinflyline.com/api/get-started/',
      headers: {'Content-Type': 'application/json'},
      body: params,
    )
        .then((http.Response response) async {
      //   print(response.body);
      var jsonResponse = json.decode(response.body);
      print("Resssspoooonnnsseee");
      print(jsonResponse);
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.TabScreen, (Route<dynamic> route) => false);
      //   if (response.statusCode == 400) {
      //     showToast(jsonResponse['error_description'],
      //         duration: Duration(seconds: 3), position: ToastPosition.bottom);
      //   } else if (response.statusCode == 200) {
      //     if (jsonResponse['status'] == "error") {
      //       showToast(jsonResponse['error'],
      //           duration: Duration(seconds: 3), position: ToastPosition.bottom);
      //     } else if (jsonResponse['status'] == "ok") {
      //       showToast("Successfully Registered",
      //           duration: Duration(seconds: 3), position: ToastPosition.bottom);
      //       Navigator.pushNamedAndRemoveUntil(
      //           context, Routes.TabScreen, (Route<dynamic> route) => false);
      //     }
      //   }
    });
  }
}
