import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/views/movie_basket.dart';

const Movie testMovie = Movie(
  id: 'odyssey2026',
  title: 'The Odyssey',
  ageRating: '15',
  description: 'A test movie.',
  ticketPrice: 11,
  imagePath: '#',
  screeningTime: ['Thursday 8 Oct 2026 12:40'],
);

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  testWidgets(
    'MovieBasket displays empty message when basket has no items',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MovieBasket()));

      expect(find.text('Your basket is empty'), findsOneWidget);
      expect(find.text('BUY TICKETS'), findsNothing);
    },
  );

  testWidgets(
    'MovieBasket renders items and removes item when delete pressed',
    (WidgetTester tester) async {
      final CartItem item = CartItem(
        movie: testMovie,
        quantity: 2,
        screeningTime: 'Thursday 8 Oct 2026 12:40',
      );
      CartRepository.instance.addItem(item);

      await tester.pumpWidget(const MaterialApp(home: MovieBasket()));

      expect(find.text('MY ORDER'), findsOneWidget);
      expect(find.text('2 Tickets'), findsOneWidget);
      expect(find.text('2 Standard'), findsOneWidget);
      expect(find.text('THE ODYSSEY'), findsOneWidget);
      expect(find.text('Thursday 8 Oct 2026 12:40'), findsOneWidget);
      expect(find.text('£22.00'), findsOneWidget);
      expect(find.text('£23.50'), findsOneWidget);
      expect(find.text('BUY TICKETS'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(find.text('Your basket is empty'), findsOneWidget);
    },
  );

  testWidgets(
    'MovieBasket clears purchased tickets and confirms the order',
    (WidgetTester tester) async {
      CartRepository.instance.addItem(
        CartItem(
          movie: testMovie,
          quantity: 2,
          screeningTime: 'Thursday 8 Oct 2026 12:40',
        ),
      );

      await tester.pumpWidget(const MaterialApp(home: MovieBasket()));

      expect(find.text('2 Tickets'), findsOneWidget);
      expect(find.text('BUY TICKETS'), findsOneWidget);

      await tester.ensureVisible(find.text('BUY TICKETS'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('BUY TICKETS'));
      await tester.pumpAndSettle();

      expect(CartRepository.instance.getItems(), isEmpty);
      expect(find.text('Your basket is empty'), findsOneWidget);
      expect(find.text('Your order has been confirmed.'), findsOneWidget);
      expect(find.text('BUY TICKETS'), findsNothing);
    },
  );
}
