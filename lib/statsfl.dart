import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StatsFl extends StatefulWidget {
  final bool isEnabled;
  final double width;
  final double height;
  final Widget child;
  final Alignment align;
  final double totalTime;
  final double sampleTime;
  final bool showText;

  StatsFl(
      {Key key,
      @required this.child,
      this.width = 120,
      this.height = 40,
      this.totalTime = 15,
      this.sampleTime = .5,
      this.isEnabled = true,
      this.align,
      this.showText = true})
      : super(key: key) {
    assert(width >= 100, "Width must be at least 100px");
    assert(sampleTime > 0, "Sample time must be > 0.");
    assert(totalTime >= sampleTime * 2, "Total time must at least twice the sample time.");
    assert((showText != true || height >= 30), "If showText=true, height must be at least 30px");
    assert((height >= 8), "Height must be at least 8px");
    assert(child != null, "Child can't be null.");
  }

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
    double lastFps = _entries.isNotEmpty? _entries.last.fps : 60;
    return RepaintBoundary(
      child: CustomPaint(
          foregroundPainter: _StatsPainter(state: this),
          child: Container(
            padding: EdgeInsets.only(left: 4, top: 2),
            width: widget.width,
            height: widget.height,
            color: Colors.black54.withOpacity(.8),
            child: widget.showText
                ? Text(
                    "${fToString(_fps)} FPS (${fToString(minFps)}-${fToString(maxFps)})",
                    style: TextStyle(color: getColorForFps(lastFps), fontWeight: FontWeight.bold, fontSize: 11),
                  )
                : Container(),
          )),
    );
  }

  Color getColorForFps(double fps) {
    if (fps < 30) return Colors.redAccent;
    if (fps < 45) return Colors.orange;
    if (fps < 60) return Colors.yellow;
    return Colors.green;
  }
}

class FpsEntry {
  double fps;
  int time;

  FpsEntry(this.time, this.fps);
}

class _StatsPainter extends CustomPainter {
  final _StatsFlState state;

  double get topPadding => state.widget.showText ? 20 : 4;

  _StatsPainter({this.state});

  double getYForFps(double fps, double maxHeight) => maxHeight - 2 - (min((fps / 60), 1) * (maxHeight - topPadding));

  @override
  void paint(Canvas canvas, Size size) {
    state._shouldRepaint = false;
    double maxXAxis = state.totalTimeMs;
    double colWidth = size.width / (maxXAxis / state.sampleTimeMs);
    for (var e in state._entries) {
      Color c = state.getColorForFps(e.fps);
      double x = size.width - colWidth - ((state.nowMs - e.time) / maxXAxis) * size.width;
      double y = getYForFps(e.fps, size.height);
      canvas.drawRect(Rect.fromLTWH(x, y, colWidth + .5, 2), Paint()..color = c);
      canvas.drawRect(Rect.fromLTWH(x, y + 3, colWidth + .5, size.height - y), Paint()..color = c.withOpacity(.2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => state._shouldRepaint;
}
