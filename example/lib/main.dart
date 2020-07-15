import 'package:flutter/material.dart';
import 'package:statsfl/statsfl.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int boxCount = 10;
    List<Widget> boxes = List.generate(boxCount, (index) => ShadowBox()).toList();

    /// Using 3 StatsFl instances to show different configs,
    /// you'll probably only want to show one in your app.
    return StatsFl(
      align: Alignment.topRight,
      child: StatsFl(
        width: double.infinity,
        showText: false,
        height: 20,
        align: Alignment.bottomLeft,
        child: StatsFl(
            maxFps: 90,
            width: 200,
            height: 30,
            align: Alignment.topLeft,
            child: Center(child: ListView(children: boxes))),
      ),
    );
  }
}

class ShadowBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      height: 50,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(spreadRadius: 4, blurRadius: 4, color: Colors.redAccent.withOpacity(.2)),
      ]),
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: SizedBox.fromSize(size: Size(20, 20), child: CircularProgressIndicator())),
    );
  }
}
