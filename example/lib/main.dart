import 'package:flutter/material.dart';
import 'package:statsfl/statsfl.dart';

void main() {
  //Enable this to measure your repaint regions
  //debugRepaintRainbowEnabled = true;
  runApp(Padding(
    padding: const EdgeInsets.only(top: 40),
    child: StatsFl(
      align: Alignment.topRight,
      child: MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: MyApp())),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int boxCount = 10;
    List<Widget> boxes = List.generate(
      boxCount,
      (index) => ShadowBox(animate: index == 2),
    ).toList();

    return Stack(
      children: [
        /// Test 2nd level of nesting
        StatsFl(
            isEnabled: false,
            maxFps: 90,
            width: 200,
            height: 30,
            align: Alignment.topLeft,
            child: Center(child: ListView(children: boxes))),

        /// Test floating version with no child
        Positioned.fill(child: Center(child: StatsFl())),
      ],
    );
  }
}

class ShadowBox extends StatelessWidget {
  final bool animate;

  const ShadowBox({Key? key, this.animate = false}) : super(key: key);

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
          child: SizedBox.fromSize(size: Size(20, 20), child: animate ? CircularProgressIndicator() : Container())),
    );
  }
}
