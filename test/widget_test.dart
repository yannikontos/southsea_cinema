import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';
import 'package:southsea_cinema/widgets/primary_btn.dart';

Future<void> pumpAppAndWaitForMovies(WidgetTester tester) async {
  await tester.pumpWidget(const SouthseaCinemaApp());
  for (var attempt = 0;
      attempt < 20 && find.byType(MovieCard).evaluate().isEmpty;
      attempt++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(find.byType(MovieCard), findsWidgets);
}

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  testWidgets('initial home screen shows movies and booking buttons', (
    WidgetTester tester,
  ) async {
    await pumpAppAndWaitForMovies(tester);

    expect(find.text('Southsea Cinema'), findsOneWidget);
    expect(find.text('THE ODYSSEY'), findsOneWidget);
    expect(find.text('DUNE: PART TWO'), findsOneWidget);
    expect(find.text('BOOK NOW'), findsNWidgets(2));

    await tester.scrollUntilVisible(find.text('SCREAM'), 200);
    expect(find.text('SCREAM'), findsOneWidget);
  });

  testWidgets('booking a movie opens the listing and confirms its order', (
    WidgetTester tester,
  ) async {
    await pumpAppAndWaitForMovies(tester);

    await tester.tap(find.widgetWithText(PrimaryBtn, 'BOOK NOW').first);
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
    expect(
      find.textContaining('Added 1 adult ticket to your order.'),
      findsOneWidget,
    );
    expect(find.textContaining('Total: £11.00'), findsOneWidget);
  });

  testWidgets(
    'asset-loaded movies can be added, removed, and checked out in memory',
    (WidgetTester tester) async {
      await pumpAppAndWaitForMovies(tester);

      for (var ticketEntry = 0; ticketEntry < 2; ticketEntry++) {
        await tester.tap(find.widgetWithText(PrimaryBtn, 'BOOK NOW').first);
        await tester.pumpAndSettle();

        await tester.tap(find.byType(DropdownMenu<int>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('1').last);
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('ADD TO ORDER'));
        await tester.tap(find.text('ADD TO ORDER'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        tester.state<NavigatorState>(find.byType(Navigator).first).pop();
        await tester.pumpAndSettle();
      }

      expect(CartRepository.instance.getItems(), hasLength(2));
      expect(
        CartRepository.instance.getItems().every(
              (item) => item.movie.id == 'odyssey2026',
            ),
        isTrue,
      );

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('My Basket'));
      await tester.pumpAndSettle();

      expect(find.text('MY ORDER'), findsOneWidget);
      expect(find.text('1 Tickets'), findsNWidgets(2));
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();
      expect(CartRepository.instance.getItems(), hasLength(1));

      await tester.ensureVisible(find.text('BUY TICKETS'));
      await tester.tap(find.text('BUY TICKETS'));
      await tester.pumpAndSettle();

      expect(CartRepository.instance.getItems(), isEmpty);
      expect(find.text('Your order has been confirmed.'), findsOneWidget);
    },
  );
}
