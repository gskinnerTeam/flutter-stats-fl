# statsfl - A simple FPS monitor for your Flutter Applications.

<img src="https://i.imgur.com/ejWwkTe.png" alt="" />

## 🔨 Installation
```yaml
dependencies:
  statsfl: ^0.0.1
```

### ⚙ Import

```dart
import 'package:statsfl/statsfl.dart';
```

## 🕹️ Usage

Just wrap your root view in the StatsFl widget:
```dart
StatsFl(child: MaterialApp());
```

There are a few additional options you can play with:
```dart
return StatsFl(
        isEnabled: true, //Toggle on/off
        width: 600, //Set size
        sampleTime: .5, //Interval between fps calculations, in seconds.
        totalTime: 15, //Total length of timeline, in seconds.
        align: Alignment.topLeft, //Alignment of statsbox
        child: someChild;
```

## 🐞 Bugs/Requests

If you encounter any problems please open an issue. If you feel the library is missing a feature, please raise a ticket on Github and we'll look into it. Pull request are welcome.

## 📃 License

MIT License
