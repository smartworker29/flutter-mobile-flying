import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:motel/modules/menuitems/menu_item_app_bar.dart';
import 'package:motel/modules/menuitems/menu_item_tab_bar.dart';
import 'package:motel/widgets/round_primary_bottun.dart';
import 'package:motel/widgets/round_textfield.dart';

class PaymentDetailsScreen extends StatefulWidget {
  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFF7F9FC),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MenuItemAppBar(title: 'Travel Wallet'),
              MenuItemTabBar(tabs: ["Card Information", "Loyalt Programs"]),
              Container(
                height: 300,
                child: TabBarView(
                  children: [
                    Column(
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: RoundTextEditField(
                            isDateTime: false,
                            placeholder: 'Card Number',
                            maxLength: 19,
                            inputType: TextInputType.number,
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: RoundTextEditField(
                            isDateTime: false,
                            inputType: TextInputType.text,
                            placeholder: 'Name on Card',
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 8, bottom: 8, left: 20, right: 10),
                                child: RoundTextEditField(
                                  isDateTime: false,
                                  placeholder: 'CCV',
                                  inputType: TextInputType.number,
                                  maxLength: 3,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 8, bottom: 8, left: 10, right: 20),
                                child: RoundTextEditField(
                                  isDateTime: true,
                                  placeholder: 'Exp Date',
                                  inputType: TextInputType.datetime,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: RoundPrimaryButton(
                                  text: 'Save',
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.add,
                                size: 14,
                              ),
                              Text(
                                'Add new card',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
