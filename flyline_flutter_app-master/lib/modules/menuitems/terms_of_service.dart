import 'package:flutter/material.dart';
import 'package:motel/modules/menuitems/menu_item_app_bar.dart';
import 'package:motel/modules/menuitems/menu_item_tab_bar.dart';
import 'package:motel/modules/menuitems/privacy_policy.dart';
import 'package:motel/modules/menuitems/use_terms.dart';

class TermsOfUsePage extends StatefulWidget {
  TermsOfUsePage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _TermsOfUsePageState createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFF7F9FC),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) => [
            SliverToBoxAdapter(
              child: MenuItemAppBar(title: 'Terms and Privacy'),
            ),
            SliverToBoxAdapter(
              child: MenuItemTabBar(tabs: ["Terms of Use", "Privacy Policy"]),
            ),
          ],
          body: Container(
            child: TabBarView(
              children: [
                UseTermsPage(),
                PrivacyPolicyPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
