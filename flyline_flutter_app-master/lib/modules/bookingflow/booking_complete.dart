import 'package:flutter/material.dart';

class BookingCompletePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f9fc),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/booking.png'),
                const SizedBox(height: 20),
                new Text(
                  "Your Trip has been successfully booked!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xff0e3178),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    child: new Text(
                      "Back to Home",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xffffffff),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    onPressed: () {
                       Navigator.pop(context);
                    },
                    color: Color(0xff24aaf1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                  ),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 15,
            ),
          ),
        ),
      ),
    );
  }
}
