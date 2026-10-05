import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  group('MovieRepository', () {
    test('getMovies returns at least two movies', () {
      final repository = MovieRepository();
      final movies = repository.getMovies();

      expect(movies, hasLength(greaterThanOrEqualTo(2)));
    });

    test('every movie has a non-empty, unique id', () {
      final repository = MovieRepository();
      final movies = repository.getMovies();
      final ids = movies.map((movie) => movie.id).toSet();

      for (final movie in movies) {
        expect(movie.id, isNotEmpty);
      }
      expect(ids, hasLength(movies.length));
    });

    test('every movie has a non-empty title and age rating', () {
      final repository = MovieRepository();
      final movies = repository.getMovies();

      for (final movie in movies) {
        expect(movie.title, isNotEmpty);
        expect(movie.ageRating, isNotEmpty);
      }
    });

    test('every movie has a ticket price greater than zero', () {
      final repository = MovieRepository();
      final movies = repository.getMovies();

      for (final movie in movies) {
        expect(movie.ticketPrice, greaterThan(0));
      }
    });

    test('getMovieById returns the matching movie or null when not found', () {
      final repository = MovieRepository();
      final Movie? movie = repository.getMovieById('odyssey2026');

      expect(movie, isNotNull);
      expect(movie?.id, 'odyssey2026');
      expect(movie?.title, 'The Odyssey');
      expect(movie?.ticketPrice, 11.00);
      expect(repository.getMovieById('missing-movie'), isNull);
    });

    test(
        'getMoviesByAgeRating returns all movies with the specified age rating',
        () {
      final repository = MovieRepository();
      final movies = repository.getMoviesByAgeRating('12');

      expect(movies, hasLength(1));
      expect(movies.first.title, 'Dune: Part Two');
      expect(movies.first.ageRating, '12');

      expect(repository.getMoviesByAgeRating('99'), isEmpty);
    });

    test('getMoviesUnderPrice returns all movies under the specified amount',
        () {
      final repository = MovieRepository();
      final movies = repository.getMoviesUnderPrice(15.00);

      expect(movies, hasLength(1));
      expect(movies.first.title, 'The Odyssey');
      expect(movies.first.ticketPrice, 11.00);

      expect(repository.getMoviesUnderPrice(10.00), isEmpty);
    });
  });
}
