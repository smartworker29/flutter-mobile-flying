import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as ui_help;
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:motel/helper/helper.dart';
import 'package:motel/modules/datepicker/datepicker_screen.dart';
import 'package:motel/modules/bookingflow/search_results_screen.dart';
import 'package:motel/modules/login/loginScreen.dart';
import 'package:motel/modules/menuitems/help_center.dart';
import 'package:motel/modules/menuitems/account_details.dart';
import 'package:motel/modules/menuitems/deal_feed.dart';
import 'package:motel/modules/menuitems/membership_plans.dart';
import 'package:motel/modules/menuitems/payment.dart';
import 'package:motel/modules/menuitems/privacy_policy.dart';
import 'package:motel/modules/menuitems/terms_of_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../appTheme.dart';
import '../../models/flight_information.dart';
import '../../models/locations.dart';
import '../../network/blocs.dart';
import '../calendar/calendarPopupView.dart';

const kLabelTextColor = Color(0xff0e3178);
const kPlaceHolderColor = Color(0xFFa2a1b4);

enum _TABS { ROUND_TRIP, ONE_WAY, NOMAD }

class HotelHomeScreen extends StatefulWidget {
  final String departure;
  final String arrival;
  final String departureCode;
  final String arrivalCode;
  final DateTime startDate;
  final DateTime endDate;

  HotelHomeScreen(
      {Key key,
      this.arrival,
      this.departure,
      this.arrivalCode,
      this.departureCode,
      this.startDate,
      this.endDate})
      : super(key: key);

  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {
  ProgressBar _searchProgressBar;
  ButtonMarker selectedButton = ButtonMarker.user;

//  bool press = false;

  bool _isSearched = false;
  bool _clickedSearch = false;
  final myController = TextEditingController();
  AnimationController animationController;
  AnimationController _animationController;
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
  int adults = 1;
  int kids = 0;
  String cabin = "economy";

  final formatDates = intl.DateFormat("dd MMM");
  final formatTime = intl.DateFormat("hh : mm a");
  final formatAllDay = intl.DateFormat("dd/MM/yyyy");

  var typeOfTripSelected = 0;

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

  int offset = 20;
  int perPage = 20;
  List<FlightInformationObject> originalFlights = List();
  List<FlightInformationObject> listOfFlights = List();
  List<FlightRouteObject> returns = List();
  List<bool> _clickFlight = List();
  bool _loadMore = false;
  bool _isLoading = false;
  bool _displayLoadMore = true;

  Map<String, dynamic> airlineCodes;

  var filterExplore;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey stickyKey = GlobalKey();
  double heightBox = -1;

  @override
  void initState() {
    _searchProgressBar = ProgressBar();
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
  }

  @override
  void dispose() {
    _searchProgressBar.hide();
    this._clickedSearch = false;
    super.dispose();
  }

  void showSendingProgressBar() {
    _searchProgressBar.show(context);
  }

  void hideSendingProgressBar() {
    _searchProgressBar.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _drawerbuild(context),
      body: Column(
        children: <Widget>[
          getAppBarUI(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                selectJourney(),
                tabsHeader(),
                tabsContent(),
              ],
            ),
          )
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  List<Widget> loadItems(List<FlightRouteObject> routes, String type,
      FlightInformationObject flight) {
    List<Widget> lists = List();
    lists.add(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 16.0, top: 20, bottom: 10),
          child: Text(
            Helper.getDateViaDate(routes[0].localDeparture, "dd MMM") +
                " | " +
                type +
                " | " +
                routes[0].cityFrom +
                ' - ' +
                routes[routes.length - 1].cityTo +
                " | " +
                (type == "Departure"
                    ? flight.durationDeparture
                    : flight.durationReturn),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ));
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
                        width: MediaQuery.of(context).size.width - 74,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 10, left: 16),
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
                                    padding: EdgeInsets.only(left: 10, top: 14),
                                    margin: EdgeInsets.only(bottom: 3),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Helper.getDateViaDate(
                                              route.localDeparture, "hh:mm a") +
                                          " - " +
                                          Helper.getDateViaDate(
                                              route.localArrival, "hh:mm a"),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12.8,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10, top: 5),
                                    margin: EdgeInsets.only(bottom: 14),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      // route.cityFrom +
                                      //     " (" +
                                      //     route.flyFrom +
                                      //     ") - " +
                                      route.cityTo +
                                          " (" +
                                          route.flyTo +
                                          ")  Duration: " +
                                          Helper.duration(route.duration),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600),
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
                    ],
                  ),
                ],
              ),
            ),
            (i != routes.length - 1
                ? Container(
                    padding: EdgeInsets.only(left: 26.0, top: 15, bottom: 0),
                    child: Text(
                        Helper.duration(Duration(
                                milliseconds: routes[i + 1]
                                        .localDeparture
                                        .millisecondsSinceEpoch -
                                    route
                                        .localArrival.millisecondsSinceEpoch)) +
                            ' layover',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 12.5)))
                : Container()),
          ],
        ),
      ));
    }
    return lists;
  }

  Widget tabsHeader() {
    return Container(
//        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppTheme.getTheme().dividerColor,
                blurRadius: 3,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    typeOfTripSelected = 0;
                    activeTab = _TABS.ROUND_TRIP;
                  });
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent)),
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(
                          "Round-trip",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                              color: activeTab == _TABS.ROUND_TRIP
                                  ? Color.fromRGBO(0, 174, 239, 1)
                                  : Colors.black12),
                        ),
                        Container(
                          width: 30,
                          margin: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                            boxShadow: activeTab == _TABS.ROUND_TRIP
                                ? [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 174, 239, 0.4),
                                      blurRadius: 6,
                                      offset: Offset(0, -2),
                                    ),
                                  ]
                                : [],
                            border: Border.all(
                                color: activeTab == _TABS.ROUND_TRIP
                                    ? Color.fromRGBO(0, 174, 239, 1)
                                    : Colors.transparent),
                          ),
                        ),
                      ],
                    ))),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    typeOfTripSelected = 1;
                    activeTab = _TABS.ONE_WAY;
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent)),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(
                          "One-way",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                              color: activeTab == _TABS.ONE_WAY
                                  ? Color.fromRGBO(0, 174, 239, 1)
                                  : Colors.black12),
                        ),
                        Container(
                          width: 30,
                          margin: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                            boxShadow: activeTab == _TABS.ONE_WAY
                                ? [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 174, 239, 0.4),
                                      blurRadius: 6,
                                      offset: Offset(0, -2),
                                    ),
                                  ]
                                : [],
                            border: Border.all(
                                color: activeTab == _TABS.ONE_WAY
                                    ? Color.fromRGBO(0, 174, 239, 1)
                                    : Colors.transparent),
                          ),
                        ),
                      ],
                    ))),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    activeTab = _TABS.NOMAD;
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent)),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(
                          "Nomad*",
                          style: TextStyle(
                              color: activeTab == _TABS.NOMAD
                                  ? Color.fromRGBO(0, 174, 239, 1)
                                  : Colors.black12),
                        ),
                        Container(
                          width: 30,
                          margin: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: activeTab == _TABS.NOMAD
                                    ? Color.fromRGBO(0, 174, 239, 1)
                                    : Colors.transparent),
                          ),
                        ),
                      ],
                    ))),
              ),
            ),
          ],
        ));
  }

  double _calculateTextHeight({double fontSize = 16}) {
    final constraints = BoxConstraints(
      maxWidth: 10.0,
      minHeight: 0.0,
      minWidth: 0.0,
    );
    RenderParagraph renderParagraph = RenderParagraph(
      TextSpan(
        text: "Any Text",
        //TextStyle used in autoComplete
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontSize == null ? null : FontWeight.w600),
      ),
      textDirection: ui_help.TextDirection.ltr,
      maxLines: 1,
    );
    renderParagraph.layout(constraints);
    return renderParagraph.getMinIntrinsicHeight(fontSize).ceilToDouble();
  }

  double _calculateTabsHeight() {
    double topPadding = 20;
    double bottomContainerHeight = 30;
    double tabTextHeight = _calculateTextHeight(fontSize: 14);
    return topPadding + bottomContainerHeight + tabTextHeight;
  }

  double _calculateHeight() {
    double screenHeight = _screenHeight();
    double appBarHeight = AppBar().preferredSize.height + 10;
    double screenPadding = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom; //StatusBar + Navigation Buttons
    double textFieldTextHeight = _calculateTextHeight() * 2;
    double textFieldTotalPadding = 15.0 * 2 + 15.0 * 2;
    double heightBetweenBothTextFields = 20.0 + 8; //and bottom padding
    print(
        'screenHeight:$screenHeight\nppBarHeight:$appBarHeight\nscreenPadding:$screenPadding\ntextFieldTextHeight:$textFieldTextHeight\ntextFieldTotalPadding:$textFieldTotalPadding\n_calculateTabsHeight:${_calculateTabsHeight()}');
    return screenHeight -
        (screenPadding +
            appBarHeight +
            textFieldTextHeight +
            textFieldTotalPadding +
            heightBetweenBothTextFields +
            _calculateTabsHeight());
  }

  double _screenHeight() => MediaQuery.of(context).size.height;

  Widget tabsContent() {
    double height = _calculateHeight();
    double spacing = height > 400 ? ((height - 400) / 4) : 20;
    print('Height:$height');
    return (Container(
      color: Color.fromRGBO(247, 249, 252, 1),
      height: height - 6, //MediaQuery.of(context).size.height * 0.50,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 20, top: spacing),
                child: Text(
                  "Trip Date(s)",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gilroy Bold',
                      fontSize: 18,
                      color: kLabelTextColor),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  departureDate != null
                                      ? DateFormat("MM-dd-yyyy")
                                          .format(DateTime.parse(departureDate))
                                      : "Departure",
                                  style: departureDate != null
                                      ? TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Gilroy',
                                          color: Color(0xFF3D415E),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        )
                                      : TextStyle(
                                          // color: kPlaceHolderColor
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Gilroy',
                                          color: Color(0xff3a3f5c),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                ),
                              ),
                              Image.asset("assets/images/calendar.png",
                                  width: 20)
                            ],
                          ),
                        ),
                        onTap: () async {
                          DateResult newDateTime = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DatePickerScreen(
                                    shouldChooseMultipleDates:
                                        activeTab == _TABS.ROUND_TRIP),
                              ));
                          if (newDateTime == null) return;
                          setState(() {
                            departureDate =
                                newDateTime.departureDate.toString();
                            if (activeTab == _TABS.ROUND_TRIP &&
                                newDateTime.returnDate != null)
                              arrivalDate = newDateTime.returnDate.toString();
                          });
                        },
                      ),
                    ),
                    activeTab == _TABS.ONE_WAY
                        ? Container()
                        : Expanded(
                            child: InkWell(
                              child: Container(
                                padding: const EdgeInsets.all(15.0),
                                margin: const EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        arrivalDate != null
                                            ? DateFormat("MM-dd-yyyy").format(
                                                DateTime.parse(
                                                    arrivalDate.toString()))
                                            : "Return",
                                        style: arrivalDate != null
                                            ? TextStyle(
                                                fontStyle: FontStyle.normal,
                                                fontFamily: 'Gilroy',
                                                color: Color(0xFF3D415E),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              )
                                            : TextStyle(
                                                // color: kPlaceHolderColor
                                                fontStyle: FontStyle.normal,
                                                fontFamily: 'Gilroy',
                                                color: Color(0xff3a3f5c),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                      ),
                                    ),
                                    Image.asset("assets/images/calendar.png",
                                        width: 20)
                                  ],
                                ),
                              ),
                              onTap: () async {
                                DateResult newDateTime = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DatePickerScreen(
                                        shouldChooseMultipleDates:
                                            activeTab == _TABS.ROUND_TRIP,
                                      ),
                                    ));
                                if (newDateTime == null) return;
                                setState(() {
                                  departureDate =
                                      newDateTime.departureDate.toString();
                                  if (activeTab == _TABS.ROUND_TRIP &&
                                      newDateTime.returnDate != null)
                                    arrivalDate =
                                        newDateTime.returnDate.toString();
                                });
                              },
                            ),
                          ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: spacing, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Adults",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Gilroy Bold',
                            fontSize: 18,
                            color: kLabelTextColor),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Kids",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Gilroy Bold',
                            fontSize: 18,
                            color: kLabelTextColor),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        margin: const EdgeInsets.only(right: 5),
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                if (!(adults - 1 < 0)) {
                                  setState(() {
                                    adults -= 1;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(247, 249, 252, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                    color: Color(0xFF0e3178),
                                  ),
                                ),
                              ),
                            ),
                            Text(adults != null ? adults.toString() : ''),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  adults += 1;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(247, 249, 252, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  "+",
                                  style: TextStyle(color: Color(0xFF0e3178)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 5),
                        padding: const EdgeInsets.all(5.0),
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                if (!(kids - 1 < 0)) {
                                  setState(() {
                                    kids -= 1;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(247, 249, 252, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                    color: Color(0xFF0e3178),
                                  ),
                                ),
                              ),
                            ),
                            Text(kids.toString()),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  kids += 1;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(247, 249, 252, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    color: Color(0xFF0e3178),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: spacing, bottom: 20),
                child: Text(
                  "Cabin Class",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gilroy Bold',
                      fontSize: 18,
                      color: kLabelTextColor),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            cabin = "economy";
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: cabin == "economy"
                                  ? Colors.white
                                  : Colors.transparent,
                              border: Border.all(
                                color: cabin == "economy"
                                    ? Color.fromRGBO(14, 49, 120, 1)
                                    : Colors.transparent,
                              )),
                          child: Container(
                            child: Center(
                              child: Text(
                                "Economy",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Gilroy Bold',
                                    fontSize: 14,
                                    color: cabin == "economy"
                                        ? Color.fromRGBO(14, 49, 120, 1)
                                        : Colors.black26),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            cabin = "business";
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: cabin == "business"
                                  ? Colors.white
                                  : Colors.transparent,
                              border: Border.all(
                                color: cabin == "business"
                                    ? Color.fromRGBO(14, 49, 120, 1)
                                    : Colors.transparent,
                              )),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: cabin == "bussiness"
                                  ? [
                                      BoxShadow(
                                        color: Color.fromRGBO(20, 40, 160, 0.5),
                                        blurRadius: 30,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                "Business",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Gilroy Bold',
                                    fontSize: 14,
                                    color: cabin == "business"
                                        ? Color.fromRGBO(14, 49, 120, 1)
                                        : Colors.black26),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            cabin = "fClass";
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: cabin == "fClass"
                                  ? Colors.white
                                  : Colors.transparent,
                              border: Border.all(
                                color: cabin == "fClass"
                                    ? Color.fromRGBO(14, 49, 120, 1)
                                    : Colors.transparent,
                              )),
                          child: Container(
                            child: Center(
                              child: Text(
                                "First Class",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Gilroy Bold',
                                    fontSize: 14,
                                    color: cabin == "fClass"
                                        ? Color.fromRGBO(14, 49, 120, 1)
                                        : Colors.black26),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: spacing * 1.5,
              ),
              getSearchButton(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget getFlightDetailItems(List<FlightRouteObject> departures,
      List<FlightRouteObject> returns, FlightInformationObject flight) {
    List<Widget> lists = List();
    lists.addAll(loadItems(departures, 'Departure', flight));
    lists.addAll(loadItems(returns.reversed.toList(), 'Return', flight));
    return Container(
        margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.blue,
            ),
          ),
        ),
        child: Column(
          children: lists,
        ));
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

  Widget _drawerbuild(BuildContext context) {
    return Column(
      children: <Widget>[
        getDrawerAppBarUI(),
        Expanded(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Color(0xFFF7F9FC),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    title: new Text(
                      "FlyLine Premium",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff8e969f),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF113377),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MembershipPlansScreen()),
                      );
                    },
                  ),
                  Divider(
                    height: 1.5,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    title: new Text(
                      "Account Details",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff8e969f),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF113377),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountDetailsScreen()),
                      );
                    },
                  ),
                  Divider(
                    height: 1.5,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    title: new Text(
                      "Payment Details",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff8e969f),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF113377),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentDetailsScreen()));
                    },
                  ),
                  Divider(
                    height: 1.5,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    title: new Text(
                      "Trip Management",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff8e969f),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF113377),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountDetailsScreen()),
                      );
                    },
                  ),
                  Divider(
                    height: 1.5,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    title: new Text(
                      "Deal Feed",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff8e969f),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF113377),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DealFeed()),
                      );
                    },
                  ),
                  Divider(
                    height: 1.5,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    title: new Text(
                      "Help Center",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff8e969f),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF113377),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HelpCenterScreen()),
                      );
                    },
                  ),
                  Divider(
                    height: 1.5,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    title: Text(
                      "Terms of Service",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff8e969f),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF113377),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TermsOfUsePage()));
                    },
                  ),
                  Divider(
                    height: 1.5,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    title: new Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff8e969f),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF113377),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrivacyPolicyPage()),
                      );
                    },
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Divider(
                    height: 1.5,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    title: new Text(
                      "Log Out",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xffff0d0d),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF113377),
                    ),
                    onTap: () {
                      _logOut();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    flyLinebloc.token = null;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  Widget getFlightDetails() {
    return Container(
        child: Expanded(
      child: Container(
          // color: Colors.amber,
          color: const Color(0xfff7f9fc),
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            scrollDirection: Axis.vertical,
            itemCount:
                offset != 0 ? listOfFlights.length + 1 : listOfFlights.length,
            itemBuilder: (context, index) {
              if (index != listOfFlights.length) {
                var flight = listOfFlights[index];

                if (flight == null && _isLoading) {
                  // showSendingProgressBar();
                  //       Future.delayed(const Duration(milliseconds: 5000), () {
                  //       setState(() {
                  //           hideSendingProgressBar();
                  //       });
                  //       });
                  // return
                  // Container(
                  //     height: 100,
                  //     child: Center(
                  //         child: CircularProgressIndicator(
                  //       valueColor: AlwaysStoppedAnimation<Color>(
                  //           const Color(0xFF00AFF5)),
                  //     ),),);

                }
                print("Flights = $flight");

                // initialize
                int a2b = 0;
                int b2a = 0;

                List<FlightRouteObject> departures = List();
                List<String> departureStopOverCity = List();
                List<FlightRouteObject> returns = List();
                List<String> returnStopOverCity = List();

                // one way
                if (typeOfTripSelected == 1) {
                  for (FlightRouteObject route in flight.routes) {
                    departures.add(route);
                    if (route.cityTo != flight.cityTo) {
                      departureStopOverCity.add(route.cityTo);
                      a2b++;
                    } else {
                      break;
                    }
                  } // round trip
                } else if (typeOfTripSelected == 0) {
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

                return Container(
                  margin:
                      EdgeInsets.only(left: 0, right: 20, top: 0, bottom: 16),
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
                                  top: 14,
                                  bottom: 14,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "Destination ",
                                          style: TextStyle(
                                            fontFamily: 'AvenirNext',
                                            color: Color(0xff3a3f5c),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                          )),
                                      TextSpan(
                                          text: formatDates
                                              .format(flight.localDeparture),
                                          style: TextStyle(
                                            fontFamily: 'AvenirNext',
                                            color: Color(0xff3a3f5c),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                          )),
                                    ])),
                                    ((a2b >= 1 || b2a >= 1)
                                        ? Text(
                                            "More Info",
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
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: formatTime.format(
                                                        departures[0]
                                                            .localDeparture) +
                                                    " ",
                                                style: TextStyle(
                                                  fontFamily: 'AvenirNext',
                                                  color: Color(0xff3a3f5c),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal,
                                                )),
                                            TextSpan(
                                              text: departures[0].flyFrom +
                                                  " (" +
                                                  departures[0].cityFrom +
                                                  ")",
                                              style: TextStyle(
                                                fontFamily: 'AvenirNext',
                                                color: Color(0xff3a3f5c),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                      ),
                                      Text(
                                        "Airlines",
                                        style: TextStyle(
                                          fontFamily: 'AvenirNext',
                                          color: Color(0xff8e969f),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
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
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: formatTime.format(
                                                        departures[departures
                                                                    .length -
                                                                1]
                                                            .localArrival) +
                                                    " ",
                                                style: TextStyle(
                                                  fontFamily: 'AvenirNext',
                                                  color: Color(0xff3a3f5c),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal,
                                                )),
                                            TextSpan(
                                              text: departures[
                                                          departures.length - 1]
                                                      .flyTo +
                                                  " (" +
                                                  departures[
                                                          departures.length - 1]
                                                      .cityTo +
                                                  ")",
                                              style: TextStyle(
                                                fontFamily: 'AvenirNext',
                                                color: Color(0xff3a3f5c),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 68,
                                      ),
                                      Expanded(
                                        child: Container(
                                          // margin:
                                          //     EdgeInsets.only(left: 10, right: 5),
                                          child: Image.network(
                                              'https://storage.googleapis.com/joinflyline/images/airlines/${flight.routes[0].airline}.png',
                                              width: 20.0,
                                              height: 20.0),
                                        ),
                                      ),
                                      (a2b >= 1
                                          ? Expanded(
                                              child: Container(
                                                child: Image.network(
                                                    'https://storage.googleapis.com/joinflyline/images/airlines/${flight.routes[0].airline}.png',
                                                    width: 20.0,
                                                    height: 20.0),
                                              ),
                                            )
                                          : Container()),
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
                                                    flight.durationDeparture,
                                                    style: const TextStyle(
                                                        color: const Color(
                                                            0xff0e3178),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            "AvenirNext",
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
                                                          fontFamily:
                                                              "AvenirNext",
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
                                                      selectedClassOfService,
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff0e3178),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              "AvenirNext",
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
                      (typeOfTripSelected == 1
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  right: 20.0,
                                  left: 20.0,
                                  top: 21.0,
                                  bottom: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      width: 50,
                                      height: 0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffe7e9f0),
                                            width: 1),
                                      ),
                                    ),
                                  ),
                                  Text(
                                      flight.nightsInDest.toString() +
                                          " nights in " +
                                          flight.cityTo,
                                      style: const TextStyle(
                                          color: const Color(0xff8e969f),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "AvenirNext",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0),
                                      textAlign: TextAlign.left),
                                  Expanded(
                                    child: Container(
                                      width: 50,
                                      height: 0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffe7e9f0),
                                            width: 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      (typeOfTripSelected == 1
                          ? Container()
                          : Container(
                              child: Padding(
                                padding: EdgeInsets.only(left: 16.0, right: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(
                                        top: 14,
                                        bottom: 14,
                                      ),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: "Return ",
                                            style: TextStyle(
                                              fontFamily: 'AvenirNext',
                                              color: Color(0xff3a3f5c),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                            )),
                                        TextSpan(
                                            text: formatDates.format(
                                                returns[returns.length - 1]
                                                    .localDeparture),
                                            style: TextStyle(
                                              fontFamily: 'AvenirNext',
                                              color: Color(0xff3a3f5c),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                            )),
                                      ])),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    color: Color(0xFFF7F9FC)
                                                    // Color.fromRGBO(
                                                    //     14, 49, 120, 1),
                                                    ),
                                              ),
                                              width: 10,
                                              height: 10,
                                            ),
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
                                                          " ",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'AvenirNext',
                                                        color:
                                                            Color(0xff3a3f5c),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      )),
                                                  TextSpan(
                                                    text: returns[
                                                                returns.length -
                                                                    1]
                                                            .flyFrom +
                                                        " (" +
                                                        returns[returns.length -
                                                                1]
                                                            .cityFrom +
                                                        ")",
                                                    style: TextStyle(
                                                      fontFamily: 'AvenirNext',
                                                      color: Color(0xff3a3f5c),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                            ),
                                            Text(
                                              "Airlines",
                                              style: TextStyle(
                                                fontFamily: 'AvenirNext',
                                                color: Color(0xff8e969f),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text: formatTime.format(
                                                              returns[0]
                                                                  .localArrival) +
                                                          " ",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'AvenirNext',
                                                        color:
                                                            Color(0xff3a3f5c),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      )),
                                                  TextSpan(
                                                    text: returns[0].flyTo +
                                                        " (" +
                                                        returns[0].cityTo +
                                                        ")",
                                                    style: TextStyle(
                                                      fontFamily: 'AvenirNext',
                                                      color: Color(0xff3a3f5c),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 68,
                                            ),
                                            Container(
                                              // margin:
                                              //     EdgeInsets.only(left: 10, right: 5),
                                              child: Image.network(
                                                  'https://storage.googleapis.com/joinflyline/images/airlines/${flight.routes[1].airline}.png',
                                                  width: 20.0,
                                                  height: 20.0),
                                            ),
                                            (a2b >= 1
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5, right: 5),
                                                    child: Image.network(
                                                        'https://storage.googleapis.com/joinflyline/images/airlines/${flight.routes[1].airline}.png',
                                                        width: 20.0,
                                                        height: 20.0),
                                                  )
                                                : Container()),
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
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      color: const Color(
                                                          0xfff7f9fc)),
                                                  child: // 15h 56m
                                                      Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 6, left: 15),
                                                    child: SizedBox(
                                                      width: 50,
                                                      height: 16,
                                                      child: Text(
                                                          flight
                                                              .durationDeparture,
                                                          style: const TextStyle(
                                                              color:
                                                                  const Color(
                                                                      0xff0e3178),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "AvenirNext",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
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
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      color: const Color(
                                                          0xfff7f9fc)),
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
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    "AvenirNext",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 12.0),
                                                            textAlign: TextAlign
                                                                .center)),
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
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      color: const Color(
                                                          0xfff7f9fc)),
                                                  child: // Economy
                                                      Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 6, left: 14),
                                                    child: SizedBox(
                                                        width: 52,
                                                        height: 16,
                                                        child: Text(
                                                            selectedClassOfService,
                                                            style: const TextStyle(
                                                                color: const Color(
                                                                    0xff0e3178),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    "AvenirNext",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 12.0),
                                                            textAlign: TextAlign
                                                                .center)),
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
                            )),
                      // Price and Book

                      AnimatedOpacity(
                          // If the widget is visible, animate to 0.0 (invisible).
                          // If the widget is hidden, animate to 1.0 (fully visible).
                          opacity: index < _clickFlight.length &&
                                  _clickFlight[index] != null &&
                                  _clickFlight[index]
                              ? 1.0
                              : 0.0,
                          duration: Duration(milliseconds: 500),
                          // The green box must be a child of the AnimatedOpacity widget.
                          child: index < _clickFlight.length &&
                                  _clickFlight[index] != null &&
                                  _clickFlight[index]
                              ? this.getFlightDetailItems(
                                  departures, returns, flight)
                              : Container()),
                      Container(
                          margin: EdgeInsets.all(5.0),
                          padding: EdgeInsets.only(top: 15.0),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                //                    <--- top side
                                color: AppTheme.getTheme().dividerColor,
                              ),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Trip Price",
                                    style: TextStyle(
                                      fontFamily: 'AvenirNext',
                                      color: Color(0xff8e969f),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: 80,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE5F7FE),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "\$ " + flight.price.toString(),
                                      //"$ \$"+ flight.price.toString(),
                                      style: TextStyle(
                                        fontFamily: 'AvenirNext',
                                        color: Color(0xff00aeef),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Center(
                                child: InkWell(
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    decoration: BoxDecoration(
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
                                      child: Text(
                                        "Book Now",
                                        style: TextStyle(
                                          fontFamily: 'Nexa-☞',
                                          color: Color(0xffffffff),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                            ],
                          ))
                    ],
                  ),
                  // ),
                );
              } else {
                return getLoadMoreButton();
              }
            },
          )),
    ));
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
          decoration: BoxDecoration(
              color: const Color(0xFF00AFF5),
              //   border: Border.all(color: const Color(0xFF00AFF5), width: 0.5)),
              // padding: EdgeInsets.all(12),
              // decoration: BoxDecoration(
              //   color: Colors.blue,
              borderRadius: BorderRadius.circular(25)),
          child: Center(
            child: Text("Load More",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        // child: Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(25)
        //   ),
        //   child: Text("Load More",
        //       style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 19.0,
        //           fontWeight: FontWeight.bold)),
        // ),
        onTap: () {
          if (!_loadMore &&
              selectedDeparture != null &&
              selectedArrival != null) {
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

  Widget getSearchButton() {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16, top: 16, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color.fromRGBO(0, 174, 239, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text("Search Flights",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Gilroy Bold',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700)),
            onPressed: () {
              if (!_clickedSearch &&
                  selectedDeparture != null &&
                  selectedArrival != null) {
                showSendingProgressBar();
                Future.delayed(const Duration(milliseconds: 15000), () {
                  setState(() {
                    hideSendingProgressBar();
                  });
                });
                setState(() {
                  offset = 0;
                  originalFlights = List();
                  listOfFlights = List();
                  _clickedSearch = true;
                  _isLoading = true;
                  listOfFlights.add(null);
                  _displayLoadMore = false;
                });

                try {
                  flyLinebloc.searchFlight(
                      selectedDeparture.type + ":" + selectedDeparture.code,
                      selectedArrival.type + ":" + selectedArrival.code,
                      formatAllDay.format(DateTime.parse(departureDate)),
                      formatAllDay.format(DateTime.parse(arrivalDate)),
                      typeOfTripSelected == 0 ? "round" : "oneway",
                      formatAllDay.format(DateTime.parse(departureDate)),
                      formatAllDay.format(DateTime.parse(arrivalDate)),
                      ad.toString(),
                      "0",
                      "0",
                      selectedClassOfServiceValue,
                      "USD",
                      this.offset.toString(),
                      this.perPage.toString());
                } catch (e) {
                  print(e);
                }
              }

              print(formatAllDay.format(DateTime.parse(departureDate)));
              // var flight = listOfFlights[0];
              // var flyingFrom= flight.flyFrom;
              // var flyingTo = flight.flyTo;
              var depDate = formatDates.format(DateTime.parse(departureDate));
              var arrDate = formatDates.format(DateTime.parse(arrivalDate));

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      //hhs.HotelHomeScreen
                      SearchResults(
                        // routes: flight.routes,
                        //  flyingFrom:flyingFrom,
                        //  flyingTo: flyingTo,
                        depDate: depDate,
                        arrDate: arrDate,
                        typeOfTripSelected: this.typeOfTripSelected,
                      )));

              print(typeOfTripSelected == 0
                  ? 'Round-Trip Selected'
                  : 'One-way Selected');
              //  print(flight.routes);
            },
          ),
        ],
      ),
    );
  }

  Widget getUpdateButton() {
    if (_isSearched) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset('assets/images/refresh.png', width: 17.5, height: 17.5),
          SizedBox(
            width: 10,
          ),
          InkWell(
            child: Text("Update",
                style: TextStyle(
                  fontFamily: 'AvenirNext',
                  color: Color(0xff8e969f),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                )),
            onTap: () {
              setState(() {
                this._isSearched = false;
              });
            },
          ),
        ],
      );
    }
    return Container();
  }

  Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 2),
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

//                      showDemoDialog(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, top: 20, bottom: 20),
                      child: InkWell(
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
                                fontSize: 14,
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
                            ad > 1 ? "$ad Adults" : "$ad Adult",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
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
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 4, right: 4, top: 4, bottom: 4),
                      child: InkWell(
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
                          classOfServicesList.forEach((item) {
                            items.add(Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 5.0,
                                    bottom: 5.0),
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
                                      selectedClassOfService = item;
                                      selectedClassOfServiceValue =
                                          classOfServicesValueList[
                                              classOfServicesList
                                                  .indexOf(item)];
                                    });
                                  },
                                  child: Text(item),
                                )));
                          });
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  title: const Text('Select Class of Service'),
                                  children: items,
                                );
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
                                fontSize: 14,
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
          margin:
              const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 10),
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
                        fontSize: 14,
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
                  height: 40,
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
                        fontSize: 14,
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
                  height: 40,
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
                          fontSize: 8,
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
                          fontSize: 14,
                        ),
                        cursorColor: AppTheme.getTheme().primaryColor,
                        decoration: InputDecoration(
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
      ],
    );
  }

  //Journey Height:Container(padding:20)=>LocationSearchUI(height:xx)
  Widget selectJourney() {
    return (Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, right: 5, top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Image.asset('assets/images/departure.png',
                      width: 23, height: 23),
                ),
                Container(
                  child: Image.asset('assets/images/arrow_down.png', width: 7),
                ),
                Container(
                  child: Image.asset('assets/images/arrival.png',
                      width: 23, height: 23),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  height: 48,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 8, right: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.getTheme().backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      // padding: EdgeInsets.only(
                      //   left: 10,
                      // ),
                      child: LocationSearchUI("Departure", true,
                          notifyParent: refreshDepartureValue,
                          city: departure)),
                ),
                Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(
                      left: 8, right: 16, top: 20, bottom: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.getTheme().backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      // padding: EdgeInsets.only(
                      //   left: 10,
                      // ),
                      child: LocationSearchUI(
                        "Arrival",
                        false,
                        notifyParent: refreshDepartureValue,
                        city: arrival,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget getFilterBarUI() {
    if (!_isSearched) {
      return Container();
    }
    return Stack(
      children: <Widget>[
        // Positioned(
        //   top: 0,
        //   left: 0,
        //   right: 0,
        //   child: Container(
        // height: 10,
        // decoration: BoxDecoration(
        //   color: AppTheme.getTheme().backgroundColor,
        //   // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //       color: AppTheme.getTheme().dividerColor,
        //       offset: Offset(0, -2),
        //       blurRadius: 8.0),
        // ],
        // ),
        //  ),
        // ),
        Container(
            color: AppTheme.getTheme().backgroundColor,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
              child: Column(
                children: <Widget>[
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            originalFlights.length.toString() +
                                " Flights Found",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      //  Expanded(child: getUpdateButton()),

                      InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());

                          this.handleFilter();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Image.asset('assets/images/filter.png',
                                width: 23, height: 23),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        // Positioned(
        //   top: 0,
        //   left: 0,
        //   right: 0,
        //   child: Divider(
        //     height: 1,
        //   ),
        // )
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
        onCancelClick: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget getAppBarUI() {
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
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                height: AppBar().preferredSize.height + 10,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                      // setState(() {
                      //   press = !press;
                      // });
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xfff7f9fc)),
                        child: Center(child: Icon(Icons.arrow_back_ios))),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logotype.png',
                  //width: 10,
                ),
              ),
              // SizedBox(height: 30,),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                height: AppBar().preferredSize.height + 10,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DealFeed()));
                      // _scaffoldKey.currentState.openDrawer();
                      // setState(() {
                      //   _isSearched = false;
                      // });
                      // Navigator.pop(context);
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xfff7f9fc)),
                        child: Center(
                          child: Image.asset(
                            'assets/images/add.png',
                            //width: 10,
                          ),
                        )
                        // Image.asset("assets/images/left.png"),
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

  Widget getDrawerAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7F9FC),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              height: AppBar().preferredSize.height + 10,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xfff7f9fc)),
                      child: Center(child: Icon(Icons.arrow_back_ios))),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: new Text(
                  "Menu",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xff0e3178),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 40,
            )
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

  handleFilter() {
    if (originalFlights.length != 0) {
      if (filterExplore == null) {
        filterExplore = filterExplore(this.originalFlights, this.airlineCodes);
      }
    }
  }
}

enum ButtonMarker { user, back }

class LocationSearchUI extends StatefulWidget {
  final Function(LocationObject value, bool type) notifyParent;
  final title;
  final isDeparture;
  // final TextStyle;
  final LocationObject city;

  LocationSearchUI(this.title, this.isDeparture,
      {Key key, @required this.notifyParent, this.city})
      : super(key: key);

  @override
  _LocationSearchUIState createState() => _LocationSearchUIState(title);
}

class _LocationSearchUIState extends State<LocationSearchUI>
    with TickerProviderStateMixin {
  List<FlightInformationObject> listOfFlights = List();
  final TextEditingController _typeAheadController = TextEditingController();

  var title;

  _LocationSearchUIState(var title) {
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<LocationObject>(
      autovalidate: true,
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (location) {
        _typeAheadController.text = location.name +
            " " +
            location.subdivisionName +
            " " +
            location.countryCode;

        widget.notifyParent(location, widget.isDeparture);
      },
      getImmediateSuggestions: true,
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        elevation: 8,
      ),
      textFieldConfiguration: TextFieldConfiguration(
          controller: _typeAheadController,
          autofocus: true,
          style: DefaultTextStyle.of(context).style.copyWith(
                fontStyle: FontStyle.normal,
                fontFamily: 'Gilroy',
                color: Color(0xff3a3f5c),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
          decoration: InputDecoration(
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
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(15.0),
                ),
                borderSide: BorderSide(color: HexColor("#0e3178"), width: 1.0),
              ),
              hintText: "Select " + widget.title + " City or Airport",
              hintStyle: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xff3a3f5c),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
          textAlign: TextAlign.start),
      suggestionsCallback: (search) async {
        if (search.length > 0) {
          var response = flyLinebloc.locationQuery(search);
          return response;
        } else
          return null;
      },
      itemBuilder: (context, location) {
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFF8F8FC),
                    borderRadius: BorderRadius.circular(25)),
                child: ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(
                      location.name +
                          " " +
                          location.subdivisionName +
                          " " +
                          location.countryCode,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProgressBar {
  OverlayEntry _progressOverlayEntry;

  void show(BuildContext context) {
    _progressOverlayEntry = _createdProgressEntry(context);
    Overlay.of(context).insert(_progressOverlayEntry);
  }

  void hide() {
    if (_progressOverlayEntry != null) {
      _progressOverlayEntry.remove();
      _progressOverlayEntry = null;
    }
  }

  OverlayEntry _createdProgressEntry(BuildContext context) => OverlayEntry(
      builder: (BuildContext context) => Stack(
            children: <Widget>[
              Container(
                // color: Colors.white
                color: Color(0xFF113377).withOpacity(1),
              ),
              Positioned(
                top: screenHeight(context) / 2,
                left: screenWidth(context) / 2.2,
                child: CupertinoTheme(
                  data: CupertinoTheme.of(context).copyWith(
                      primaryColor: Colors.white, brightness: Brightness.dark),
                  child: CupertinoActivityIndicator(
                    radius: 20,
                  ),
                ),
              ),
              Positioned(
                top: screenHeight(context) / 2.2,
                left: screenWidth(context) / 4.2,
                child: Material(
                  color: Color(0xFF113377),
                  child: new Text(
                    "Loading Search Results",
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              )
            ],
          ));

  double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
}
