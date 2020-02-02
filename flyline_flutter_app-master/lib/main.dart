import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motel/appTheme.dart';

import 'introductionScreen.dart';
import 'modules/bottomTab/bottomTabScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(new MyApp()));
  // runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  static restartApp(BuildContext context) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();

    state.restartApp();
  }

  static setCustomeTheme(BuildContext context) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setCustomeTheme();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  void setCustomeTheme() {
    setState(() {
      AppTheme.isLightTheme = !AppTheme.isLightTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
      statusBarBrightness:
          AppTheme.isLightTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarColor:
          AppTheme.isLightTheme ? Colors.white : Colors.black,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness:
          AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
    ));
    return MaterialApp(
      key: key,
      title: 'FlyLine',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      routes: routes,
    );
  }

  var routes = <String, WidgetBuilder>{
    Routes.SPLASH: (BuildContext context) => IntroductionScreen(),
    Routes.TabScreen: (BuildContext context) => new BottomTabScreen(),
  };
}

class Routes {
  static const String SPLASH = "/";
  static const String TabScreen = "/bottomTab/bottomTabScreen";
}
