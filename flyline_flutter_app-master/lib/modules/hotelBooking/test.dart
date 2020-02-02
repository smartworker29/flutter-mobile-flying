import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:motel/appTheme.dart';

class MyTest extends StatefulWidget {
  @override
  MyTestState createState() => MyTestState();
}

class MyTestState extends State<MyTest> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  GlobalKey stickyKey = GlobalKey();

  double heightBox = -1;
  bool t = false;

  List<String> entries = List();
  List<int> colorCodes = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    animation = Tween<double>(begin: 0, end: -300).animate(controller);
    animation.addListener(() => setState(() {}));

    getData();


      SchedulerBinding.instance.addPostFrameCallback((_) => this.getKey());
  }

  void getKey() {
    var keyContext = stickyKey.currentContext;
    if (keyContext != null) {
      // widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      final pos = box.localToGlobal(Offset.zero);

      setState(() {
        heightBox = box.size.height;
      });
      print("height" + box.size.height.toString());
    }
  }

  Future<bool> getData() async {
    setState(() {
      entries = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];
      colorCodes = <int>[600, 500, 100, 600, 500, 100, 600, 500, 100];
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
        color: const Color(0xFFFFFFFF),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              this.top(),
              Expanded(
                flex: 1,
                child: Transform.translate(
                    offset: Offset(0, 0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF0000),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(),
                            FlatButton(
                              child: Text("Book a Flight",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                setState(() {
//                                  if (!t) {
//                                    controller.forward();
//                                  } else {
//                                    controller.reverse();
//                                  }
                                  t = !t;
                                });
                              },
                            ),
                            FlatButton(
                              child: Text("Back",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ))),
              ),
              Expanded(
                  flex: 2,
                  child: Transform.translate(
                      offset: Offset(0, 0),
                      child: Container(
                          height: null,
                          color: Colors.amber[100],
                          child: lists())))
            ],
          ),
        ));
  }

  Widget lists() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 150,
          color: Colors.amber[colorCodes[index]],
          child: Center(child: Text('Entry ${entries[index]}')),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget top() {
    return AnimatedContainer(
        key: stickyKey,
        height: !t ? (heightBox != -1 ? heightBox : null) : 0,
        duration: Duration(milliseconds: 2000),
        decoration: BoxDecoration(
          color: AppTheme.getTheme().primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppTheme.getTheme().dividerColor,
              blurRadius: 8,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Container(height: 300, child: Center(child: Text("Aaaaa"))));
  }
}
