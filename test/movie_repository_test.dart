import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MovieRepository repository;
  late List<Movie> movies;

  setUp(() async {
    repository = MovieRepository();
    movies = await repository.loadMoviesFromAsset();
  });

  group('MovieRepository', () {
    test('loads every movie from the asset and caches the result', () async {
      expect(movies, hasLength(3));
      expect(movies.map((movie) => movie.id), [
        'odyssey2026',
        'dune2024',
        'scream1996',
      ]);
      expect(movies.map((movie) => movie.title), [
        'The Odyssey',
        'Dune: Part Two',
        'Scream',
      ]);
      expect(await repository.loadMoviesFromAsset(), same(movies));
      expect(repository.getMovies(), same(movies));
    });

    test('every movie has a non-empty, unique id', () {
      final ids = movies.map((movie) => movie.id).toSet();

      for (final movie in movies) {
        expect(movie.id, isNotEmpty);
      }
      expect(ids, hasLength(movies.length));
    });

    test('every movie has a non-empty title and age rating', () {
      for (final movie in movies) {
        expect(movie.title, isNotEmpty);
        expect(movie.ageRating, isNotEmpty);
      }
    });

    test('every movie has a ticket price greater than zero', () {
      for (final movie in movies) {
        expect(movie.ticketPrice, greaterThan(0));
      }
    });

    test('getMovieById returns the matching movie or null when not found', () {
      final Movie? movie = repository.getMovieById('odyssey2026');

      expect(movie, isNotNull);
      expect(movie?.title, 'The Odyssey');
      expect(movie?.ticketPrice, 11.00);
      expect(repository.getMovieById('missing-movie'), isNull);
    });

    test('getMoviesByAgeRating returns matching movies', () {
      final List<Movie> matchingMovies = repository.getMoviesByAgeRating('12');

      expect(matchingMovies, hasLength(1));
      expect(matchingMovies.first.title, 'Dune: Part Two');
      expect(matchingMovies.first.ageRating, '12');
      expect(repository.getMoviesByAgeRating('99'), isEmpty);
    });

    test('getMoviesUnderPrice returns movies below the specified amount', () {
      final List<Movie> matchingMovies = repository.getMoviesUnderPrice(15);

      expect(matchingMovies, hasLength(2));
      expect(matchingMovies.first.title, 'The Odyssey');
      expect(matchingMovies.first.ticketPrice, 11.00);
      expect(repository.getMoviesUnderPrice(5), isEmpty);
    });
  });
}
