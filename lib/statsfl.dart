import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StatsFl extends StatefulWidget {
  final bool isEnabled;
  final double width;
  final Widget child;
  final Alignment align;
  final double totalTime;
  final double sampleTime;

  const StatsFl(
      {Key key,
        @required this.child,
        this.width = 300,
        this.totalTime = 20,
        this.sampleTime = .5,
        this.isEnabled = true,
        this.align})
      : super(key: key);

  @override
  _StatsFlState createState() => _StatsFlState();
}

class _StatsFlState extends State<StatsFl> with ChangeNotifier {
  List<FpsEntry> _entries = [];
  int _lastCalcTime;
  Ticker _ticker;
  double _ticks = 0;
  double _fps = 60;
  bool _shouldRepaint = false;

  int get nowMs => DateTime.now().millisecondsSinceEpoch;

  double get totalTimeMs => (widget.totalTime) * 1000;

  double get sampleTimeMs => (widget.sampleTime) * 1000;

  double get fps => _fps;


  @override
  void initState() {
    _ticker = Ticker(_handleTick);
    _ticker.start();
    _lastCalcTime = nowMs;
    super.initState();
  }

  void _handleTick(Duration d) {
    // Tick
    _ticks++;
    // Calculate
    if (nowMs - _lastCalcTime > sampleTimeMs) {
      _shouldRepaint = true;
      int remainder = (nowMs - _lastCalcTime - sampleTimeMs).round();
      _lastCalcTime = nowMs - remainder;
      _fps = min((_ticks * 1000 / sampleTimeMs).roundToDouble(), 60);
      _ticks = 0;
      //Add new entry, remove old ones
      _entries.add(FpsEntry(_lastCalcTime, _fps));
      _entries.removeWhere((e) => nowMs - e.time > totalTimeMs);
      notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!(widget.isEnabled ?? true)) return widget.child;
    return Material(
      child: Stack(
        children: <Widget>[
          widget.child,
          IgnorePointer(
            child: Align(
              alignment: widget.align ?? Alignment.topLeft,
              child: AnimatedBuilder(
                animation: this,
                builder: (_, __) => _buildPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPainter() {
    String fToString(double value) => value.toStringAsPrecision(2);
    double minFps = 0, maxFps = 0;
    if (_entries.isNotEmpty) {
      minFps = _entries.reduce((prev, e) => e.fps < prev.fps ? e : prev)?.fps ?? 0;
      maxFps = _entries.reduce((prev, e) => e.fps > prev.fps ? e : prev)?.fps ?? 0;
    }
    double width = widget.width;
    return RepaintBoundary(
      child: CustomPaint(
          foregroundPainter: _StatsPainter(state: this),
          child: Container(
            padding: EdgeInsets.only(left: 4, top: 4),
            width: width,
            height: width * .25,
            color: Colors.black54.withOpacity(.8),
            child: Text(
              "${fToString(_fps)} FPS (${fToString(minFps)}-${fToString(maxFps)})",
              style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          )),
    );
  }
}

class FpsEntry {
  double fps;
  int time;

  FpsEntry(this.time, this.fps);
}

class _StatsPainter extends CustomPainter {
  final _StatsFlState state;

  _StatsPainter({this.state});

  double getYForFps(double fps, double maxHeight) => maxHeight - 2 - (min((fps / 60), 1) * (maxHeight - 30));

  @override
  void paint(Canvas canvas, Size size) {
    state._shouldRepaint = false;
    double maxXAxis = state.totalTimeMs;
    double colWidth = size.width / (maxXAxis / state.sampleTimeMs);
    for (var e in state._entries) {
      Color c = Colors.green;
      if (e.fps < 60) c = Colors.yellow;
      if (e.fps < 45) c = Colors.orange;
      if (e.fps < 30) c = Colors.redAccent;
      double x = size.width - colWidth - ((state.nowMs - e.time) / maxXAxis) * size.width;
      double y = getYForFps(e.fps, size.height);
      canvas.drawRect(Rect.fromLTWH(x, y, colWidth + .5, 2), Paint()..color = c);
      canvas.drawRect(Rect.fromLTWH(x, y + 3, colWidth + .5, size.height - y), Paint()..color = c.withOpacity(.2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => state._shouldRepaint;
}
