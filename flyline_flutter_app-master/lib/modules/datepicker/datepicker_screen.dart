import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motel/modules/datepicker/flutter_calendar_carousel.dart';

class DatePickerScreen extends StatelessWidget {
  final DateTime startingDate;
  final bool shouldChooseMultipleDates;
  List<DateTime> selectedDates = List();

  DatePickerScreen(
      {Key key, this.startingDate, this.shouldChooseMultipleDates = false})
      : super(key: key);

  List<DateTime> generateMonths() {
    DateTime date = startingDate ?? DateTime.now();
    return List<DateTime>.generate(12, (i) => date.add(Duration(days: i * 30)));
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> monthsToShow = generateMonths();

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
                        Navigator.pop(context);
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          child: Center(
                              child: Image.asset(
                            'assets/images/back-arrow.png',
                            scale: 28,
                          ))
                          // Image.asset("assets/images/left.png"),
                          ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  height: AppBar().preferredSize.height + 10,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logotype.png',
                    //width: 10,
                  ),
                ),
                // SizedBox(height: 30,),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      );
    }

    return new Scaffold(
      backgroundColor: Colors.white,
//      appBar:PreferredSizeWidget(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Color(0xFFF7F9FC),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          children: <Widget>[
            getAppBarUI(),
            Container(
              height: MediaQuery.of(context).size.height - //Screen Height
                  (AppBar().preferredSize.height + 10) - //AppBar Height
                  MediaQuery.of(context).padding.top, //StatusBar Height
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CalendarCarousel(
//                    markedDatesMap: _markedDateMap,
//                    selectedDateTime: [monthsToShow[index]],
                      monthToShow: monthsToShow[index],
                      height: 340,
                      onDayPressed: (selectedDate, _) {
                        if (shouldChooseMultipleDates) {
                          selectedDates.add(selectedDate);
                          if (selectedDates.length == 2) {
                            DateTime dep =
                                selectedDates[0].isBefore(selectedDates[1])
                                    ? selectedDates[0]
                                    : selectedDates[1];
                            DateTime ret =
                                selectedDates[0].isAfter(selectedDates[1])
                                    ? selectedDates[0]
                                    : selectedDates[1];
                            DateResult dr = DateResult(dep, ret);
                            Navigator.pop(context, dr);
                          }
                        } else
                          Navigator.pop(
                              context, DateResult(selectedDate, null));
                      },
                    ),
                  );
                },
                shrinkWrap: true,
                itemCount: monthsToShow.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateResult {
  final DateTime _departureDate;
  final DateTime _returnDate;

  DateResult(this._departureDate, this._returnDate);

  get departureDate => _departureDate;
  get returnDate => _returnDate;
}
