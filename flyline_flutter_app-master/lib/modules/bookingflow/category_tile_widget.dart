import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motel/modules/bookingflow/search_results_screen.dart';

class CategoryTileWidget extends StatelessWidget {
  const CategoryTileWidget({
    @required this.title,
    @required this.description,
    @required this.minimumPrice,
    @required this.maximumPrice,
    @required this.departureDate,
    @required this.arrivalDate,
    @required this.tripType,
  });

  final String title;
  final String description;
  final double minimumPrice;
  final double maximumPrice;
  final DateTime departureDate;
  final DateTime arrivalDate;
  final int tripType;

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat("MMM dd");

    return Container(
      height: 120,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 18.0, right: 17.0),
      margin: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                style: TextStyle(
                  color: Color.fromRGBO(14, 49, 120, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  height: 2,
                ),
              ),
              Text(
                '$description',
                style: TextStyle(
                  color: Color.fromRGBO(177, 177, 177, 1),
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
              Text(
                'Price Range  \$$minimumPrice - \$$maximumPrice',
                style: TextStyle(
                  color: Color.fromRGBO(177, 177, 177, 1),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: FlatButton(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SearchResults(
                  //  flyingFrom:flyingFrom,
                  //  flyingTo: flyingTo,
                  depDate: dateFormatter.format(departureDate),
                  arrDate: dateFormatter.format(arrivalDate),
                  typeOfTripSelected: tripType,
                ),
              )),
              color: Color.fromRGBO(0, 174, 239, 1),
              child: Text(
                'View Flights',
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
