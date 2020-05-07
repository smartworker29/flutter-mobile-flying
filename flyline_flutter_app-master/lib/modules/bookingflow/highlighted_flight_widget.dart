import 'package:flutter/material.dart';

class FlightWidget extends StatelessWidget {
  const FlightWidget({
    @required this.price,
    @required this.id,
    @required this.title,
  });

  final double price;
  final int id;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 253,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset('assets/images/sort_flight.png',
                  width: MediaQuery.of(context).size.width / 2 - 32),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9.0),
                    child: Text(
                      '$title',
                      style: TextStyle(
                        color: Color.fromRGBO(14, 49, 120, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 13.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 30,
                          child: Text(
                            '\$${price.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 174, 239, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        Text(
                          ' / per traveler',
                          style: TextStyle(
                            color: Color.fromRGBO(14, 49, 120, 1),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 27.0,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          child: Text(
                            'Flight #$id details.',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      );
                    },
                    color: Color.fromRGBO(0, 174, 239, 1),
                    child: Text(
                      'View this flight',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
