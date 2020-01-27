import 'dart:developer';
import 'dart:ui';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:motel/appTheme.dart';
import 'package:motel/models/flightInformation.dart';
import 'package:motel/models/hotelListData.dart';
import 'package:motel/models/locations.dart';
import 'package:motel/modules/hotelBooking/calendarPopupView.dart';
import 'package:motel/modules/hotelBooking/roomPopupView.dart';
import 'package:motel/modules/myTrips/upcomingListView.dart';
import 'package:motel/network/blocs.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'filtersScreen.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

class HotelHomeScreen extends StatefulWidget {
  final String destination;

  HotelHomeScreen({Key key, this.destination}) : super(key: key);

  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {

  bool _isSearched = true;
  AnimationController animationController;
  AnimationController _animationController;
  var hotelList = HotelListData.hotelList;
  ScrollController scrollController = new ScrollController();
  int room = 1;
  int ad = 2;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 5));
  bool isMap = false;

  final formatDates = intl.DateFormat("dd MMM");
  final formatTime = intl.DateFormat("HH : m a");
  final formatAllDay = intl.DateFormat("dd/MM/yyyy");

  var typeOfTripSelected = 0;
  LocationObject selectedDeparture;
  LocationObject selectedArrival;

  var departureDate = DateTime.now();
  var returnDate = DateTime.now().add(Duration(days: 2));
  static var classOfServicesList = [
    "Economy",
    "Premium Economy",
    "Business",
    "First Class"
  ];
  static var classOfServicesValueList = ["M", "W", "C", "F"];

  var selectedClassOfService = classOfServicesList[0];
  var selectedClassOfServiceValue = classOfServicesValueList[0];

  final searchBarHieght = 158.0;
  final filterBarHieght = 52.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    scrollController.addListener(() {
      if (context != null) {
        if (scrollController.offset <= 0) {
          _animationController.animateTo(0.0);
        } else if (scrollController.offset > 0.0 &&
            scrollController.offset < searchBarHieght) {
          // we need around searchBarHieght scrolling values in 0.0 to 1.0
          _animationController
              .animateTo((scrollController.offset / searchBarHieght));
        } else {
          _animationController.animateTo(1.0);
        }
      }
    });
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  searchForLocation(query, isDeparture) async {
    flyLinebloc.locationItems.add(List<LocationObject>());
    flyLinebloc.locationQuery(query);
    //flyLinebloc.locationItems.stream.listen((data) => onUpdateResult(data, isDeparture));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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
            child: Column(
              children: <Widget>[
                getAppBarUI(),
                isMap
                    ? Expanded(
                        child: Column(
                          children: <Widget>[
                            getSearchBarUI(),
                            getTimeDateUI(),
                            getSearchButton(),
                            Expanded(
                              child: Stack(
                                children: <Widget>[
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Image.asset(
                                          "assets/images/mapImage.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        height: 80,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppTheme.getTheme()
                                                  .scaffoldBackgroundColor
                                                  .withOpacity(1.0),
                                              AppTheme.getTheme()
                                                  .scaffoldBackgroundColor
                                                  .withOpacity(0.0),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                      ),
                                    ] +
                                    [
                                      getFlightDetails(),
                                    ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Expanded(
                        child: Column(children: <Widget>[
                          Container(
                            color: AppTheme.getTheme().scaffoldBackgroundColor,
                            child: Column(
                              children: <Widget>[
                                getSearchBarUI(),
                                getTimeDateUI(),
                                getSearchButton(),
                              ],
                            ),
                          ),
                          getFilterBarUI(),
                          getFlightDetails(),
                        ]),
                      )
              ],
            ),
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  List<Widget> getMapPinUI() {
    List<Widget> list = List<Widget>();

    for (var i = 0; i < hotelList.length; i++) {
      double top;
      double left;
      double right;
      double bottom;
      if (i == 0) {
        top = 150;
        left = 50;
      } else if (i == 1) {
        top = 50;
        right = 50;
      } else if (i == 2) {
        top = 40;
        left = 10;
      } else if (i == 3) {
        bottom = 260;
        right = 140;
      } else if (i == 4) {
        bottom = 160;
        right = 20;
      }
      list.add(
        Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: Container(
            decoration: BoxDecoration(
              color: hotelList[i].isSelected
                  ? AppTheme.getTheme().primaryColor
                  : AppTheme.getTheme().backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppTheme.getTheme().dividerColor,
                  blurRadius: 16,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                onTap: () {
                  if (hotelList[i].isSelected == false) {
                    setState(() {
                      hotelList.forEach((f) {
                        f.isSelected = false;
                      });
                      hotelList[i].isSelected = true;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: Text(
                    "\$${hotelList[i].perNight}",
                    style: TextStyle(
                        color: hotelList[i].isSelected
                            ? AppTheme.getTheme().backgroundColor
                            : AppTheme.getTheme().primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }

  Widget getListUI() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: AppTheme.getTheme().dividerColor,
              offset: Offset(0, -2),
              blurRadius: 8.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 156 - 50,
            child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                } else {
                  return getFlightDetails();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget getHotelViewList() {
    List<Widget> hotelListViews = List<Widget>();
    for (var i = 0; i < hotelList.length; i++) {
      var count = hotelList.length;
      var animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval((1 / count) * i, 1.0, curve: Curves.fastOutSlowIn),
        ),
      );
      hotelListViews.add(
        HotelListView(
          callback: () {},
          hotelData: hotelList[i],
          animation: animation,
          animationController: animationController,
        ),
      );
    }
    animationController.forward();
    return Column(
      children: hotelListViews,
    );
  }

  Widget getFlightDetails() {
    return Container(
        child: StreamBuilder<List<FlightInformationObject>>(
      stream: flyLinebloc.flightsItems.stream,
      builder:
          (context, AsyncSnapshot<List<FlightInformationObject>> snapshot) {
        if (snapshot.data != null && snapshot.data.isNotEmpty) {

          var listOfFlights = snapshot.data;

          return Expanded(
            child: Container(
                child: AnimatedContainer(
                    duration: Duration(microseconds: 200),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      scrollDirection: Axis.vertical,
                      itemCount: listOfFlights.length,
                      itemBuilder: (context, index) {
                        var flight = listOfFlights[index];

                    print(flight);
                    print(flight.routes);

                    // initialize
                    int a2b = 0;
                    int b2a = 0;

                    // get all flight routes
                    List<FlightRouteObject> routes = flight.routes;

                    // one way
                    if (typeOfTripSelected == 1) {

                      for(FlightRouteObject route in flight.routes) {

                        if (route.cityTo != flight.cityTo) {
                          a2b++;
                        } else {
                          break;
                        }
                      } // round trip
                    } else if (typeOfTripSelected == 0) {

                      for(FlightRouteObject route in flight.routes) {

                        if (route.cityTo != flight.cityTo) {
                          a2b++;
                        } else {
                          break;
                        }
                      }

                      for(FlightRouteObject route in flight.routes.reversed) {

                        if (route.cityFrom != flight.cityTo) {
                          b2a++;
                        } else {
                          break;
                        }
                      }
                    }
                    
                    return Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top : 10),
                      decoration: BoxDecoration(
                              color: AppTheme.getTheme().backgroundColor,
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: AppTheme.getTheme().dividerColor, offset: Offset(0, 2), blurRadius: 8.0),
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
                                                padding: EdgeInsets.only(left: 16.0 , top :14, bottom : 14),
                                                width: MediaQuery.of(context).size.width/2,
                                                  child: Text(formatDates.format(flight.localDeparture)+" | Departure",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                ),

                                              
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(left:20, top:6),
                                                    child: Container(
                                                      width: 1,
                                                      height: 120,
                                                      color: Colors.grey.withOpacity(1),
                                                    ),
                                                  ),

                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(                   
                                                        padding: EdgeInsets.only(left:10, top:5, bottom: 10),
                                                        margin: EdgeInsets.only(bottom:8),
                                                        width: MediaQuery.of(context).size.width/2,
                                                          child: Text(formatTime.format(flight.routes[0].localDeparture)+" "+ flight.routes[0].flyFrom+" ("+ flight.routes[0].cityFrom +")",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w800
                                                            ),
                                                          ),
                                                        ),

                                                      Row (
                                                        children: <Widget>[
                                                          Container(     
                                                            margin: EdgeInsets.only(left: 10),
                                                            padding: EdgeInsets.only(top:3, bottom:3, left:5, right: 5),
                                                            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.6)),
                                                              child: Text(flight.durationDeparture,
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors.lightBlue,
                                                                  fontWeight: FontWeight.w800
                                                                ),
                                                              ),
                                                            ),

                                                          Container(
                                                            margin: EdgeInsets.only(left : 10, right: 5),
                                                            child: Image.network('https://storage.googleapis.com/joinflyline/images/airlines/${flight.routes[0].airline}.png', width: 20.0, height: 20.0),),

                                                          Container(
                                                            margin: EdgeInsets.only(left : 5, right: 5),
                                                            child: Image.network('https://storage.googleapis.com/joinflyline/images/airlines/${flight.routes[0].airline}.png', width: 20.0, height: 20.0),),

                                                           Container(
                                                             margin: EdgeInsets.only(left: 5),
                                                             padding: EdgeInsets.only(top:3, bottom: 3, left:5, right: 5),
                                                             decoration: BoxDecoration(color: Colors.grey.withOpacity(0.6)),
                                                               child: Text(
                                                                 (
                                                                   a2b > 0 ?
                                                                   "$a2b Stopover" :
                                                                   "Direct"
                                                                 ),
                                                                 textAlign: TextAlign.start,
                                                                 style: TextStyle(
                                                                   fontSize: 14,
                                                                   color: Colors.lightBlue,
                                                                   fontWeight: FontWeight.w800
                                                                 ),
                                                               ),
                                                             ),

                                                        ],
                                                      ),

                                                      Container(
                                                            margin: EdgeInsets.only(left: 10, top : 10),
                                                            padding: EdgeInsets.only(top:3, bottom: 3, left:5, right: 5),
                                                            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.6)),
                                                              child: Text(selectedClassOfService,
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors.lightBlue,
                                                                  fontWeight: FontWeight.w800
                                                                ),
                                                              ),
                                                            ),


                                                    Container(
                                                        padding: EdgeInsets.only(left:10, top:20),
                                                        margin: EdgeInsets.only(bottom:3),
                                                        width: MediaQuery.of(context).size.width/2,
                                                          child: Text(formatTime.format(flight.routes[0].localArrival)+" "+ flight.routes[0].flyTo+" ("+ flight.routes[0].cityTo +")",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w800
                                                            ),
                                                          ),
                                                        ),
                                                  ],)


                                                ],
                                                ),



                                            ],
                                          ),

                                        ],
                                      ),
                                      ),
                            (typeOfTripSelected == 1 ? Container() :
                              Container(

                                padding: EdgeInsets.only(left:16, top : 20, bottom: 10),

                                width: MediaQuery.of(context).size.width/2,
                                child: Text(flight.nightsInDest.toString()+" nights in "+flight.cityTo,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                            ),
                            (typeOfTripSelected == 1 ? Container() :
                              Container(

                              child: Row(
                                children: <Widget>[

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 16.0, top :14, bottom : 14),
                                        width: MediaQuery.of(context).size.width/2,
                                        child: Text(formatDates.format(startDate)+" | Return",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ),


                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(left:20, top:6),
                                            child: Container(
                                              width: 1,
                                              height: 120,
                                              color: Colors.grey.withOpacity(0.8),
                                            ),
                                          ),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left:10, top:5, bottom: 10),
                                                margin: EdgeInsets.only(bottom:8),
                                                width: MediaQuery.of(context).size.width/2,
                                                child: Text(formatTime.format(flight.routes[1].localDeparture)+" "+ flight.routes[1].flyFrom+" ("+ flight.routes[1].cityFrom +")",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w800
                                                  ),
                                                ),
                                              ),

                                              Row (
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(left: 10),
                                                    padding: EdgeInsets.only(top:3, bottom:3, left:5, right: 5),
                                                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.6)),
                                                    child: Text(flight.durationReturn,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.lightBlue,
                                                          fontWeight: FontWeight.w800
                                                      ),
                                                    ),
                                                  ),

                                                  Container(
                                                    margin: EdgeInsets.only(left : 10, right: 5),
                                                    child: Image.network('https://storage.googleapis.com/joinflyline/images/airlines/${flight.routes[1].airline}.png', width: 20.0, height: 20.0),),

                                                  Container(
                                                    margin: EdgeInsets.only(left : 5, right: 5),
                                                    child: Image.network('https://storage.googleapis.com/joinflyline/images/airlines/${flight.routes[1].airline}.png', width: 20.0, height: 20.0),),


                                                  Container(
                                                    margin: EdgeInsets.only(left: 5),
                                                    padding: EdgeInsets.only(top:3, bottom: 3, left:5, right: 5),
                                                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.6)),
                                                    child: Text(
                                                      (
                                                          b2a > 0 ?
                                                          "$b2a Stopover" :
                                                          "Direct"
                                                      ),
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.lightBlue,
                                                          fontWeight: FontWeight.w800
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),

                                              Container(
                                                margin: EdgeInsets.only(left: 10, top : 10),
                                                padding: EdgeInsets.only(top:3, bottom: 3, left:5, right: 5),
                                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.6)),
                                                child: Text(selectedClassOfService,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.lightBlue,
                                                      fontWeight: FontWeight.w800
                                                  ),
                                                ),
                                              ),


                                              Container(
                                                padding: EdgeInsets.only(left:10, top:20),
                                                margin: EdgeInsets.only(bottom:3),
                                                width: MediaQuery.of(context).size.width/2,
                                                child: Text(formatTime.format(flight.routes[1].localArrival)+" "+ flight.routes[1].flyTo+" ("+ flight.routes[1].cityTo +")",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w800
                                                  ),
                                                ),
                                              ),


                                            ],)


                                        ],
                                      ),



                                    ],
                                  ),






                                ],
                              ),
                            )
                            )

                    ],
                  ),

        );
                  },
                )
                )
                ),
              );

            }else{
              return Container();
            }

          },
      )
    );
    
    
  }

  Widget getSearchButton() {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16, top: 10),
      color: Colors.lightBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text("Search Flights",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold)),
            onPressed: () {
              setState(() {
                this._isSearched = false;
              });

              try {
                flyLinebloc.searchFlight(
                  selectedDeparture.type+":"+selectedDeparture.code,
                  selectedArrival.type+":"+selectedArrival.code, 
                  formatAllDay.format(startDate),
                  formatAllDay.format(startDate),
                  typeOfTripSelected==0 ? "round" : "oneway",
                  formatAllDay.format(endDate),
                  formatAllDay.format(endDate),
                  ad.toString(),
                  "0",
                  "0",
                  selectedClassOfServiceValue,
                  "USD",
                  "5");
                  }catch (e){
                    print(e);
                  }
            },
          ),
        ],
      ),
    );
  }

  Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      showDemoDialog(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 4, right: 4, top: 4, bottom: 4),
                      child: InkWell(
                        onTap: () async {
                          final List<DateTime> picked =
                              await DateRangePicker.showDatePicker(
                                  context: context,
                                  initialFirstDate: new DateTime.now(),
                                  initialLastDate: (new DateTime.now())
                                      .add(new Duration(days: 7)),
                                  firstDate: new DateTime(2000),
                                  lastDate: new DateTime.now()
                                      .add(Duration(days: 365 * 2)));
                          if (picked != null && picked.length == 2) {
                            setState(() {
                              startDate = picked[0];
                              endDate = picked[1];
                            });
                          } else if (picked != null && picked.length == 2) {
                            setState(() {
                              startDate = picked[0];
                            });
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                typeOfTripSelected == 0
                                    ? "Trip Date(s)"
                                    : "Trip Date",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              typeOfTripSelected == 0
                                  ? "${formatDates.format(startDate)} - ${formatDates.format(endDate)}"
                                  : "${formatDates.format(startDate)}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => RoomPopupView(
                          ad: 2,
                          room: 1,
                          ch: 0,
                          barrierDismissible: true,
                          onChnage: (ro, a, c) {
                            setState(() {
                              room = ro;
                              ad = a;
                            });
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 4, right: 4, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Passengers",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "$ad Adults",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => RoomPopupView(
                          ad: 2,
                          room: 1,
                          ch: 0,
                          barrierDismissible: true,
                          onChnage: (ro, a, c) {
                            setState(() {
                              room = ro;
                              ad = a;
                            });
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 4, right: 4, top: 4, bottom: 4),
                      child: InkWell(
                        onTap: () {
                          SelectDialog.showModal<String>(context,
                              searchBoxDecoration:
                                  InputDecoration(hintText: "Pick one"),
                              label: "Class of Service",
                              selectedValue: selectedClassOfService,
                              items: classOfServicesList,
                              onChange: (String selected) {
                            setState(() {
                              selectedClassOfService = selected;
                              selectedClassOfServiceValue =
                                  classOfServicesValueList[
                                      classOfServicesList.indexOf(selected)];
                            });
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Class of Service",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              selectedClassOfService,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSearchBarUI() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.getTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme.getTheme().dividerColor,
                  offset: Offset(0, 2),
                  blurRadius: 8.0),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    typeOfTripSelected = 0;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text(
                    "Round-Trip",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: (typeOfTripSelected == 0)
                            ? Colors.black
                            : Colors.grey,
                        fontWeight: (typeOfTripSelected == 0)
                            ? FontWeight.w600
                            : FontWeight.w400),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  width: 1,
                  height: 45,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    typeOfTripSelected = 1;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text(
                    "One-Way",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: (typeOfTripSelected == 1)
                            ? Colors.black
                            : Colors.grey,
                        fontWeight: (typeOfTripSelected == 1)
                            ? FontWeight.w600
                            : FontWeight.w400),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  width: 1,
                  height: 45,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 0),
                      child: Text(
                        "Coming soon",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 0),
                      child: TextField(
                        textAlign: TextAlign.center,
                        onChanged: (String txt) {},
                        onTap: () {},
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        cursorColor: AppTheme.getTheme().primaryColor,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "Nomad",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.getTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme.getTheme().dividerColor,
                  offset: Offset(0, 2),
                  blurRadius: 8.0),
            ],
          ),
          child: Container(
            width: MediaQuery.of(context).size.width / 4,
            padding: EdgeInsets.only(left: 10),
            child: LocationSearchUI("Departure", true,
                notifyParent: refreshDepartureValue),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.getTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme.getTheme().dividerColor,
                  offset: Offset(0, 2),
                  blurRadius: 8.0),
            ],
          ),
          child: Container(
            width: MediaQuery.of(context).size.width / 4,
            padding: EdgeInsets.only(left: 10),
            child: LocationSearchUI("Arrival", false,
                notifyParent: refreshDepartureValue,
                destination: widget.destination),
          ),
        ),
      ],
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.getTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: AppTheme.getTheme().dividerColor,
                    offset: Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
            color: AppTheme.getTheme().backgroundColor,
            child: StreamBuilder<List<FlightInformationObject>>(
              stream: flyLinebloc.flightsItems.stream,
              builder: (context,
                  AsyncSnapshot<List<FlightInformationObject>> snapshot) {
                if (snapshot.data != null && snapshot.data.isNotEmpty) {
                  var listOfFlights = snapshot.data;

                  return Padding(
                    padding:
                    const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              listOfFlights.length.toString() + " flights found",
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FiltersScreen(),
                                    fullscreenDialog: true),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.sort,
                                        color: AppTheme.getTheme().primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            )),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  void showDemoDialog({BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            if (startData != null && endData != null) {
              startDate = startData;
              endDate = endData;
            }
          });
        },
        onCancelClick: () {},
      ),
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
                "Explore",
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

  refreshDepartureValue(value, isDeparture) {
    if (this.mounted)
      setState(() {
        if (isDeparture)
          selectedDeparture = value;
        else
          selectedArrival = value;
      });
  }
}

class LocationSearchUI extends StatefulWidget {
  final Function(LocationObject value, bool type) notifyParent;
  final title;
  final isDeparture;
  final destination;

  LocationSearchUI(this.title, this.isDeparture,
      {Key key, @required this.notifyParent, this.destination})
      : super(key: key);

  @override
  _LocationSearchUIState createState() => _LocationSearchUIState(title);
}

class _LocationSearchUIState extends State<LocationSearchUI>
    with TickerProviderStateMixin {
  var title;

  _LocationSearchUIState(var item) {
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleAutocompleteFormField<LocationObject>(
      itemToString: (location) =>
          location != null ? location.code : widget.destination,
      textAlign: TextAlign.start,
      itemBuilder: (context, location) => Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(location.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(location.code)
        ]),
      ),
      onSearch: (search) async {
        if (search.length > 0) {
          var response = flyLinebloc.locationQuery(search);
          return response;
        } else
          return null;
      },
      onChanged: (value) => widget.notifyParent(value, widget.isDeparture),
      onSaved: (value) => widget.notifyParent(value, widget.isDeparture),
      validator: (location) =>
          location.name == null ? 'Invalid location.' : null,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      decoration: new InputDecoration(
        border: InputBorder.none,
        hintText: widget.title + " City or Airport 1",
      ),
    );
  }
}

class MapHotelListView extends StatelessWidget {
  final VoidCallback callback;
  final HotelListData hotelData;

  const MapHotelListView({Key key, this.hotelData, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 8, top: 8, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.getTheme().backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppTheme.getTheme().dividerColor,
              offset: Offset(4, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: AspectRatio(
            aspectRatio: 2.7,
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 0.90,
                      child: Image.asset(
                        hotelData.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              hotelData.titleTxt,
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              hotelData.subTxt,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(0.8)),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.mapMarkerAlt,
                                            size: 12,
                                            color: AppTheme.getTheme()
                                                .primaryColor,
                                          ),
                                          Text(
                                            " ${hotelData.dist.toStringAsFixed(1)} km to city",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey
                                                    .withOpacity(0.8)),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: SmoothStarRating(
                                          allowHalfRating: true,
                                          starCount: 5,
                                          rating: hotelData.rating,
                                          size: 20,
                                          color:
                                              AppTheme.getTheme().primaryColor,
                                          borderColor:
                                              AppTheme.getTheme().primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "\$${hotelData.perNight}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                        ),
                                      ),
                                      Text(
                                        "/per night",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.grey.withOpacity(0.8)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor:
                        AppTheme.getTheme().primaryColor.withOpacity(0.1),
                    onTap: () {
                      callback();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
