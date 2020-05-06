import 'package:flutter/material.dart';

const kFontColor = Color.fromRGBO(58, 63, 92, 1);
const kBlueColor = Color.fromRGBO(0, 174, 239, 1);
const titled = [
  'Multi Carrier',
  'Single Carrier',
  'Single Flight',
  'Legacy Airlines'
];

class SortFlightsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 90),
        child: Container(
          color: Color(0xfff8f9fc),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: Color(0xff3a3f5c),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        Text(
                          'DAL - SEA',
                          style: TextStyle(
                              fontFamily: 'Gordita',
                              fontWeight: FontWeight.w800,
                              color: kFontColor,
                              fontSize: 20),
                        ),
                        SizedBox(height: 7),
                        Text(
                          'May 20 - May 24',
                          style: TextStyle(
                              fontFamily: 'Gordita',
                              fontWeight: FontWeight.w600,
                              color: kFontColor,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      'Filters',
                      style: TextStyle(
                          color: Color(0xff3a3f5c),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Image.asset(
                  'images/bg3.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lowest Price',
                      style: TextStyle(
                        color: kFontColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          r"$110",
                          style: TextStyle(
                            fontSize: 30,
                            color: kBlueColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '/per traveller',
                          style: TextStyle(
                            fontSize: 14,
                            color: kFontColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    RaisedButton(
                      shape: StadiumBorder(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 45, vertical: 12),
                      color: kBlueColor,
                      child: Text(
                        'View Flights',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 4,
                itemBuilder: (cxt, index) {
                  return Column(
                    children: [
                      Divider(),
                      Padding(
                        padding: EdgeInsets.all(17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    titled[index],
                                    style: TextStyle(
                                      color: kFontColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    r'4h 30m - $115',
                                    style: TextStyle(
                                      color: kBlueColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ]),
                            FlatButton(
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: kBlueColor,
                                  width: 2.5,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 10,
                              ),
                              child: Text(
                                'View Flights',
                                style: TextStyle(
                                  color: kBlueColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }),
          ),
          Container(
            color: Color(0xfff8f9fc),
            padding: EdgeInsets.only(top: 25, bottom: 35, right: 20, left: 20),
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                ),
                color: kBlueColor,
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
