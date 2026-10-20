import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';

const Movie testMovie = Movie(
    id: 'test_movie_1',
    title: 'Test Movie',
    ageRating: '16',
    description: 'A test movie description',
    ticketPrice: 10.0,
    imagePath: 'assets/images/dune2_poster.png',
    screeningTime: ['12:00', '15:00', '18:00']);

const Movie testMovie2 = Movie(
    id: 'test_movie_2',
    title: 'Test Movie 2',
    ageRating: 'PG',
    description: 'Another test movie description',
    ticketPrice: 12.0,
    imagePath: 'assets/images/odyssey_poster.png',
    screeningTime: ['18:00', '20:00', '21:00']);

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  group('CartRepository initial state tests', () {
    test('starts with clear basket and no totals', () {
      final CartRepository cart = CartRepository.instance;

      expect(cart.getItems(), isEmpty);
      expect(cart.getTotalItems(), 0);
      expect(cart.totalItemCount, 0);
      expect(cart.getTotalPrice(), 0.0);
      expect(cart.getDeliveryFee(), 0.0);
      expect(cart.getTotalDue(), 0.0);
    });

    test('adds items and calculates subtotal and delivery fee correctly', () {
      final CartRepository cart = CartRepository.instance;

      cart.addItem(CartItem(movie: testMovie, quantity: 2));
      cart.addItem(CartItem(movie: testMovie2, quantity: 1));

      expect(cart.getItems().length, 2);
      expect(cart.getTotalItems(), 3);
      expect(cart.totalItemCount, 3);
      expect(cart.getTotalPrice(), 32.0);
      expect(cart.getDeliveryFee(), 1.50);
      expect(cart.getTotalDue(), 33.50);
    });

    test('removes items correctly', () {
      final CartRepository cart = CartRepository.instance;

      cart.addItem(CartItem(movie: testMovie, quantity: 2));
      expect(cart.getItems().length, 1);

      cart.removeItem(0);
      expect(cart.getItems().length, 0);
      expect(cart.getTotalDue(), 0.0);
    });
  });
}
