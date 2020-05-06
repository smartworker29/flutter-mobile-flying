import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:motel/models/account.dart';
import 'package:motel/modules/menuitems/menu_item_app_bar.dart';
import 'package:motel/network/blocs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDetailsScreen extends StatefulWidget {
  @override
  _AccountDetailsScreenState createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  Account account;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController dobController;
  TextEditingController genderController;
  TextEditingController emailController;
  TextEditingController phoneController;
  TextEditingController passportController;
  TextEditingController tempController;

  static var genders = [
    "Unselected",
    "Male",
    "Female",
  ];
  static var genderValues = ["1", "0", "1"];

  var selectedGender = genders[0];
  var selectedGenderValue = genderValues[0];

  void getAccountInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Country country = Country(prefs.getString('market.country.code'));
    Subdivision subdivision =
        Subdivision(prefs.getString('market.subdivision.name'));
    Market market = Market(
        prefs.getString('market.code'),
        country,
        prefs.getString('market.name'),
        subdivision,
        prefs.getString('market.type'));

    setState(() {
      account = Account(
        prefs.getString('first_name'),
        prefs.getString('last_name'),
        prefs.getString('email'),
        market,
        prefs.getString('gender'),
        prefs.getString('phone_number'),
        prefs.getString('dob'),
        prefs.getString('tsa_precheck_number'),
        prefs.getString('passport_number'),
      );

      firstNameController = TextEditingController();
      lastNameController = TextEditingController();
      dobController = TextEditingController();
      genderController = TextEditingController();
      emailController = TextEditingController();
      phoneController = TextEditingController();
      passportController = TextEditingController();
      var index = 0;
      account.jsonSerialize.forEach((v) {
        switch (index) {
          case 1:
            firstNameController.text = v['value'];
            break;
          case 2:
            lastNameController.text = v['value'];
            break;
          case 3:
            dobController.text = v['value'];
            break;
          case 4:
            if (v['value'].toString() != 'null') {
              genderController.text =
                  int.parse(v['value']) == 0 ? 'Male' : 'Female';
            } else {
              genderController.text = 'Male';
            }
            break;
          case 5:
            emailController.text = v['value'];
            break;
          case 6:
            phoneController.text = v['value'];
            break;
          case 7:
            passportController.text = v['value'];
            break;
          default:
            break;
        }

        index++;
      });
    });
  }

  TextEditingController getController(int index) {
    switch (index) {
      case 1:
        return firstNameController;
      case 2:
        return lastNameController;
      case 3:
        return dobController;
      case 4:
        return genderController;
      case 5:
        return emailController;
      case 6:
        return phoneController;
      case 7:
        return passportController;
      default:
        return tempController;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    this.getAccountInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FC),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MenuItemAppBar(title: "Account Details"),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: TextFormField(
                  controller: firstNameController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xff3a3f5c),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    // color: AppTheme.dark_grey,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'First Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter First Name';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: TextFormField(
                  controller: lastNameController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xff3a3f5c),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    // color: AppTheme.dark_grey,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Last Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Last Name';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      child: TextFormField(
                        controller: dobController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xff3a3f5c),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          // color: AppTheme.dark_grey,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Date of Birth',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter D.O.B';
                          }
                          return null;
                        },
                        onTap: () async {
                          var df = DateFormat("dd-MM-yyyy");
                          var now = DateTime.now();
                          DateTime date = DateTime(1900);
                          FocusScope.of(context).requestFocus(FocusNode());

                          date = await showDatePicker(
                              context: context,
                              initialDate: now,
                              firstDate: DateTime(1930),
                              lastDate: DateTime.now());
                          var dateCtl;
                          dateCtl.text = df.format(date);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      onTap: () async {
                        List<Widget> items = List();

                        genders.forEach((item) {
                          items.add(Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              decoration: BoxDecoration(),
                              child: SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(context, item);
                                  setState(() {
                                    selectedGender = item;
                                    selectedGenderValue =
                                        genderValues[genders.indexOf(item)];
                                    genderController.text = selectedGender;
                                  });
                                },
                                child: Text(item),
                              )));
                        });
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: const Text('Select Gender'),
                                children: items,
                              );
                            });
                      },
                      maxLines: 1,
                      onChanged: (String txt) {},
                      controller: genderController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff3a3f5c),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        // color: AppTheme.dark_grey,
                      ),
                      decoration: new InputDecoration(
                        errorText: null,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xff3a3f5c),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    // color: AppTheme.dark_grey,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Email Address',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter E-mail Address';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xff3a3f5c),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    // color: AppTheme.dark_grey,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Phone Number',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Phone Number';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      child: TextFormField(
                        controller: passportController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xff3a3f5c),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          // color: AppTheme.dark_grey,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Passport ID',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Passport ID';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      child: TextFormField(
                        //  controller: passportController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xff3a3f5c),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          // color: AppTheme.dark_grey,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Passport Exp',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Passport Expiry Date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: TextFormField(
                  // controller: lastNameController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xff3a3f5c),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    // color: AppTheme.dark_grey,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Known Traveler Number',
                  ),
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Please enter Known Travelle';
                  //   }
                  //   return null;
                  // },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: TextFormField(
                  controller: tempController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xff3a3f5c),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    // color: AppTheme.dark_grey,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Home Airport',
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: TextFormField(
                  // controller: tempController,
                  enabled: false,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xff3a3f5c),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    // color: AppTheme.dark_grey,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Free Plan',
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(27)),
                    child: FlatButton(
                      color: Color(0xFF00AEEF),
                      child: Text(
                        'Save',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gilroy Bold',
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      onPressed: () {
                        if (genderController.text == "Unselected") {
                          return;
                        }

                        flyLinebloc.updateAccountInfo(
                          firstNameController.text,
                          lastNameController.text,
                          dobController.text,
                          genderController.text,
                          emailController.text,
                          phoneController.text,
                          passportController.text,
                        );
                      },
                    ),
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
