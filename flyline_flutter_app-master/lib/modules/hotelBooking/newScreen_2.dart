import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:motel/appTheme.dart';
import 'package:motel/helper/helper.dart';
import 'package:motel/models/bookRequest.dart' as BookRequest;
import 'package:motel/models/checkFlightResponse.dart';
import 'package:motel/models/travelerInformation.dart';
import 'package:motel/network/blocs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HotelHomeScreen extends StatefulWidget {
  final int numberOfPassengers;
  final CheckFlightResponse flightResponse;
  final List<TravelerInformation> travelerInformations;
  final Map<String, dynamic> retailInfo;

  HotelHomeScreen(
      {Key key,
      this.numberOfPassengers,
      this.travelerInformations,
      this.flightResponse,
      this.retailInfo})
      : super(key: key);

  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {
  double priceOnPassenger = 0;
  double priceOnBaggage = 0;
  double tripTotal = 0;

  TextEditingController promoCodeController;
  TextEditingController nameOnCardController;
  TextEditingController creditController;
  TextEditingController expDateController;
  TextEditingController ccvController;
  TextEditingController emailAddressController;
  TextEditingController phoneNumberController;

  @override
  void initState() {
    priceOnPassenger = Helper.getCostNumber(widget.flightResponse.total,
        widget.flightResponse.conversion.amount, widget.flightResponse.total);
    priceOnBaggage = 0;
    tripTotal = priceOnPassenger + priceOnBaggage;

    this.getAccountInfo();
    super.initState();
  }

  void getAccountInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      promoCodeController = TextEditingController();
      nameOnCardController = TextEditingController();
      creditController = TextEditingController();
      expDateController = TextEditingController();
      ccvController = TextEditingController();
      emailAddressController = TextEditingController();
      phoneNumberController = TextEditingController();

      emailAddressController.text = prefs.getString('email');
      phoneNumberController.text = prefs.getString('phone_number');
    });
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
                        getTripDetails(),
                        getCheckoutUI(),
                        getBookButton()
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

  Widget getCheckoutUI() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16.0, top: 10),
          child: Text(
            "Check out",
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
              controller: promoCodeController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Promo Code",
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
              controller: nameOnCardController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Name on Card",
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
              controller: creditController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Credit Card Number",
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                    left: 16, right: 8, top: 8, bottom: 8),
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
                  child: TextField(
                    controller: expDateController,
                    textAlign: TextAlign.start,
                    onChanged: (String txt) {},
                    onTap: () {},
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    cursorColor: AppTheme.getTheme().primaryColor,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: "Exp Date",
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                    left: 8, right: 16, top: 8, bottom: 8),
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
                  child: TextField(
                    controller: ccvController,
                    textAlign: TextAlign.start,
                    onChanged: (String txt) {},
                    onTap: () {},
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    cursorColor: AppTheme.getTheme().primaryColor,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: "CCV",
                    ),
                  ),
                ),
              ),
            )
          ],
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
              controller: emailAddressController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Email Address",
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
              controller: phoneNumberController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Phone Number",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getTripDetails() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: AppTheme.getTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey, offset: Offset(0, 2), blurRadius: 8.0),
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
                            "Trip Summary",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 32,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 10, left: 16, right: 16),
                          padding: EdgeInsets.all(10),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, top: 5),
                                      margin: EdgeInsets.only(bottom: 3),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.numberOfPassengers.toString() +
                                            " Passenger",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 10, top: 5),
                                    margin: EdgeInsets.only(bottom: 3),
                                    child: Text(
                                      Helper.cost(
                                          widget.flightResponse.total,
                                          widget
                                              .flightResponse.conversion.amount,
                                          widget.flightResponse.total),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, top: 5),
                                      margin: EdgeInsets.only(bottom: 3),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Bagage",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 10, top: 5),
                                    margin: EdgeInsets.only(bottom: 3),
                                    child: Text(
                                      "\$0 ",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, top: 5),
                                      margin: EdgeInsets.only(bottom: 3),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Automatic Check-in",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 10, top: 5),
                                    margin: EdgeInsets.only(bottom: 3),
                                    child: Text(
                                      "Free ",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Container(
                                  height: 1,
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, top: 5),
                                      margin: EdgeInsets.only(bottom: 3),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Trip Total",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 10, top: 5),
                                    margin: EdgeInsets.only(bottom: 3),
                                    child: Text(
                                      " \$" + tripTotal.toString(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
                "Payment",
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

  Widget getBookButton() {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16, top: 30),
      decoration: BoxDecoration(border: Border.all(color: Colors.lightBlue)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text("Book Flight For \$" + tripTotal.toString(),
                style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
            onPressed: () {
              flyLinebloc.book(this.createBookRequest());
            },
          ),
        ],
      ),
    );
  }

  BookRequest.BookRequest createBookRequest() {
    BookRequest.Baggage baggage =
        BookRequest.Baggage(List<BookRequest.BaggageItem>());

    List<BookRequest.Passenger> passengers = List();

    Map<String, List<int>> carryOnPassengers = Map();
    List<BagItem> carryOns = List();

    Map<String, List<int>> checkedBagagePassengers = Map();
    List<BagItem> checkedBagages = List();

    widget.travelerInformations.forEach((p) {
      BookRequest.Passenger passenger = BookRequest.Passenger(
          DateTime.parse(p.dob),
          p.passportId,
          "adult",
          p.passportExpiration,
          p.firstName,
          "US",
          p.lastName,
          "mr");

      passengers.add(passenger);

      if (carryOnPassengers.containsKey(p.carryOnSelected.uuid)) {
        carryOnPassengers.update(p.carryOnSelected.uuid, (List<int> val) {
          val.add(passengers.length - 1);
          return val;
        });
      } else {
        carryOns.add(p.carryOnSelected);
        carryOnPassengers.addAll({
          p.carryOnSelected.uuid: [passengers.length - 1]
        });
      }

      if (checkedBagagePassengers.containsKey(p.checkedBagageSelected.uuid)) {
        checkedBagagePassengers.update(p.checkedBagageSelected.uuid,
            (List<int> val) {
          val.add(passengers.length - 1);
          return val;
        });
      } else {
        checkedBagages.add(p.checkedBagageSelected);
        checkedBagagePassengers.addAll({
          p.checkedBagageSelected.uuid: [passengers.length - 1]
        });
      }
//      BookRequest.Combination combinationCarryOn =
//          BookRequest.Combination(p.carryOnSelected);
//
//      BookRequest.Combination combinationCheckedBagage =
//          BookRequest.Combination(p.checkedBagageSelected);
//
//      baggage.add(new BookRequest.BaggageItem(combinationCarryOn, [passengers.length - 1]));
//      baggage.add(new BookRequest.BaggageItem(combinationCheckedBagage, [passengers.length - 1]));
    });

    carryOns.forEach((item) {
      BookRequest.Combination combination = BookRequest.Combination(item);

      baggage.add(new BookRequest.BaggageItem(
          combination, carryOnPassengers[item.uuid]));
    });

    checkedBagages.forEach((item) {
      BookRequest.Combination combination = BookRequest.Combination(item);

      baggage.add(new BookRequest.BaggageItem(
          combination, checkedBagagePassengers[item.uuid]));
    });

    BookRequest.BookRequest bookRequest = BookRequest.BookRequest(
        baggage,
        BookRequest.BookRequest.DEFAULT_CURRENCY,
        BookRequest.BookRequest.DEFAULT_LANG,
        BookRequest.BookRequest.DEFAULT_LOCALE,
        BookRequest.BookRequest.DEFAULT_PAYMENT_GATEWAY,
        this.getPayment(),
        passengers,
        widget.retailInfo);

    return bookRequest;
  }

  BookRequest.Payment getPayment() => BookRequest.Payment(
      creditController.text,
      ccvController.text,
      emailAddressController.text,
      expDateController.text,
      nameOnCardController.text,
      phoneNumberController.text,
      promoCodeController.text);
}
