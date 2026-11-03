import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie>? _cachedMovies;

  List<Movie> getMovies() {
    final List<Movie>? cachedMovies = _cachedMovies;

    if (cachedMovies != null) {
      return cachedMovies;
    }
    return const [
      Movie(
          id: 'odyssey2026',
          title: 'The Odyssey',
          ageRating: '15',
          description:
              'Odysseus, king of Ithaca, embarks on a perilous journey to return home after the Trojan War. Crossing the Mediterranean Sea with his fellow soldiers, they soon find themselves battling not only the elements, but an array of deadly obstacles and mythical creatures along the way.',
          ticketPrice: 11,
          imagePath: 'images/odyssey_poster.png',
          screeningTime: ['Thursday 8 Oct 2026 12:40']),
      Movie(
          id: 'dune2024',
          title: 'Dune: Part Two',
          ageRating: '12',
          description:
              'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family. Facing a choice between the love of his life and the fate of the universe, he must prevent a terrible future only he can foresee.',
          ticketPrice: 19,
          imagePath: 'images/dune2_poster.png',
          screeningTime: ['Friday 9 Oct 2026 11:20'])
    ];
  }

  Movie? getMovieById(String id) {
    for (final movie in getMovies()) {
      if (movie.id == id) {
        return movie;
      }
    }
    return null;
  }

  Future<List<Movie>> loadMoviesFromAsset({
    String assetPath = 'assets/data/movies.json',
  }) async {
    if (_cachedMovies != null) {
      return _cachedMovies!;
    }

    final String jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> jsonList = jsonDecode(jsonString);

    _cachedMovies = jsonList
        .map((jsonItem) => Movie.classFromJson(jsonItem))
        .toList(growable: false);

    return _cachedMovies!;
  }

  List<Movie> getMoviesByAgeRating(String rating) {
    return getMovies().where((movie) => movie.ageRating == rating).toList();
  }

  List<Movie> getMoviesUnderPrice(double maxPrice) {
    return getMovies().where((movie) => movie.ticketPrice < maxPrice).toList();
  }
}
