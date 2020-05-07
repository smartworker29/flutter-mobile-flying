import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:motel/appTheme.dart';
import 'package:motel/helper/helper.dart';
import 'package:motel/models/check_flight_response.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/models/traveler_information.dart';
import 'package:motel/modules/bookingflow/personal_details.dart'
    as personal_details;
import 'package:motel/modules/bookingflow/search_selector.dart';
import 'package:motel/network/blocs.dart';
import 'package:motel/widgets/meta_fare_description.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class HotelHomeScreen extends StatefulWidget {
  final List<FlightRouteObject> routes;
  final int ad;
  final int ch;
  final String bookingToken;
  final int typeOfTripSelected;
  final String selectedClassOfService;
  final FlightInformationObject flight;
  final Map<String, dynamic> retailInfo;
  final String depDate;
  final String arrDate;
  final SearchType type;

  HotelHomeScreen({
    Key key,
    this.routes,
    this.ad,
    this.ch,
    this.bookingToken,
    this.flight,
    this.selectedClassOfService,
    this.typeOfTripSelected,
    this.retailInfo,
    this.depDate,
    this.arrDate,
    this.type,
  }) : super(key: key);

  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {
  int numberOfPassengers = 0;

  bool _checkFlight = false;
  bool _firstLoad = false;

  List<BagItem> carryOnSelectedList;
  List<Map<int, bool>> carryOnCheckBoxes;
  List<BagItem> checkedBagageSelectedList;
  List<Map<int, bool>> checkedBagageCheckBoxes;

  List<TextEditingController> firstNameControllers;
  List<TextEditingController> lastNameControllers;
  List<TextEditingController> dobControllers;
  List<TextEditingController> genderControllers;
  List<TextEditingController> passportIdControllers;
  List<TextEditingController> passportExpirationControllers;

  ScrollController scrollController =
      new ScrollController(initialScrollOffset: 300.0, keepScrollOffset: true);

  static var genders = [
    "Male",
    "Female",
  ];
  static var genderValues = ["0", "1"];

  var selectedGender = genders[0];
  var selectedGenderValue = genderValues[0];

  CheckFlightResponse _checkFlightResponse;
  List<BagItem> handBags;
  List<BagItem> holdBags;

  bool _displayPayment = false;
  bool _clickFlightDeparture = false;
  bool _clickFlightArrival = false;

  final formatDates = intl.DateFormat("dd MMM yyyy");
  final formatTime = intl.DateFormat("hh : mm a");
  final formatAllDay = intl.DateFormat("dd/MM/yyyy");

  void createCheckboxData() {
    for (var i = 0; i < handBags.length; i++) {
      if (i == 0) {
        this.carryOnCheckBoxes.insert(numberOfPassengers - 1, Map());
        this.carryOnCheckBoxes[numberOfPassengers - 1].addAll({i: true});
        carryOnSelectedList[numberOfPassengers - 1] = handBags[0];
      } else {
        this.carryOnCheckBoxes[numberOfPassengers - 1].addAll({i: false});
      }
    }

    for (var i = 0; i < holdBags.length; i++) {
      if (i == 0) {
        this.checkedBagageCheckBoxes.insert(numberOfPassengers - 1, Map());
        this.checkedBagageCheckBoxes[numberOfPassengers - 1].addAll({i: true});
        checkedBagageSelectedList[numberOfPassengers - 1] = holdBags[0];
      } else {
        this.checkedBagageCheckBoxes[numberOfPassengers - 1].addAll({i: false});
      }
    }
  }

  void addPassenger() async {
    numberOfPassengers++;
    TextEditingController firstNameController = new TextEditingController();
    TextEditingController lastNameController = new TextEditingController();
    TextEditingController dobController = new TextEditingController();
    TextEditingController genderController = new TextEditingController();
    TextEditingController passportIdController = new TextEditingController();
    TextEditingController passportExpirationController =
        new TextEditingController();

    firstNameControllers.add(firstNameController);
    lastNameControllers.add(lastNameController);
    dobControllers.add(dobController);
    genderControllers.add(genderController);
    passportIdControllers.add(passportIdController);
    passportExpirationControllers.add(passportExpirationController);

    carryOnSelectedList.add(null);
    checkedBagageSelectedList.add(null);

    if (numberOfPassengers == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      firstNameController.text = prefs.getString('first_name');
      lastNameController.text = prefs.getString('last_name');
      dobController.text = prefs.getString('dob');
      genderController.text =
          int.parse(prefs.getString('gender')) == 0 ? 'Male' : 'Female';
    }
  }

  @override
  void initState() {
    firstNameControllers = List();
    lastNameControllers = List();
    dobControllers = List();
    genderControllers = List();
    passportIdControllers = List();
    passportExpirationControllers = List();
    carryOnSelectedList = List();
    checkedBagageSelectedList = List();

    carryOnCheckBoxes = List();
    checkedBagageCheckBoxes = List();

    handBags = List();
    holdBags = List();

    addPassenger();
    flyLinebloc.checkFlights(widget.bookingToken, 0, widget.ch, widget.ad);
    _checkFlight = true;
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) => {
          scrollController.animateTo(-50.0,
              duration: Duration(milliseconds: 1), curve: Curves.ease)
        });

    flyLinebloc.checkFlightData.stream.listen((CheckFlightResponse response) {
      if (response != null && _checkFlight) {
        setState(() {
          _checkFlightResponse = response;
          if (!_firstLoad) {
//            scrollController.animateTo(-50.0,
//                duration: Duration(milliseconds: 1), curve: Curves.ease);
            handBags.addAll(response.baggage.combinations.handBag);
            holdBags.addAll(response.baggage.combinations.holdBag);

            this.createCheckboxData();
            _firstLoad = true;
          }
        });

        if (!response.flightsChecked) {
          flyLinebloc.checkFlights(
              widget.bookingToken, 0, widget.ch, widget.ad);
        } else {
          setState(() {
            _displayPayment = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _checkFlight = false;
    _firstLoad = false;
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double tripP = widget.flight.price;
    var triptotal = (tripP * numberOfPassengers).toStringAsFixed(2);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            getAppBarUI(),
            Expanded(
                child: SingleChildScrollView(
              controller: scrollController,
              child: flightDetail(),
            )),
            Container(
              height: 80.0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        RichText(
                          text: new TextSpan(children: [
                            new TextSpan(
                              text: "Trip Total : ",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff0e3178),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            new TextSpan(
                              text: "  \$ " +
                                  (tripP * numberOfPassengers)
                                      .toStringAsFixed(2),

                              // text: "  \$ " + widget.flight.price.toStringAsFixed(2),
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff0e3178),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    )),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          padding: EdgeInsets.only(left: 40.0, right: 40.0),
                          width: 199,
                          height: 50,
                          decoration: new BoxDecoration(
                            color: Color(0xff00aeef),
                            borderRadius: BorderRadius.circular(27),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x3300a3da),
                                  offset: Offset(0, 5),
                                  blurRadius: 20,
                                  spreadRadius: 0),
                            ],
                          ),
                          child: Center(
                            child: new Text(
                              "Continue",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xffffffff),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          var totaltriprice =
                              (tripP * numberOfPassengers).toStringAsFixed(2);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      personal_details.HotelHomeScreen(
                                          numberofpass: numberOfPassengers,
                                          totalPrice: totaltriprice,
                                          routes: widget.flight.routes,
                                          ad: this.widget.ad,
                                          //ch: this.widget.children,
                                          typeOfTripSelected:
                                              this.widget.typeOfTripSelected,
                                          selectedClassOfService: this
                                              .widget
                                              .selectedClassOfService,
                                          flight: widget.flight,
                                          bookingToken:
                                              widget.flight.bookingToken,
                                          retailInfo: widget.flight.raw)));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getTravailInformationUI(int position) {
    List<Widget> listOfHandBag = List();
    for (var i = 0; i < handBags.length; i++) {
      var bag = handBags[i];
      if (bag.indices.length == 0) {
        listOfHandBag.add(Container(
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
                  value: carryOnCheckBoxes[position][i],
                  onChanged: (value) {
                    setState(() {
                      carryOnCheckBoxes[position]
                          .updateAll((key, value) => value = false);
                      carryOnCheckBoxes[position][i] = value;
                      carryOnSelectedList[position] = bag;
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
                  Helper.cost(_checkFlightResponse.total,
                      _checkFlightResponse.conversion.amount, bag.price.amount),
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
        listOfHandBag.add(Container(
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
                  value: carryOnCheckBoxes[position][i],
                  onChanged: (value) {
                    setState(() {
                      carryOnCheckBoxes[position]
                          .updateAll((key, value) => value = false);
                      carryOnCheckBoxes[position][i] = value;
                      carryOnSelectedList[position] = bag;
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
                  Helper.cost(_checkFlightResponse.total,
                      _checkFlightResponse.conversion.amount, bag.price.amount),
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
    }

    List<Widget> listOfHoldBag = List();
    for (var i = 0; i < holdBags.length; i++) {
      var bag = holdBags[i];
      if (bag.indices.length == 0) {
        listOfHoldBag.add(Container(
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
                  value: checkedBagageCheckBoxes[position][i],
                  onChanged: (value) {
                    setState(() {
                      checkedBagageCheckBoxes[position]
                          .updateAll((key, value) => value = false);
                      checkedBagageCheckBoxes[position][i] = value;
                      checkedBagageSelectedList[position] = bag;
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
                  Helper.cost(_checkFlightResponse.total,
                      _checkFlightResponse.conversion.amount, bag.price.amount),
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
                fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600),
          ));
        }
        listOfHoldBag.add(Container(
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
                  value: checkedBagageCheckBoxes[position][i],
                  onChanged: (value) {
                    setState(() {
                      checkedBagageCheckBoxes[position]
                          .updateAll((key, value) => value = false);
                      checkedBagageCheckBoxes[position][i] = value;
                      checkedBagageSelectedList[position] = bag;
                    });
                  },
                ),
                Column(
                  children: rows,
                ),
                Text(
                  Helper.cost(_checkFlightResponse.total,
                      _checkFlightResponse.conversion.amount, bag.price.amount),
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
    }
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 28, bottom: 10),
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            (this.numberOfPassengers <= 1
                ? "Traveler Information"
                : "Traveler Information (Passenger $numberOfPassengers)"),
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
              controller: firstNameControllers[position],
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
              controller: lastNameControllers[position],
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
              controller: dobControllers[position],
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(1960, 1, 1),
                    maxTime: DateTime.now(), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  dobControllers[position].text =
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
              controller: genderControllers[position],
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () async {
                List<Widget> items = List();
                items.add(Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        //                    <--- top side
                        color: AppTheme.getTheme().dividerColor,
                      ),
                    ),
                  ),
                  child: Container(),
                ));
                genders.forEach((item) {
                  items.add(Container(
                      margin: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            //                    <--- top side
                            color: AppTheme.getTheme().dividerColor,
                          ),
                        ),
                      ),
                      child: SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context, item);
                          setState(() {
                            selectedGender = item;
                            selectedGenderValue =
                                genderValues[genders.indexOf(item)];
                            genderControllers[position].text = item;
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
            "Only required on international flights",
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
              controller: passportIdControllers[position],
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
              controller: passportExpirationControllers[position],
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
          margin: const EdgeInsets.only(top: 28, bottom: 10),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16.0, top: 10),
          child: Text(
            "Carry On",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Column(
          children: <Widget>[] + listOfHandBag,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 28, bottom: 10),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16.0, top: 10),
          child: Text(
            "Checked Bagage",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Column(
          children: <Widget>[] + listOfHoldBag,
        ),
      ],
    );
  }

  Widget flightDetail() {
    double tripP = widget.flight.price;
    // initialize
    int a2b = 0;
    int b2a = 0;

    List<FlightRouteObject> departures = List();
    List<String> departureStopOverCity = List();
    List<FlightRouteObject> returns = List();
    List<String> returnStopOverCity = List();
    // get all flight routes
    List<FlightRouteObject> routes = widget.routes;

    // one way
    if (widget.typeOfTripSelected == 1) {
      for (FlightRouteObject route in widget.routes) {
        departures.add(route);
        if (route.cityTo != widget.flight.cityTo) {
          departureStopOverCity.add(route.cityTo);
          a2b++;
        } else {
          break;
        }
      } // round trip
    } else if (widget.typeOfTripSelected == 0) {
      for (FlightRouteObject route in widget.routes) {
        departures.add(route);
        if (route.cityTo != widget.flight.cityTo) {
          departureStopOverCity.add(route.cityTo);
          a2b++;
        } else {
          break;
        }
      }

      for (FlightRouteObject route in widget.routes.reversed) {
        returns.add(route);

        if (route.cityFrom != widget.flight.cityTo) {
          returnStopOverCity.add(route.cityTo);
          b2a++;
        } else {
          break;
        }
      }
    }
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20.0, bottom: 25.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    _clickFlightDeparture = !_clickFlightDeparture;
                  });
                },
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            top: 14,
                            bottom: 24,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: "Departure :   ",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xff0e3178),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    )),
                                TextSpan(
                                    text: widget.depDate,
                                    // text: formatDates
                                    //     .format(widget.flight.localDeparture),
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xff0e3178),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    )),
                              ])),
                              ((a2b >= 1 || b2a >= 1)
                                  ? Text(
                                      "",
                                      style: TextStyle(
                                        fontFamily: 'AvenirNext',
                                        color: Color(0xff00aeef),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    )
                                  : Container())
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        width: 3, color: Color(0xFFF7F9FC)
                                        // Color.fromRGBO(14, 49, 120, 1),
                                        ),
                                  ),
                                  width: 10,
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  // margin: EdgeInsets.only(bottom: 8),
                                  // width:
                                  //     MediaQuery.of(context).size.width /
                                  //         2,
                                  child: RichText(
                                    text: new TextSpan(children: [
                                      new TextSpan(
                                          text: formatTime.format(departures[0]
                                                  .localDeparture) +
                                              " - ",
                                          style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            color: Color(0xff000000),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.normal,
                                          )),
                                      new TextSpan(
                                        text: departures[0].flyFrom +
                                            " (" +
                                            departures[0].cityFrom +
                                            ")",
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xff000000),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                ),
                                (a2b > 1
                                    ? getFlightDetailItemsLogos(
                                        departures, returns)
                                    : Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle),
                                          alignment: Alignment.topRight,
                                          child: Image.network(
                                              'https://storage.googleapis.com/joinflyline/images/airlines/${widget.flight.routes[0].airline}.png',
                                              width: 24.0,
                                              height: 24.0),
                                        ),
                                      )),
                                // Text(
                                //   "Airlines",
                                //   style: TextStyle(
                                //     fontFamily: 'AvenirNext',
                                //     color: Color(0xff8e969f),
                                //     fontSize: 14,
                                //     fontWeight: FontWeight.w400,
                                //     fontStyle: FontStyle.normal,
                                //   ),
                                // ),
                              ],
                            ),
                            Container(
                              height: 40.5,
                              child: Image.asset(
                                'assets/images/arrow_down.png',
                                width: 8,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        width: 3,
                                        color: Color.fromRGBO(14, 49, 120, 1)),
                                  ),
                                  width: 10,
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  // margin: EdgeInsets.only(bottom: 3),
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: RichText(
                                    text: new TextSpan(children: [
                                      new TextSpan(
                                          text: formatTime.format(departures[
                                                      departures.length - 1]
                                                  .localArrival) +
                                              " ",
                                          style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            color: Color(0xff000000),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.normal,
                                          )),
                                      new TextSpan(
                                        text: departures[departures.length - 1]
                                                .flyTo +
                                            " (" +
                                            departures[departures.length - 1]
                                                .cityTo +
                                            ")",
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xff000000),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                                // SizedBox(
                                //   width: 68,
                                // ),
                                // (a2b > 1
                                //         ? getFlightDetailItemsLogos(
                                //             departures, returns)
                                //         : Expanded(
                                //             child: Container(
                                //               decoration: BoxDecoration(
                                //                   shape: BoxShape.circle),
                                //               alignment: Alignment.topRight,
                                //               child: Image.network(
                                //                   'https://storage.googleapis.com/joinflyline/images/airlines/${widget.flight.routes[0].airline}.png',
                                //                   width: 24.0,
                                //                   height: 24.0),
                                //             ),
                                //           )),
                                // Container(
                                //   // margin:
                                //   //     EdgeInsets.only(left: 10, right: 5),
                                //   child: Image.network(
                                //       'https://storage.googleapis.com/joinflyline/images/airlines/${widget.flight.routes[0].airline}.png',
                                //       width: 20.0,
                                //       height: 20.0),
                                // ),
                                // (a2b >= 1
                                //     ? Container(
                                //         margin:
                                //             EdgeInsets.only(left: 5, right: 5),
                                //         child: Image.network(
                                //             'https://storage.googleapis.com/joinflyline/images/airlines/${widget.flight.routes[0].airline}.png',
                                //             width: 20.0,
                                //             height: 20.0),
                                //       )
                                //     : Container()),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, right: 15),
                              child: Row(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: // Rectangle 716
                                        Container(
                                      width: 80,
                                      height: 27,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: const Color(0xfff7f9fc)),
                                      child: // 15h 56m
                                          Padding(
                                        padding:
                                            EdgeInsets.only(top: 6, left: 15),
                                        child: SizedBox(
                                          width: 50,
                                          height: 16,
                                          child: Text(
                                              widget.flight.durationDeparture,
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff0e3178),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Gilroy",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12.0),
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    // Rectangle 716
                                    child: Container(
                                      width: 80,
                                      height: 27,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: const Color(0xfff7f9fc)),
                                      child: // 1 Stopover
                                          Padding(
                                        padding:
                                            EdgeInsets.only(top: 6, left: 10),
                                        child: SizedBox(
                                            width: 60,
                                            height: 16,
                                            child: Text(
                                                (a2b > 0
                                                    ? (a2b > 1
                                                        ? "$a2b Stopovers"
                                                        : "$a2b Stopover")
                                                    : "Direct"),
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff0e3178),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Gilroy",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0),
                                                textAlign: TextAlign.center)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: // Rectangle 716
                                        Container(
                                      width: 80,
                                      height: 27,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: const Color(0xfff7f9fc)),
                                      child: // Economy
                                          Padding(
                                        padding:
                                            EdgeInsets.only(top: 6, left: 14),
                                        child: SizedBox(
                                            width: 52,
                                            height: 16,
                                            child: Text(
                                                widget.selectedClassOfService,
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff0e3178),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Gilroy",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0),
                                                textAlign: TextAlign.center)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              (widget.typeOfTripSelected == 1
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(
                          right: 20.0, left: 20.0, top: 21.0, bottom: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              width: 50,
                              height: 0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffe7e9f0), width: 1),
                              ),
                            ),
                          ),
                          Text(
                              widget.flight.nightsInDest.toString() +
                                  " night(s) in " +
                                  widget.flight.cityTo,
                              style: const TextStyle(
                                  color: const Color(0xff8e969f),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Gilroy",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              textAlign: TextAlign.left),
                          Expanded(
                            child: Container(
                              width: 50,
                              height: 0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffe7e9f0), width: 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              (widget.typeOfTripSelected == 1
                  ? Container()
                  : InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _clickFlightArrival = !_clickFlightArrival;
                        });
                      },
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                  top: 14,
                                  bottom: 24,
                                ),
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: "Return :   ",
                                      style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xff0e3178),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal)),
                                  TextSpan(
                                      text: widget.arrDate,
                                      // text: formatDates.format(
                                      //     returns[returns.length - 1]
                                      //         .localDeparture),
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color(0xff0e3178),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                      )),
                                ])),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                              width: 3,
                                              color: Color(0xFFF7F9FC)),
                                        ),
                                        width: 10,
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: RichText(
                                          text: new TextSpan(children: [
                                            new TextSpan(
                                                text: formatTime.format(returns[
                                                            returns.length - 1]
                                                        .localDeparture) +
                                                    " - ",
                                                style: TextStyle(
                                                  fontFamily: 'Gilroy',
                                                  color: Color(0xff000000),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                )),
                                            new TextSpan(
                                              text: returns[returns.length - 1]
                                                      .flyFrom +
                                                  " (" +
                                                  returns[returns.length - 1]
                                                      .cityFrom +
                                                  ")",
                                              style: TextStyle(
                                                fontFamily: 'Gilroy',
                                                color: Color(0xff000000),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                      ),
                                      (a2b > 1
                                          ? getFlightDetailItemsLogos(
                                              departures, returns)
                                          : Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle),
                                                alignment: Alignment.topRight,
                                                child: Image.network(
                                                    'https://storage.googleapis.com/joinflyline/images/airlines/${widget.flight.routes[0].airline}.png',
                                                    width: 20.0,
                                                    height: 20.0),
                                              ),
                                            )),
                                      // Text(
                                      //   "Airlines",
                                      //   style: TextStyle(
                                      //     fontFamily: 'AvenirNext',
                                      //     color: Color(0xff8e969f),
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w400,
                                      //     fontStyle: FontStyle.normal,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Container(
                                    height: 40.5,
                                    child: Image.asset(
                                      'assets/images/arrow_down.png',
                                      width: 10,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                              width: 3,
                                              color: Color.fromRGBO(
                                                  14, 49, 120, 1)),
                                        ),
                                        width: 10,
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                        ),
                                        // margin: EdgeInsets.only(bottom: 3),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: RichText(
                                          text: new TextSpan(children: [
                                            new TextSpan(
                                                text: formatTime.format(
                                                        returns[0]
                                                            .localArrival) +
                                                    " - ",
                                                style: TextStyle(
                                                  fontFamily: 'Gilroy',
                                                  color: Color(0xff000000),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                )),
                                            new TextSpan(
                                              text: returns[0].flyTo +
                                                  " (" +
                                                  returns[0].cityTo +
                                                  ")",
                                              style: TextStyle(
                                                fontFamily: 'Gilroy',
                                                color: Color(0xff000000),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   width: 68,
                                      // ),
                                      //  (a2b > 1
                                      //   ? getFlightDetailItemsLogos(departures,returns)
                                      //   : Expanded(
                                      //       child: Container(
                                      //         decoration: BoxDecoration(
                                      //             shape: BoxShape.circle),
                                      //         alignment: Alignment.topRight,
                                      //         child: Image.network(
                                      //             'https://storage.googleapis.com/joinflyline/images/airlines/${widget.flight.routes[0].airline}.png',
                                      //             width: 20.0,
                                      //             height: 20.0),
                                      //       ),
                                      //     )),
                                      // Container(
                                      //   // margin:
                                      //   //     EdgeInsets.only(left: 10, right: 5),
                                      //   child: Image.network(
                                      //       'https://storage.googleapis.com/joinflyline/images/airlines/${widget.flight.routes[1].airline}.png',
                                      //       width: 20.0,
                                      //       height: 20.0),
                                      // ),
                                      // (a2b >= 1
                                      //     ? Container(
                                      //         margin: EdgeInsets.only(
                                      //             left: 5, right: 5),
                                      //         child: Image.network(
                                      //             'https://storage.googleapis.com/joinflyline/images/airlines/${widget.flight.routes[1].airline}.png',
                                      //             width: 20.0,
                                      //             height: 20.0),
                                      //       )
                                      //     : Container()),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, right: 15),
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: // Rectangle 716
                                              Container(
                                            width: 80,
                                            height: 27,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                color: const Color(0xfff7f9fc)),
                                            child: // 15h 56m
                                                Padding(
                                              padding: EdgeInsets.only(
                                                  top: 6, left: 15),
                                              child: SizedBox(
                                                width: 50,
                                                height: 16,
                                                child: Text(
                                                    widget.flight
                                                        .durationDeparture,
                                                    style: const TextStyle(
                                                        color: const Color(
                                                            0xff0e3178),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: "Gilroy",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 12.0),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          // Rectangle 716
                                          child: Container(
                                            width: 80,
                                            height: 27,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                color: const Color(0xfff7f9fc)),
                                            child: // 1 Stopover
                                                Padding(
                                              padding: EdgeInsets.only(
                                                  top: 6, left: 10),
                                              child: SizedBox(
                                                  width: 60,
                                                  height: 16,
                                                  child: Text(
                                                      (a2b > 0
                                                          ? (a2b > 1
                                                              ? "$a2b Stopovers"
                                                              : "$a2b Stopover")
                                                          : "Direct"),
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff0e3178),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: "Gilroy",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: // Rectangle 716
                                              Container(
                                            width: 80,
                                            height: 27,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                color: const Color(0xfff7f9fc)),
                                            child: // Economy
                                                Padding(
                                              padding: EdgeInsets.only(
                                                  top: 6, left: 14),
                                              child: SizedBox(
                                                  width: 52,
                                                  height: 16,
                                                  child: Text(
                                                      widget
                                                          .selectedClassOfService,
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff0e3178),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: "Gilroy",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              // AnimatedOpacity(
              //     // If the widget is visible, animate to 0.0 (invisible).
              //     // If the widget is hidden, animate to 1.0 (fully visible).
              //     opacity: _clickFlightArrival ? 1.0 : 0.0,
              //     duration: Duration(milliseconds: 500),
              //     // The green box must be a child of the AnimatedOpacity widget.
              //     child: _clickFlightArrival && b2a >= 1
              //         ? this.getFlightDetailItems(returns, "return")
              //         : Container()),
              // Price and Book

              Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        //                    <--- top side
                        color: AppTheme.getTheme().dividerColor,
                      ),
                    ),
                  )),
              SizedBox(
                height: 16,
              ),

              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: new Text(
                              "Passengers:  ",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff8e969f),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  numberOfPassengers.toString() +
                                      ' Adult' +
                                      ' ',
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: Color(0xff000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  child: Container(
                                    child: Text(
                                      "Add More",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color(0xff00aeef),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    //  getAddAnotherPassenger();
                                    setState(() {
                                      numberOfPassengers++;
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                        child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Trip Price:",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff8e969f),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(),
                            Container(
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xffE5F7FE),
                              ),
                              child: Center(
                                child: Text(
                                  "  \$ " +
                                      widget.flight.price.toStringAsFixed(2),
                                  // (tripP*numberOfPassengers).toString(),
                                  // tripP.toString(),

                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: Color(0xff00aeef),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              //child: Text("\$ " + widget.flight.price.toString()),
                            ),
                          ],
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.type == SearchType.META)
          Padding(
            padding: const EdgeInsets.only(
              top: 24.0,
              left: 46.0,
              right: 46.0,
            ),
            child: MetaFareDescription(),
          ),
      ],
    );
  }

  List<Widget> loadItemsLogos(
    List<FlightRouteObject> routes,
    List<FlightRouteObject> returns,
  ) {
    List<Widget> lists = List();

    for (var i = 0; i < routes.length - 1; i++) {
      FlightRouteObject route = routes[i];
      lists.add(
        Container(
          margin: EdgeInsets.only(
            right: 10,
          ),
          child: Image.network(
            "https://storage.googleapis.com/joinflyline/images/airlines/${route.airline}.png",
            height: 20,
            width: 20,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return lists;
  }

  List<Widget> loadItems(
    List<FlightRouteObject> routes,
    List<FlightRouteObject> returns,
  ) {
    List<Widget> lists = List();

    for (var i = 0; i < routes.length - 1; i++) {
      FlightRouteObject route = routes[i];
      lists.add(
        Text(
          //route.cityTo +
          // " (" +
          route.flyTo + ' ',
          // +
          // ")  Duration: " +
          // Helper.duration(route.duration),
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      );
    }
    return lists;
  }

  List<Widget> loadItemsOneStop(
    List<FlightRouteObject> routes,
  ) {
    List<Widget> lists = List();

    for (var i = 0; i < routes.length - 1; i++) {
      FlightRouteObject route = routes[i];
      lists.add(
        Text(
          //route.cityTo +
          // " (" +
          route.flyTo + ' ' + Helper.duration(route.duration),
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      );
    }
    return lists;
  }

  Widget getFlightDetailItemsLogos(
    List<FlightRouteObject> departures,
    List<FlightRouteObject> returns,
  ) {
    List<Widget> lists = List();
    lists.addAll(loadItemsLogos(departures, returns));
    //lists.addAll(loadItems(returns.reversed.toList(), 'Return', flight));
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: lists);
  }

  Widget getFlightDetailItems(
    List<FlightRouteObject> departures,
    List<FlightRouteObject> returns,
  ) {
    List<Widget> lists = List();
    lists.addAll(loadItems(departures, returns));
    //lists.addAll(loadItems(returns.reversed.toList(), 'Return', flight));
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: lists);
  }

  Widget getFlightDetailItemsOneStop(
    List<FlightRouteObject> departures,
    List<FlightRouteObject> returns,
  ) {
    List<Widget> lists = List();
    lists.addAll(loadItemsOneStop(
      departures,
    ));
    //lists.addAll(loadItems(returns.reversed.toList(), 'Return', flight));
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: lists);
  }

  List<Widget> getFlightDetailItemUI(List<FlightRouteObject> routes) {
    List<Widget> lists = List();
    for (var i = 0; i < routes.length; i++) {
      FlightRouteObject route = routes[i];
      lists.add(Container(
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: const Color(0xF6F6F6),
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
                                              route.localDeparture, "hh:mm a") +
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
                                              route.localArrival, "hh:mm a") +
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
    return lists;
  }

  // Widget getFlightDetailItems(List<FlightRouteObject> routes, String type) {
  //   List<Widget> lists = List();
  //   lists
  //       .add(Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
  //     Container(
  //       padding: EdgeInsets.only(left: 16.0, top: 10),
  //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
  //       child: Text(
  //         type == "departure"
  //             ? "Departure | Duration: " +
  //                 widget.flight.durationDeparture.toString()
  //             : "Return | Duration: " + widget.flight.durationReturn.toString(),
  //         textAlign: TextAlign.start,
  //         style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  //       ),
  //     )
  //   ]));
  //   lists.addAll(getFlightDetailItemUI(routes));

  //   return Column(
  //     children: lists,
  //   );
  // }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF7F9FC),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top / 2),
              alignment: Alignment.center,
              child: new Text(
                "Trip Details",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xff0e3178),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
              ),
              // Text(
              //   "Confirm Booking",
              //   style: TextStyle(
              //     fontWeight: FontWeight.w600,
              //     fontSize: 22,
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAddAnotherPassenger() {
    return Container(
        margin: EdgeInsets.only(right: 16, top: 16, left: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                child: this.numberOfPassengers > 1
                    ? InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          if (this.numberOfPassengers > 1) {
                            print('remove passenger');
                            setState(() {
                              this.carryOnCheckBoxes.removeLast();
                              this.checkedBagageCheckBoxes.removeLast();
                              this.carryOnSelectedList.removeLast();
                              this.checkedBagageSelectedList.removeLast();

                              this.numberOfPassengers--;
                            });
                          }
                        },
                        child: Text("Remove passenger",
                            softWrap: true,
                            style: TextStyle(color: Colors.red)))
                    : Container()),
            Expanded(
                child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () {
                      print("add another");
                      setState(() {
                        this.addPassenger();
                        this.createCheckboxData();
                      });
                    },
                    child: Text("Add another passenger",
                        textAlign: TextAlign.right,
                        softWrap: true,
                        style: TextStyle(color: Colors.lightBlue)))),
          ],
        ));
  }

  Widget getSearchButton() {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          margin: EdgeInsets.only(left: 16.0, right: 16, top: 30),
          decoration: BoxDecoration(
              color: const Color(0xFF00AFF5),
              border: Border.all(color: const Color(0xFF00AFF5), width: 0.5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("Check Out",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  print(_checkFlightResponse.flightsChecked);
                  print(_checkFlightResponse.flightsInvalid);
                  if (_checkFlightResponse.noAvailableForBooking) {
                    Alert(
                      context: context,
                      title:
                          "Sorry, seems like the flight does not exist. Please choose another one.",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "OKAY",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          width: 120,
                        ),
                      ],
                    ).show();
                  } else {
                    List<TravelerInformation> lists = List();
                    for (int index = 0;
                        index < this.numberOfPassengers;
                        index++) {
                      var uuid = new Uuid();
                      carryOnSelectedList[index].uuid = uuid.v4();

                      var uuid2 = new Uuid();
                      checkedBagageSelectedList[index].uuid = uuid2.v4();
                      TravelerInformation travelerInformation =
                          TravelerInformation(
                              firstNameControllers[index].text,
                              lastNameControllers[index].text,
                              dobControllers[index].text,
                              genderControllers[index].text,
                              passportIdControllers[index].text,
                              passportExpirationControllers[index].text,
                              carryOnSelectedList[index],
                              checkedBagageSelectedList[index]);
                      lists.add(travelerInformation);
                    }

                    carryOnSelectedList.forEach((f) {
                      print(f.jsonSerialize);
                    });

                    checkedBagageSelectedList.forEach((f) {
                      print(f.jsonSerialize);
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              personal_details.HotelHomeScreen(
                                  // numberOfPassengers: numberOfPassengers,
                                  // travelerInformations: lists,
                                  // flightResponse: _checkFlightResponse,
                                  // retailInfo: widget.retailInfo,
                                  // bookingToken: widget.bookingToken,
                                  )),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 100)
      ],
    );
  }
}
