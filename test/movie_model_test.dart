import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  group('Movie model tests', () {
    test('formattedPrice returns correct string', () {
      final movie = Movie(
        id: 'formatTest',
        title: 'Test Movie',
        ageRating: 'PG',
        description: 'A test movie.',
        ticketPrice: 5.0,
        imagePath: '#',
        screeningTime: ['Friday 9 Oct 2026 11:20'],
      );

      expect(movie.formattedPrice, '£5.00');
    });

    test('isChildFriendly returns true for U and PG ratings', () {
      final movieU = Movie(
        id: 'childFriendlyTest',
        title: 'Test Movie U',
        ageRating: 'U',
        description: 'A test movie.',
        ticketPrice: 10.0,
        imagePath: '#',
        screeningTime: ['Friday 16 Oct 2026 11:20'],
      );

      final moviePG = Movie(
        id: 'pgTest',
        title: 'Test Movie PG',
        ageRating: 'PG',
        description: 'A test movie.',
        ticketPrice: 2.0,
        imagePath: '#',
        screeningTime: ['Friday 2 Oct 2026 11:20'],
      );

      expect(movieU.isChildFriendly, isTrue);
      expect(moviePG.isChildFriendly, isTrue);
    });

    test('isAdultOnly returns false for non-18 ratings', () {
      final movie18 = Movie(
          id: 'test18',
          title: 'Test Movie 18',
          ageRating: '18',
          description: 'A test movie.',
          ticketPrice: 10.0,
          imagePath: '#',
          screeningTime: ['Friday 2 Oct 2026 11:20']);

      final movie16 = Movie(
        id: 'test16',
        title: 'Test Movie 16',
        ageRating: '16',
        description: 'A test movie.',
        ticketPrice: 10.0,
        imagePath: '#',
        screeningTime: ['Friday 2 Oct 2026 11:20'],
      );

      expect(movie18.isAdultOnly, isTrue);
      expect(movie16.isAdultOnly, isFalse);
    });
  });
}
