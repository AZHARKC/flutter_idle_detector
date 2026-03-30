import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_user_idle/flutter_user_idle.dart';
import 'package:flutter_user_idle/src/idle_manager.dart';

void main() {
  group('IdleManager', () {
    test('initializes without error', () {
      expect(
        () => IdleManager(
          timeout: const Duration(seconds: 30),
          onIdle: () {},
        ),
        returnsNormally,
      );
    });

    //  fakeAsync + pump instead of real Future.delayed — tests run
    // instantly and aren't flaky due to timing on slow CI machines
    test('calls onIdle after timeout', () {
      fakeAsync((fake) {
        bool idleCalled = false;

        final manager = IdleManager(
          timeout: const Duration(milliseconds: 100),
          onIdle: () => idleCalled = true,
        );

        manager.start();
        fake.elapse(const Duration(milliseconds: 150));

        expect(idleCalled, true);
        manager.dispose();
      });
    });

    test('does not call onIdle if user interacts before timeout', () {
      fakeAsync((fake) {
        bool idleCalled = false;

        final manager = IdleManager(
          timeout: const Duration(milliseconds: 100),
          onIdle: () => idleCalled = true,
        );

        manager.start();
        fake.elapse(const Duration(milliseconds: 50));
        manager.userInteracted(); // resets timer
        fake.elapse(const Duration(milliseconds: 50));

        expect(idleCalled, false); //  timer was reset, not fired
        manager.dispose();
      });
    });

    test('calls onActive after user interacts post-idle', () {
      fakeAsync((fake) {
        bool activeCalled = false;

        final manager = IdleManager(
          timeout: const Duration(milliseconds: 100),
          onIdle: () {},
          onActive: () => activeCalled = true,
        );

        manager.start();
        fake.elapse(const Duration(milliseconds: 150));
        manager.userInteracted();

        expect(activeCalled, true);
        manager.dispose();
      });
    });

    // onActive should NOT fire if user wasn't idle yet
    test('does not call onActive if user was not idle', () {
      fakeAsync((fake) {
        bool activeCalled = false;

        final manager = IdleManager(
          timeout: const Duration(milliseconds: 100),
          onIdle: () {},
          onActive: () => activeCalled = true,
        );

        manager.start();
        fake.elapse(const Duration(milliseconds: 50));
        manager.userInteracted(); // interacts before going idle

        expect(activeCalled, false);
        manager.dispose();
      });
    });

    test('dispose cancels timer without error', () {
      final manager = IdleManager(
        timeout: const Duration(seconds: 10),
        onIdle: () {},
      );
      manager.start();
      expect(() => manager.dispose(), returnsNormally);
    });
  });

  group('IdleDetector', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            timeout: const Duration(seconds: 30),
            onIdle: () {},
            child: const Text('hello'),
          ),
        ),
      );
      expect(find.byType(IdleDetector), findsOneWidget);
      expect(
          find.text('hello'), findsOneWidget); //  actually checks child renders
    });

    testWidgets('calls onIdle after timeout on pointer inactivity',
        (WidgetTester tester) async {
      fakeAsync((fake) {
        bool idleCalled = false;

        tester.pumpWidget(
          MaterialApp(
            home: IdleDetector(
              timeout: const Duration(seconds: 5),
              onIdle: () => idleCalled = true,
              child: const SizedBox.expand(),
            ),
          ),
        );

        fake.elapse(const Duration(seconds: 6));

        expect(idleCalled, true);
      });
    });

    testWidgets('calls onActive after pointer down post-idle',
        (WidgetTester tester) async {
      fakeAsync((fake) {
        bool activeCalled = false;

        tester.pumpWidget(
          MaterialApp(
            home: IdleDetector(
              timeout: const Duration(seconds: 5),
              onIdle: () {},
              onActive: () => activeCalled = true,
              child: const SizedBox.expand(),
            ),
          ),
        );

        fake.elapse(const Duration(seconds: 6)); // go idle
        tester.tap(find.byType(SizedBox)); // interact
        fake.flushMicrotasks();

        expect(activeCalled, true);
      });
    });
  });
}
