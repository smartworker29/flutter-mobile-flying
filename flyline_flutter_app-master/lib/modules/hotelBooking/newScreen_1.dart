import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:motel/appTheme.dart';
import 'package:motel/helper/helper.dart';
import 'package:motel/models/checkFlightResponse.dart';
import 'package:motel/models/flightInformation.dart';
import 'package:motel/modules/hotelBooking/newScreen_2.dart' as newScreen2;
import 'package:motel/network/blocs.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HotelHomeScreen extends StatefulWidget {
  List<FlightRouteObject> routes;
  final int ad;
  final int ch;
  final String bookingToken;

  HotelHomeScreen({Key key, this.routes, this.ad, this.ch, this.bookingToken})
      : super(key: key);

  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {
  var personalItemBool = false;
  var noHandBagBool = true;
  var noCheckBagBool = true;
  var oneCheckBagBool = false;
  var twoCheckBagBool = false;

  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController dobController;
  TextEditingController genderController;
  TextEditingController passportIdController;
  TextEditingController passportExpirationController;

  static var genders = [
    "Male",
    "Female",
  ];
  static var genderValues = ["0", "1"];

  var selectedGender = genders[0];
  var selectedGenderValue = genderValues[0];

  void getAccountInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      firstNameController = TextEditingController();
      firstNameController.text = prefs.getString('first_name');

      lastNameController = TextEditingController();
      lastNameController.text = prefs.getString('last_name');

      dobController = TextEditingController();
      dobController.text = prefs.getString('dob');

      genderController = TextEditingController();
      genderController.text =
          int.parse(prefs.getString('gender')) == 0 ? 'Male' : 'Female';
    });
  }

  @override
  void initState() {
    this.getAccountInfo();
    flyLinebloc.checkFlights(widget.bookingToken, 0, widget.ch, widget.ad);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  getAppBarUI(),
                  Container(
                    child: Column(
                      children: <Widget>[
                        getFlightDetails(),
                        getTravailInformationUI(),
                        getSearchButton()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTravailInformationUI() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16.0, top: 10),
          child: Text(
            "Traveler Information",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.getTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey, offset: Offset(0, 2), blurRadius: 8.0),
            ],
          ),
          child: Container(
            width: MediaQuery.of(context).size.width / 4,
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: firstNameController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "First Name",
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.getTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey, offset: Offset(0, 2), blurRadius: 8.0),
            ],
          ),
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: lastNameController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Last Name",
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.getTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey, offset: Offset(0, 2), blurRadius: 8.0),
            ],
          ),
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: dobController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(1960, 1, 1),
                    maxTime: DateTime.now(), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  dobController.text =
                      Helper.getDateViaDate(date, 'yyyy-MM-dd');
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Birth Date",
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.getTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey, offset: Offset(0, 2), blurRadius: 8.0),
            ],
          ),
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: genderController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {
                SelectDialog.showModal<String>(context,
                    searchBoxDecoration: InputDecoration(hintText: "Pick one"),
                    label: "Gender",
                    selectedValue: selectedGender,
                    items: genders, onChange: (String selected) {
                  setState(() {
                    selectedGender = selected;
                    selectedGenderValue =
                        genderValues[genders.indexOf(selected)];
                    genderController.text = selectedGender;
                  });
                });
              },
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Gender",
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16.0, top: 16),
          child: Text(
            "Only required on International",
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.getTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey, offset: Offset(0, 2), blurRadius: 8.0),
            ],
          ),
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: passportIdController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Passport ID",
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.getTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey, offset: Offset(0, 2), blurRadius: 8.0),
            ],
          ),
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: passportExpirationController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Passport Expiration",
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 15, bottom: 10),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16.0, top: 10),
          child: Text(
            "Carry On",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        StreamBuilder<CheckFlightResponse>(
            stream: flyLinebloc.checkFlightData.stream,
            builder: (context, AsyncSnapshot<CheckFlightResponse> snapshot) {
              if (snapshot.data != null) {
                CheckFlightResponse response = snapshot.data;
                List<Widget> list = List();
                response.baggage.combinations.handBag.forEach((bag) {
                  if (bag.indices.length == 0) {
                    list.add(Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.getTheme().backgroundColor,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                              value: personalItemBool,
                              onChanged: (value) {
                                setState(() {
                                  personalItemBool = value;
                                });
                              },
                            ),
                            Text(
                              "Personal item",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              Helper.cost(response.total, response.conversion.amount, bag.price.amount),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ));
                  }
                  else {
                    list.add(Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.getTheme().backgroundColor,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey, offset: Offset(0, 2), blurRadius: 8.0),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                              value: noHandBagBool,
                              onChanged: (value) {
                                setState(() {
                                  noHandBagBool = value;
                                });
                              },
                            ),
                            Text(
                              "No Hand Baggage",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              Helper.cost(response.total, response.conversion.amount, bag.price.amount),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ));
                  }
                });
                return Column(
                  children: list,
                );
              }

              return Container();
            }),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 15, bottom: 10),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16.0, top: 10),
          child: Text(
            "Checked Bagage",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        StreamBuilder<CheckFlightResponse>(
            stream: flyLinebloc.checkFlightData.stream,
            builder: (context, AsyncSnapshot<CheckFlightResponse> snapshot) {
              if (snapshot.data != null) {
                CheckFlightResponse response = snapshot.data;
                List<Widget> list = List();
                response.baggage.combinations.holdBag.forEach((bag) {
                  if (bag.indices.length == 0) {
                    list.add(Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.getTheme().backgroundColor,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                              value: noCheckBagBool,
                              onChanged: (value) {
                                setState(() {
                                  noCheckBagBool = value;
                                });
                              },
                            ),
                            Text(
                              "No Checked bagage",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              Helper.cost(response.total, response.conversion.amount, bag.price.amount),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ));
                  } else {
                    List<Widget> rows = List();
                    for (var i = 0; i < bag.indices.length; i++) {
                      rows.add(Text(
                        "Checked Baggage",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600),
                      ));
                    }
                    list.add(Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.getTheme().backgroundColor,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                              value: oneCheckBagBool,
                              onChanged: (value) {
                                setState(() {
                                  oneCheckBagBool = value;
                                });
                              },
                            ),
                            Column(
                              children: rows,
                            ),
                            Text(
                              Helper.cost(response.total, response.conversion.amount, bag.price.amount),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ));
                  }
                });
                return Column(
                  children: list,
                );
              }

              return Container();
            }),
      ],
    );
  }

  Widget getFlightDetails() {
    List<Widget> lists = List();
    for (var i = 0; i < widget.routes.length; i++) {
      FlightRouteObject route = widget.routes[i];
      lists.add(Container(
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5.0,
              spreadRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 16.0, top: 10),
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          Helper.getDateViaDate(
                                  route.localDeparture, "dd MMM") +
                              " | " +
                              (route.returnFlight == 0
                                  ? "Departure"
                                  : "Return"),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 32,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 10, left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.getTheme().backgroundColor,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppTheme.getTheme().dividerColor,
                              offset: Offset(4, 4),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 10, top: 5),
                                    margin: EdgeInsets.only(bottom: 3),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Helper.getDateViaDate(
                                              route.localDeparture,
                                              "HH : m a") +
                                          " " +
                                          route.flyFrom +
                                          " (" +
                                          route.cityFrom +
                                          ")",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 10, top: 5),
                                    margin: EdgeInsets.only(bottom: 3),
                                    child: Text(
                                      Helper.getDateViaDate(
                                              route.localArrival, "HH : m a") +
                                          " " +
                                          route.flyTo +
                                          " (" +
                                          route.cityTo +
                                          ")",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                right: 10,
                              ),
                              color: Colors.blueAccent,
                              child: Image.network(
                                "https://storage.googleapis.com/joinflyline/images/airlines/${route.airline}.png",
                                height: 20,
                                width: 20,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          Helper.duration(route.duration),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
    }
    return Column(
      children: lists,
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: AppTheme.getTheme().dividerColor,
              offset: Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
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
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top / 2),
              alignment: Alignment.center,
              child: Text(
                "Confirm Booking",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSearchButton() {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16, top: 30),
      decoration: BoxDecoration(border: Border.all(color: Colors.lightBlue)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text("",
                style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => newScreen2.HotelHomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
