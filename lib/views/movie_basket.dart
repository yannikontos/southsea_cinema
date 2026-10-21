import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';

class MovieBasket extends StatefulWidget {
  const MovieBasket({super.key});

  @override
  State<MovieBasket> createState() {
    return _MovieBasketState();
  }
}

class _MovieBasketState extends State<MovieBasket> {
  String _confirmationMessage = '';

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Your basket is empty',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildBasket() {
    CartRepository cart = CartRepository.instance;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'MY ORDER',
          style: cinemaHeaderStyle,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: Text('Item')),
            Expanded(flex: 2, child: Text('Details')),
            Expanded(flex: 1, child: Text('Price')),
          ],
        ),

        // Column(
        //   children: cart.getItems().map((CartItem item) {
        //   return Row(children: [
        //     Expanded(flex: 1, child: Text('${item.quantity} Tickets')),
        //   Expanded(flex: 2, child: Text(item.movie.description)),
        //   Expanded(flex: 1, child: Text(item.movie.formattedPrice)),
        //   ])
        // })
        // )
      ],
    );
  }

  Widget _buildTicketCard() {
    CartRepository cart = CartRepository.instance;

    cart.getItems().map((CartItem item) {
      return Row(
        children: [
          Expanded(flex: 1, child: Text('${item.quantity} Tickets')),
          Expanded(flex: 2, child: Text(item.movie.description)),
          Expanded(flex: 1, child: Text(item.movie.formattedPrice)),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> items = cart.getItems();

    final Widget content;
    if (items.isEmpty) {
      if (_confirmationMessage.isNotEmpty) {
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmptyState(),
            const SizedBox(height: 12),
            Text(
              _confirmationMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      } else {
        content = _buildEmptyState();
      }
    } else {
      content = _buildBasket();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appTitle,
          style: cinemaHeaderStyle,
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(12), child: content),
    );
  }
}
