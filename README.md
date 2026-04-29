# flutter_user_idle

[![pub package](https://img.shields.io/pub/v/flutter_user_idle.svg)](https://pub.dev/packages/flutter_user_idle)
[![likes](https://img.shields.io/pub/likes/flutter_user_idle)](https://pub.dev/packages/flutter_user_idle/score)
[![popularity](https://img.shields.io/pub/popularity/flutter_user_idle)](https://pub.dev/packages/flutter_user_idle/score)
[![pub points](https://img.shields.io/pub/points/flutter_user_idle)](https://pub.dev/packages/flutter_user_idle/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A simple and lightweight Flutter package to detect user inactivity (idle state) and trigger callbacks when the user becomes idle or active again.

---

## ✨ Features

* Detect user inactivity (idle)
* Trigger callback when user becomes idle
* Detect when user becomes active again
* Lightweight and efficient
* Easy integration with any Flutter app

---

## 🚀 Why This Package?

Handling user inactivity is a common requirement in apps like:

* 🔐 Auto logout systems
* 💤 Session timeout handling
* 📊 User activity tracking
* 🔄 Auto refresh after inactivity

This package provides a simple way to detect inactivity without complex setup.

---

## 📦 Installation

Add this to your `pubspec.yaml`:
```yaml
dependencies:
  flutter_user_idle: ^0.1.0
```

---

## 🧑‍💻 Usage

Wrap your widget tree with `IdleDetector` inside `MaterialApp`:
```dart
import 'package:flutter_user_idle/flutter_user_idle.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool _isIdle = false;

  @override
  Widget build(BuildContext context) {
    return IdleDetector(
      timeout: const Duration(minutes: 5),
      onIdle: () => setState(() => _isIdle = true),
      onActive: () => setState(() => _isIdle = false),
      child: Scaffold(
        body: Center(
          child: Text(_isIdle ? 'Idle 😴' : 'Active 🟢'),
        ),
      ),
    );
  }
}
```

> ⚠️ Place `IdleDetector` **inside** `MaterialApp`, not above it.

---

## 🧪 Example

Check the `/example` folder for a complete working demo.

---

## ⚙️ Parameters

| Parameter | Type           | Required | Description                           |
| --------- | -------------- | -------- | ------------------------------------- |
| timeout   | Duration       | ✅ Yes   | Time before user is considered idle   |
| onIdle    | VoidCallback   | ✅ Yes   | Called when user becomes idle         |
| onActive  | VoidCallback?  | ❌ No    | Called when user becomes active again |
| child     | Widget         | ✅ Yes   | Your widget tree                      |

---

## 📱 Behavior

| State                | Supported           |
| -------------------- | ------------------- |
| Foreground           | ✅ Yes               |
| Background           | ❌ No                |
| App Resume Detection | ⚠️ Manual handling  |

---

## 🧠 How it works

The package listens to pointer events (taps, scrolls, gestures) anywhere in the widget subtree.
If no interaction is detected within the given `timeout`, the user is marked as idle and `onIdle` fires.
Once interaction resumes, `onActive` is triggered.

---

## 💡 Best Practices

* Place `IdleDetector` inside `MaterialApp` at the screen level, not above it
* Use for session timeout or auto logout
* Combine with app lifecycle for better accuracy
* Avoid very short timeout durations in production

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

---

## 👤 Author

AZHARKC  
GitHub: https://github.com/AZHARKC

---

## 📄 License

MIT License

---

⭐ If you find this package useful, consider starring the repository!