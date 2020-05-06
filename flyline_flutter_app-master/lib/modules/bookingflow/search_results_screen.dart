import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart' as intl;
import 'package:motel/helper/helper.dart';
import 'package:motel/models/filterExplore.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/models/locations.dart';
import 'package:motel/modules/bookingflow/trip_details.dart' as trip_details;
import 'package:motel/network/blocs.dart';
import 'package:motel/widgets/app_bar_date_dep_arr.dart';
import 'package:motel/widgets/app_bar_from_to.dart';
import 'package:motel/widgets/app_bar_pop_icon.dart';

const kLabelTextColor = Color(0xFF3a3f5c);
const kPlaceHolderColor = Color(0xFFa2a1b4);

enum _TABS { ROUND_TRIP, ONE_WAY, NOMAD }

class SearchResults extends StatefulWidget {
  final List<FlightRouteObject> routes;
  final int typeOfTripSelected;
  final String departure;
  final String arrival;
  final String departureCode;
  final String arrivalCode;
  final DateTime startDate;
  final DateTime endDate;
  final String flyingFrom;
  final String flyingTo;
  final String depDate;
  final String arrDate;

  SearchResults(
      {this.typeOfTripSelected,
      this.departure,
      this.arrival,
      this.departureCode,
      this.arrivalCode,
      this.startDate,
      this.endDate,
      this.flyingFrom,
      this.flyingTo,
      this.depDate,
      this.arrDate,
      this.routes});

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults>
    with TickerProviderStateMixin {
  //ProgressBar _searchProgressBar;

//  bool press = false;

  bool _isSearched = false;
  bool _clickedSearch = false;
  final myController = TextEditingController();
  AnimationController animationController;
  AnimationController _animationController;
  //var hotelList = HotelListData.hotelList;
  ScrollController scrollController = ScrollController();
  int room = 1;
  int ad = 1;
  int children = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 5));
  bool isMap = false;
  _TABS activeTab = _TABS.ROUND_TRIP;
  String departureDate;
  String arrivalDate;
  int adults = 0;
  int kids = 0;
  String cabin = "economy";

  final formatDates = intl.DateFormat("dd MMM ");
  final formatTime = intl.DateFormat("hh : mm a");
  final formatAllDay = intl.DateFormat("dd/MM/yyyy");

  //var typeOfTripSelected = 0;
  LocationObject selectedDeparture;
  LocationObject selectedArrival;

  LocationObject departure;
  LocationObject arrival;
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

  int offset = 0;
  int perPage = 20;
  List<FlightInformationObject> originalFlights = List();
  List<FlightInformationObject> listOfFlights = List();
  List<bool> _clickFlight = List();
  bool _loadMore = false;
  bool _isLoading = false;
  bool _displayLoadMore = true;

  Map<String, dynamic> airlineCodes;

  FilterExplore filterExplore;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey stickyKey = GlobalKey();
  double heightBox = -1;

  @override
  void initState() {
    offset = 0;
    originalFlights = List();
    listOfFlights = List();
    _clickedSearch = true;
    _isLoading = true;
    listOfFlights.add(null);
    _displayLoadMore = true;

    // _searchProgressBar = ProgressBar();
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

    this.getCity();
    this.getAirlineCodes();
    super.initState();

    flyLinebloc.flightsItems.stream
        .listen((List<FlightInformationObject> onData) {
      if (onData != null) {
        if (_clickedSearch || _loadMore) {
          print('trigger');
          setState(() {
            this._loadMore = false;
            this._clickedSearch = false;
            this._isSearched = true;
            if (listOfFlights.length != 0) {
              if (listOfFlights[listOfFlights.length - 1] == null) {
                listOfFlights.removeLast();
              }
            }
            this._isLoading = false;
            originalFlights.addAll(onData);
            _displayLoadMore = true;
            if ((offset + perPage) > originalFlights.length) {
              print("offset:" + offset.toString());
              print("length:" + originalFlights.length.toString());
              listOfFlights.addAll(
                  originalFlights.getRange(offset, originalFlights.length));
              _displayLoadMore = false;
            } else {
              listOfFlights
                  .addAll(originalFlights.getRange(offset, offset + perPage));
            }
            _clickFlight = List(listOfFlights.length);
            print(listOfFlights.length);
            offset = offset + perPage;
          });
        }
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((_) => this.getKey());
  }

  void getKey() {
    var keyContext = stickyKey.currentContext;
    if (keyContext != null) {
      // widget is visible
      final box = keyContext.findRenderObject() as RenderBox;

      setState(() {
        heightBox = box.size.height;
      });
      print("height" + box.size.height.toString());
    }
  }

  void getAirlineCodes() async {
    airlineCodes = json.decode(await DefaultAssetBundle.of(context)
        .loadString("jsonFile/airline_codes.json"));
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void getCity() async {
    startDate = widget.startDate ?? DateTime.now();
    endDate = widget.endDate ?? DateTime.now().add(Duration(days: 2));

    if (widget.departure != null) {
      selectedDeparture = departure = LocationObject(widget.departureCode,
          widget.departureCode, "city", widget.departure, "", null);
    }

    if (widget.arrival != null) {
      selectedArrival = arrival = LocationObject(widget.arrivalCode,
          widget.arrivalCode, "city", widget.arrival, "", null);
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F5FA),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: getAppBarUI(),
            ),
            getFlightDetails(),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
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
      var flightTime = Helper.duration(route.duration);
      var flightduration = flightTime.toString();
      lists.add(
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: route.flyTo + '  ',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
            TextSpan(
                text: flightduration,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )
                //color: Color(0xFFFF3A27)),
                ),
          ]),
        ),
        // Text(
        //   route.flyTo + ' ' + Helper.duration(route.duration),
        //   textAlign: TextAlign.start,
        //   style: TextStyle(
        //       fontSize: 11,
        //       fontWeight: FontWeight.w600,
        //       color: Color(0xFFFF3A27)),
        // ),
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

  Widget getFlightDetails() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          scrollDirection: Axis.vertical,
          itemCount:
              offset != 0 ? listOfFlights.length + 1 : listOfFlights.length,
          itemBuilder: (context, index) {
            // print(widget.typeOfTripSelected);
            if (index != listOfFlights.length) {
              var flight = listOfFlights[index];

              if (flight == null && _isLoading) {
                // _showSendingProgressBar();
                //       Future.delayed(const Duration(milliseconds: 5000), () {
                //       setState(() {
                //           _hideSendingProgressBar();
                //       });
                //       });
                return null;
                // Center(child:
                //  Loader()
                // CircularProgressIndicator()
                //   valueColor: AlwaysStoppedAnimation<Color>(
                //       const Color(0xFF00AFF5)),
                // ),
                //  );
              }
              // else {
              //   _hideSendingProgressBar();
              // }

              // initialize
              int a2b = 0;
              int b2a = 0;

              List<FlightRouteObject> departures = List();
              List<String> departureStopOverCity = List();
              List<FlightRouteObject> returns = List();
              List<String> returnStopOverCity = List();

              // one way
              if (widget.typeOfTripSelected == 1) {
                for (FlightRouteObject route in flight.routes) {
                  departures.add(route);
                  if (route.cityTo != flight.cityTo) {
                    departureStopOverCity.add(route.cityTo);
                    a2b++;
                  } else {
                    break;
                  }
                } // round trip
              } else if (widget.typeOfTripSelected == 0) {
                for (FlightRouteObject route in flight.routes) {
                  departures.add(route);
                  if (route.cityTo != flight.cityTo) {
                    departureStopOverCity.add(route.cityTo);
                    a2b++;
                  } else {
                    break;
                  }
                }

                for (FlightRouteObject route in flight.routes.reversed) {
                  returns.add(route);

                  if (route.cityFrom != flight.cityTo) {
                    returnStopOverCity.add(route.cityTo);
                    b2a++;
                  } else {
                    break;
                  }
                }
              }

              return InkWell(
                child: Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  bottom: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                        text: "\$ " +
                                            flight.price.toStringAsFixed(0),
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xff0e3178),
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "   FlyLine Fare",
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xFF62C6F4),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ])),
                                    (a2b > 1
                                        ? getFlightDetailItemsLogos(
                                            departures, returns)
                                        : Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle),
                                              alignment: Alignment.topRight,
                                              child: Image.network(
                                                  'https://storage.googleapis.com/joinflyline/images/airlines/${flight.routes[0].airline}.png',
                                                  width: 24.0,
                                                  height: 24.0),
                                            ),
                                          )),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text:
                                                  departures[0].flyFrom + " - ",
                                              style: TextStyle(
                                                fontFamily: 'Gilroy',
                                                color: Color(0xffb1b1b1),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                            TextSpan(
                                              text: departures[
                                                      departures.length - 1]
                                                  .flyTo,
                                              style: TextStyle(
                                                fontFamily: 'Gilroy',
                                                color: Color(0xffb1b1b1),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                      ),
                                      Text(
                                        "Travel time",
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xffb1b1b1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      Text(
                                        (a2b > 0
                                            ? (a2b > 1
                                                ? "$a2b Stopovers"
                                                : "$a2b Stopover")
                                            : "Non-Stop"),
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xffb1b1b1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10.0, top: 11.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: formatTime.format(
                                                        departures[0]
                                                            .localDeparture) +
                                                    " - ",
                                                style: TextStyle(
                                                  fontFamily: 'Gilroy',
                                                  color: Color(0xff000000),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                              TextSpan(
                                                text: formatTime.format(
                                                        departures[departures
                                                                    .length -
                                                                1]
                                                            .localArrival) +
                                                    " ",
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
                                        Text(
                                          flight.durationDeparture,
                                          style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            color: Color(0xff000000),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        (a2b > 0
                                            ? (a2b > 1
                                                ? getFlightDetailItems(
                                                    departures, returns)
                                                : getFlightDetailItemsOneStop(
                                                    departures, returns))
                                            : Text(
                                                "Direct",
                                                style: TextStyle(
                                                  fontFamily: 'Gilroy',
                                                  color: Color(0xff000000),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              )),
                                      ],
                                    ),
                                  ),
                                  (widget.typeOfTripSelected == 1
                                      ? Container()
                                      : Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 6,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    child: RichText(
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                          text: returns[returns
                                                                          .length -
                                                                      1]
                                                                  .flyFrom +
                                                              " - ",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Gilroy',
                                                            color: Color(
                                                                0xffb1b1b1),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: departures[0]
                                                              .flyFrom,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Gilroy',
                                                            color: Color(
                                                                0xffb1b1b1),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 60,
                                                  ),
                                                  Text(
                                                    "Travel time",
                                                    style: TextStyle(
                                                      fontFamily: 'Gilroy',
                                                      color: Color(0xffb1b1b1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                  Text(
                                                    (a2b > 0
                                                        ? (a2b > 1
                                                            ? "$a2b Stopovers"
                                                            : "$a2b Stopover")
                                                        : "Non-Stop"),
                                                    style: TextStyle(
                                                      fontFamily: 'Gilroy',
                                                      color: Color(0xffb1b1b1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    child: RichText(
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                          text: formatTime.format(
                                                                  returns[returns
                                                                              .length -
                                                                          1]
                                                                      .localDeparture) +
                                                              " - ",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Gilroy',
                                                            color: Color(
                                                                0xff000000),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: formatTime
                                                              .format(returns[0]
                                                                  .localArrival),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Gilroy',
                                                            color: Color(
                                                                0xff000000),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                  ),
                                                  Text(
                                                    flight.durationReturn,
                                                    style: TextStyle(
                                                      fontFamily: 'Gilroy',
                                                      color: Color(0xff000000),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                  (a2b > 0
                                                      ? (a2b > 1
                                                          ? getFlightDetailItems(
                                                              departures,
                                                              returns)
                                                          : getFlightDetailItemsOneStop(
                                                              departures,
                                                              returns))
                                                      : Text(
                                                          "Direct",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Gilroy',
                                                            color: Color(
                                                                0xff000000),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                        )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => trip_details.HotelHomeScreen(
                            depDate: widget.depDate,
                            arrDate: widget.arrDate,
                            routes: flight.routes,
                            ad: this.ad,
                            ch: this.children,
                            typeOfTripSelected: this.widget.typeOfTripSelected,
                            selectedClassOfService: this.selectedClassOfService,
                            flight: flight,
                            bookingToken: flight.bookingToken,
                            retailInfo: flight.raw)),
                  );
                },
              );
            } else {
              return getLoadMoreButton();
            }
          },
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    List<FlightRouteObject> departures = List();
    List<String> departureStopOverCity = List();
    List<FlightRouteObject> returns = List();
    List<String> returnStopOverCity = List();
    var flight = listOfFlights[0];

    if (widget.typeOfTripSelected == 1) {
      for (FlightRouteObject route in flight.routes) {
        departures.add(route);
        if (route.cityTo != flight.cityTo) {
          departureStopOverCity.add(route.cityTo);
        } else {
          break;
        }
      } // round trip
    } else if (widget.typeOfTripSelected == 0) {
      for (FlightRouteObject route in flight.routes) {
        departures.add(route);
        if (route.cityTo != flight.cityTo) {
          departureStopOverCity.add(route.cityTo);
        } else {
          break;
        }
      }

      for (FlightRouteObject route in flight.routes.reversed) {
        returns.add(route);
        if (route.cityFrom != flight.cityTo) {
          returnStopOverCity.add(route.cityTo);
        } else {
          break;
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AppBarPopIcon(),
            Expanded(
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    AppBarFromTo(
                      flyFrom: flight.flyFrom,
                      flyTo: flight.flyTo,
                    ),
                    AppBarDateDepArr(
                      depDate: widget.depDate,
                      arrDate: widget.arrDate,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                height: AppBar().preferredSize.height + 10,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      this.handleFilter();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF7F9FC),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/filter.png',
                          width: 18,
                          height: 23,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getLoadMoreButton() {
    if (!_displayLoadMore) {
      return Container();
    }
    return Column(children: <Widget>[
      InkWell(
        child: Container(
          // padding: EdgeInsets.all(12),
          height: 40,
          // margin: EdgeInsets.only(left: 16.0, right: 16, top: 30),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: Center(
            child: Text("Load More",
                style: TextStyle(
                    color: const Color(0xFF00AFF5),
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        onTap: () {
          if (!_loadMore
              //&&
              //selectedDeparture != null &&
              //selectedArrival != null
              ) {
            setState(() {
              _loadMore = true;
              _isLoading = true;
            });

            if (filterExplore != null) {
              var items = this.originalFlights.where((i) {
                var airlineBool = filterExplore.airlines.map((item) =>
                    item["isSelected"] && i.airlines.contains(item["code"]));

                return i.price >= filterExplore.priceFrom.round() &&
                    i.price <= filterExplore.priceTo.round() &&
                    airlineBool.contains(true);
              }).toList();

              print(items.length);
              if ((offset + perPage) > items.length) {
                listOfFlights.addAll(items.getRange(offset, items.length));
                _displayLoadMore = false;
              } else {
                listOfFlights.addAll(items.getRange(offset, offset + perPage));
                _displayLoadMore = true;
              }
            } else {
              if ((offset + perPage) > originalFlights.length) {
                listOfFlights.addAll(
                    originalFlights.getRange(offset, originalFlights.length));
                _displayLoadMore = false;
              } else {
                listOfFlights
                    .addAll(originalFlights.getRange(offset, offset + perPage));
                _displayLoadMore = true;
              }
            }
            setState(() {
              _clickFlight = List(listOfFlights.length);
              offset = offset + perPage;
              _loadMore = false;
              _isLoading = false;
            });
          }
        },
      ),
      SizedBox(height: 38)
    ]);
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

  handleFilter() {
    if (originalFlights.length != 0) {
      if (filterExplore == null) {
        filterExplore = FilterExplore(this.originalFlights, this.airlineCodes);
      }

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => FiltersScreen(
      //             filterExplore: filterExplore,
      //             callback: (FilterExplore f) => filter(f),
      //           ),
      //       fullscreenDialog: true),
      // );
    }
  }

  void filter(FilterExplore filter) {
    var stop = filter.accomodationListData[0].isSelected
        ? 1
        : filter.accomodationListData[1].isSelected
            ? 2
            : filter.accomodationListData[2].isSelected ? 3 : 0;

    var items = this.originalFlights.where((i) {
      var airlineBool = filter.airlines
          .where((item) =>
              item["isSelected"] &&
              item["title"] != null &&
              i.airlines.contains(item["code"]))
          .toList();

      int a2b = i.routes.where((r) => r.returnFlight == 0).toList().length;
      int b2a = i.routes.where((r) => r.returnFlight == 1).toList().length;

      return (i.price >= filter.priceFrom.round() &&
              i.price <= filter.priceTo.round()) &&
          airlineBool.length != 0 &&
          (stop == 0 || (stop > 0 && (a2b == stop || b2a == stop)));
    }).toList();

    setState(() {
      listOfFlights = List();
      _displayLoadMore = true;
      if (offset > items.length) {
        listOfFlights.addAll(items.getRange(0, items.length));
        _displayLoadMore = false;
      } else {
        print(offset - perPage);
        listOfFlights.addAll(items.getRange(0, offset - perPage));
      }
      filterExplore = filter;
      _clickFlight = List(listOfFlights.length);
    });
  }
}

class Loader extends StatefulWidget {
  final double radius;
  final double dotRadius;

  Loader({this.radius = 30.0, this.dotRadius = 6.0});

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  Animation<double> animationRotation;
  Animation<double> animationRadiusIn;
  Animation<double> animationRadiusOut;
  AnimationController controller;

  double radius;
  double dotRadius;

  @override
  void initState() {
    super.initState();

    radius = widget.radius;
    dotRadius = widget.dotRadius;

    print(dotRadius);

    controller = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 3000),
        vsync: this);

    animationRotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    animationRadiusIn = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn),
      ),
    );

    animationRadiusOut = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );

    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0)
          radius = widget.radius * animationRadiusIn.value;
        else if (controller.value >= 0.0 && controller.value <= 0.25)
          radius = widget.radius * animationRadiusOut.value;
      });
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      //color: Colors.black12,
      child: Center(
        child: RotationTransition(
          turns: animationRotation,
          child: Container(
            //color: Colors.limeAccent,
            child: Center(
              child: Stack(
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(0.0, 0.0),
                    child: Dot(
                      radius: radius,
                      color: Colors.black12,
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.amber,
                    ),
                    offset: Offset(
                      radius * cos(0.0),
                      radius * sin(0.0),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.deepOrangeAccent,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 1 * pi / 4),
                      radius * sin(0.0 + 1 * pi / 4),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.pinkAccent,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 2 * pi / 4),
                      radius * sin(0.0 + 2 * pi / 4),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.purple,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 3 * pi / 4),
                      radius * sin(0.0 + 3 * pi / 4),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.yellow,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 4 * pi / 4),
                      radius * sin(0.0 + 4 * pi / 4),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.lightGreen,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 5 * pi / 4),
                      radius * sin(0.0 + 5 * pi / 4),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.orangeAccent,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 6 * pi / 4),
                      radius * sin(0.0 + 6 * pi / 4),
                    ),
                  ),
                  Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: Colors.blueAccent,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 7 * pi / 4),
                      radius * sin(0.0 + 7 * pi / 4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
