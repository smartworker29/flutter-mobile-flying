
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motel/modules/bookingflow/category_info_widget.dart';
import 'package:motel/modules/bookingflow/category_tile_widget.dart';
import 'package:motel/modules/bookingflow/highlighted_flight_widget.dart';
import 'package:motel/modules/bookingflow/meta_search_results_screen.dart';
import 'package:motel/modules/bookingflow/search_results_screen.dart';
import 'package:motel/widgets/app_bar_date_dep_arr.dart';
import 'package:motel/widgets/app_bar_from_to.dart';
import 'package:motel/widgets/app_bar_pop_icon.dart';

class SearchSelector extends StatefulWidget {
  const SearchSelector({
    Key key,
    @required this.flyingTo,
    @required this.departureDate,
    @required this.arrivalDate,
    @required this.tripType,
  }) : super(key: key);

  final bool flyingTo;
  final DateTime departureDate;
  final DateTime arrivalDate;
  final int tripType;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SearchSelector> {
  final dateFormatter = DateFormat("MMM dd");
  @override
  Widget build(BuildContext context) {
    int _current = 0;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
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
                            flyTo: widget.flyingTo != null,
                          ),
                          AppBarDateDepArr(
                            depDate: dateFormatter.format(widget.departureDate),
                            arrDate: dateFormatter.format(widget.arrivalDate),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          Flexible(child: Container()),
          CarouselSlider(
            options: CarouselOptions(
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: [1, 2, 3].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return FlightWidget(
                    title: 'Cheapest Flight',
                    price: 110.0 * i,
                    id: i,
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [1, 2, 3].map((url) {
              int index = [1, 2, 3].indexOf(url);
              return Container(
                width: 25.0,
                height: 6.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: _current == index
                      ? Color.fromRGBO(14, 49, 120, 1)
                      : Color.fromRGBO(231, 233, 240, 1),
                ),
              );
            }).toList(),
          ),
          Container(height: 12),
          CategoryTileWidget(
            title: 'FlyLine Fare',
            description: 'Book directly through the airline',
            minimumPrice: 94.0,
            maximumPrice: 198.0,
            arrivalDate: widget.arrivalDate,
            departureDate: widget.departureDate,
            color: Color.fromRGBO(14, 49, 120, 1),
            routeToPush: SearchResults(
              depDate: dateFormatter.format(widget.departureDate),
              arrDate: dateFormatter.format(widget.arrivalDate),
              typeOfTripSelected: widget.tripType,
            ),
          ),
          CategoryTileWidget(
            title: 'FlyLine Exclusives',
            description: 'Book directly through the airline',
            minimumPrice: 94.0,
            maximumPrice: 198.0,
            arrivalDate: widget.arrivalDate,
            departureDate: widget.departureDate,
            color: Color.fromRGBO(0, 174, 239, 1),
            routeToPush: MetaSearchResults(
              depDate: dateFormatter.format(widget.departureDate),
              arrDate: dateFormatter.format(widget.arrivalDate),
              typeOfTripSelected: widget.tripType,
            ),
          ),
          CategoryTileWidget(
            title: 'Meta Fare',
            description: 'Book directly through the airline',
            minimumPrice: 94.0,
            maximumPrice: 198.0,
            arrivalDate: widget.arrivalDate,
            departureDate: widget.departureDate,
            color: Color.fromRGBO(68, 207, 87, 1),
            routeToPush: SearchResults(
              depDate: dateFormatter.format(widget.departureDate),
              arrDate: dateFormatter.format(widget.arrivalDate),
              typeOfTripSelected: widget.tripType,
            ),
          ),
          Flexible(child: Container()),
          CategoryInfoWidget(),
        ],
      ),
    );
  }
}
