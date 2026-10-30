import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/views/account_settings.dart';

void main() {
  testWidgets('AccountSettings renders editable customer fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AccountSettings()),
    );

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
    await tester.pump();

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
    expect(emailField.controller!.text, 'dummy@temp.com');
    expect(find.text('Settings changes cancelled.'), findsOneWidget);
  });
}
