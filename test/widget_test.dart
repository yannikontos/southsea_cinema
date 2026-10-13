import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';

void main() {
  testWidgets('initial home screen shows movies and booking buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    expect(find.text('Southsea Cinema'), findsOneWidget);
    expect(find.text('THE ODYSSEY'), findsOneWidget);
    expect(find.text('DUNE: PART TWO'), findsOneWidget);
    expect(find.text('BOOK NOW'), findsNWidgets(2));
  });

  testWidgets('booking a movie opens the listing and confirms its order',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'BOOK NOW').first);
    await tester.pumpAndSettle();

    expect(find.text('THE ODYSSEY'), findsOneWidget);
    expect(find.text('(15)'), findsOneWidget);
    expect(find.text('Southsea Cinema Room'), findsOneWidget);
    expect(find.text('Thursday 8 Oct 2026 12:40'), findsOneWidget);
    expect(find.text('Adult (£11.00)'), findsOneWidget);
    expect(find.text('ADD TO ORDER'), findsOneWidget);

    await tester.tap(find.byType(DropdownMenu<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('ADD TO ORDER'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ADD TO ORDER'));
    await tester.pumpAndSettle();

    expect(find.text('Added to order'), findsOneWidget);
    expect(find.textContaining('Added 1 adult ticket to your order.'),
        findsOneWidget);
    expect(find.textContaining('Total: £11.00'), findsOneWidget);
  });
}
