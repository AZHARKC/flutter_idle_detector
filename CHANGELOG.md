## 0.1.1

- Enrich package description with keywords (auto-logout, session timeout, user activity tracking) for better pub.dev search ranking
- Remove broken demo.gif reference from README
- Fix example app to use the renamed `flutter_user_idle` package (pubspec dependency + import)

## 0.1.0

- Add dartdoc comments to all public API elements (IdleDetector class, constructor, and all fields)
- Add library-level documentation to `flutter_user_idle.dart`
- Remove `IdleManager` from public export (internal implementation detail)
- Fix missing type annotation: `[_]` → `[dynamic _]` in `_onUserInteraction`
- Add `didUpdateWidget` to handle runtime timeout/callback changes
- Refactor example app: correct `MaterialApp`/`IdleDetector` nesting
- Improve test coverage with `fakeAsync` for deterministic timer tests

## 0.0.1

- Initial release