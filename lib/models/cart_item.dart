import 'package:southsea_cinema/models/movie.dart';

class CartItem {
  final Movie movie;
  final int quantity;

  CartItem({required this.movie, required this.quantity});

  double get itemTotal {
    return movie.ticketPrice * quantity;
  }
}
