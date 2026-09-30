import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
    return const [
      Movie(
          id: 'id',
          title: 'title',
          ageRating: 'ageRating',
          description: 'description',
          imagePath: 'imagePath')
    ];
  }
}
