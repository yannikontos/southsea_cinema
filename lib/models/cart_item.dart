import 'package:southsea_cinema/models/movie.dart';

class CartItem {
  final Movie movie;
  final int quantity;
  final String? screeningTime;

  CartItem({
    required this.movie,
    required this.quantity,
    this.screeningTime,
  });

  double get itemTotal {
    return movie.ticketPrice * quantity;
  }
}
