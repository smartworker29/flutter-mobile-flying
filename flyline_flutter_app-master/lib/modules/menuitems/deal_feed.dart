import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motel/models/flyline_deal.dart';
import 'package:motel/network/blocs.dart';

class DealFeed extends StatefulWidget {
  @override
  _DealFeedState createState() => _DealFeedState();
}

class _DealFeedState extends State<DealFeed> {
  List<FlylineDeal> dealItems = List();

  @override
  void initState() {
    flyLinebloc.randomDeals();
    flyLinebloc.randomDealItems.stream.listen((onData) {
      setState(() {
        dealItems = onData;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFF7F9FC),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "All Airports"),
              Tab(
                text: "Home Airport",
              ),
            ],
            indicator: BoxDecoration(),
            indicatorColor: Colors.transparent,
            labelColor: Color(0xFF0E3178),
          ),
          centerTitle: true,
          title: Text(
            'Deals',
            style: TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E3178)),
          ),
          leading: Container(
            margin: EdgeInsets.only(left: 16),
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF0E3178),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: dealItems.isEmpty? Center(child: CircularProgressIndicator()) : TabBarView(
          children: [
            ListView.builder(
                itemCount: dealItems.length,
                itemBuilder: (context, index) {
                  final item = dealItems[index];
                  final airlines = List();
                  if(item.airlines.length > 2){
                    airlines.add(item.airlines[0]);
                    airlines.add(item.airlines[1]);
                    airlines.add(item.airlines[2]);
                  } else if(item.airlines.length > 1){
                    airlines.add(item.airlines[0]);
                    airlines.add(item.airlines[1]);
                  } else if(item.airlines.length > 0){
                    airlines.add(item.airlines[0]);
                  }
                  return Container(
                    height: 208,
                    padding: EdgeInsets.all(8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 16, top: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:8, bottom: 16),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "\$" + item.price,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        color: Color(0xFF0E3178)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 14),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Color(0x1A00AEEF),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Text(
                                        "Flyline Deal",
                                        style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: Color(0xFF00AEEF)),
                                      )),
                                  Container(
                                    height: 32,
                                    width: 140,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                        itemCount: airlines.length,
                                        itemBuilder: (context, i){
                                        return Container(
                                            margin: EdgeInsets.only(left: 8),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Color(0x1A00AEEF),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Text(
                                              airlines[i],
                                              style: TextStyle(
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Color(0xFF00AEEF)),
                                            ));
                                    },
                                ),
                                  )

                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Departure City"),
                                          Text(item.cityFromName,
                                              style: TextStyle(
                                                fontFamily: 'Gilroy',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Arrival City"),
                                          Text(item.cityToName,
                                              style: TextStyle(
                                                fontFamily: 'Gilroy',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Dates"),
                                        Text(
                                            item.departureDate
                                                    .toString()
                                                    .substring(5, 10)
                                                    .replaceFirst("-", "/") +
                                                " - " +
                                                item.returnDate
                                                    .toString()
                                                    .substring(5, 10)
                                                    .replaceFirst("-", "/"),
                                            style: TextStyle(
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            Container()
          ],
        ),
      ),
    );
  }
}