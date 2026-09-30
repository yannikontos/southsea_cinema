import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
    return const [
      Movie(
          id: 'odyssey2026',
          title: 'The Odyssey',
          ageRating: '15',
          description:
              'Odysseus, king of Ithaca, embarks on a perilous journey to return home after the Trojan War. Crossing the Mediterranean Sea with his fellow soldiers, they soon find themselves battling not only the elements, but an array of deadly obstacles and mythical creatures along the way.',
          imagePath: 'images/odyssey_poster.png'),
      Movie(
          id: 'dune2024',
          title: 'Dune: Part Two',
          ageRating: '12',
          description:
              'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family. Facing a choice between the love of his life and the fate of the universe, he must prevent a terrible future only he can foresee.',
          imagePath: 'images/dune2_poster.png')
    ];
  }
}
