# statsfl - A simple FPS monitor for Flutter

<img src="https://screens.gskinner.com/shawn/chrome_2020-04-12_22-11-09.png" alt="" />

## 🔨 Installation
```yaml
dependencies:
  statsfl: ^2.2.0+1
```

### ⚙ Import

```dart
import 'package:statsfl/statsfl.dart';
```

## 🕹️ Usage

Just wrap your root view in the StatsFl widget:
```dart
StatsFl(child: MyApp());
```

There are a few additional options you can play with:
```dart
return StatsFl(
        isEnabled: true, //Toggle on/off
        width: 600, //Set size
        height: 20, //
        maxFps: 90, // Support custom FPS target (default is 60)
        showText: true, // Hide text label
        sampleTime: .5, //Interval between fps calculations, in seconds.
        totalTime: 15, //Total length of timeline, in seconds.
        align: Alignment.topLeft, //Alignment of statsbox
        child: MyApp());
```

## 🐞 Bugs/Requests

If you encounter any problems please open an issue. If you feel the library is missing a feature, please raise a ticket on Github and we'll look into it. Pull request are welcome.

## 📃 License

MIT License
