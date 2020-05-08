import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ValueIncrementer extends StatelessWidget {
  const ValueIncrementer({
    Key key,
    @required this.stream,
    @required this.setter,
  }) : super(key: key);

  final ValueStream stream;
  final Function(int) setter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.only(right: 5),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setter(max(stream.value - 1, 0));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
          StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                return Text('${snapshot.data}');
              }),
          GestureDetector(
            onTap: () {
              setter(stream.value + 1);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
    );
  }
}
