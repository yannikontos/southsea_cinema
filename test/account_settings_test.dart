import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/views/account_settings.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('AccountSettings renders editable customer fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AccountSettings()),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Settings'), findsOneWidget);
    expect(find.byKey(const Key('addressField')), findsOneWidget);
    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('patronNumberField')), findsOneWidget);
    expect(find.byKey(const Key('newsletterSwitch')), findsOneWidget);
  });

  testWidgets('AccountSettings saves changes and shows confirmation',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AccountSettings()),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('addressField')),
      'some location',
    );
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'new@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('patronNumberField')),
      '12345',
    );

    Switch newsletterSwitch = tester.widget<Switch>(
      find.byKey(const Key('newsletterSwitch')),
    );
    expect(newsletterSwitch.value, isFalse);

    await tester.ensureVisible(
      find.byKey(const Key('newsletterSwitch')),
    );
    await tester.tap(find.byKey(const Key('newsletterSwitch')));
    await tester.pump();

    newsletterSwitch = tester.widget<Switch>(
      find.byKey(const Key('newsletterSwitch')),
    );
    expect(newsletterSwitch.value, isTrue);

    await tester.ensureVisible(find.text('SAVE SETTINGS'));
    await tester.tap(find.text('SAVE SETTINGS'));
    await tester.pumpAndSettle();

    expect(
      find.text('Settings saved for patron: 12345'),
      findsOneWidget,
    );
  });

  testWidgets('AccountSettings cancel resets edited values',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AccountSettings()),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'changed@example.com',
    );
    await tester.ensureVisible(find.text('CANCEL'));
    await tester.tap(find.text('CANCEL'));
    await tester.pump();

    final TextField emailField = tester.widget<TextField>(
      find.byKey(const Key('emailField')),
    );
    expect(emailField.controller!.text, 'alex.morgan@example.com');
    expect(find.text('Settings changes cancelled.'), findsOneWidget);
  });

  testWidgets('AccountSettings restores saved fields after reopening',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AccountSettings()),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('addressField')),
      '17 Fiction Lane, Southsea',
    );
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'patron@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('patronNumberField')),
      '54321',
    );
    await tester.ensureVisible(find.byKey(const Key('newsletterSwitch')));
    await tester.tap(find.byKey(const Key('newsletterSwitch')));
    await tester.pump();

    await tester.ensureVisible(find.text('SAVE SETTINGS'));
    await tester.tap(find.text('SAVE SETTINGS'));
    await tester.pumpAndSettle();

    final SharedPreferencesAsync preferences = SharedPreferencesAsync();
    expect(
        await preferences.getString(prefAddress), '17 Fiction Lane, Southsea');
    expect(await preferences.getString(prefEmail), 'patron@example.com');
    expect(await preferences.getInt(prefPatronNumber), 54321);
    expect(await preferences.getBool(prefNewsletter), isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      const MaterialApp(home: AccountSettings()),
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TextField>(find.byKey(const Key('addressField')))
          .controller!
          .text,
      '17 Fiction Lane, Southsea',
    );
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('emailField')))
          .controller!
          .text,
      'patron@example.com',
    );
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('patronNumberField')))
          .controller!
          .text,
      '54321',
    );
    expect(
      tester.widget<Switch>(find.byKey(const Key('newsletterSwitch'))).value,
      isTrue,
    );
  });

  testWidgets('AccountSettings fills the form from existing preferences',
      (WidgetTester tester) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(<String, Object>{
      prefAddress: '17 Fiction Lane, Southsea',
      prefEmail: 'patron@example.com',
      prefPatronNumber: 54321,
      prefNewsletter: true,
    });

    await tester.pumpWidget(
      const MaterialApp(home: AccountSettings()),
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TextField>(find.byKey(const Key('addressField')))
          .controller!
          .text,
      '17 Fiction Lane, Southsea',
    );
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('emailField')))
          .controller!
          .text,
      'patron@example.com',
    );
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('patronNumberField')))
          .controller!
          .text,
      '54321',
    );
    expect(
      tester.widget<Switch>(find.byKey(const Key('newsletterSwitch'))).value,
      isTrue,
    );
  });
}
