import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_btn.dart';

class MovieBasket extends StatefulWidget {
  const MovieBasket({super.key});

  @override
  State<MovieBasket> createState() => _MovieBasketState();
}

class _MovieBasketState extends State<MovieBasket> {
  String _confirmationMessage = '';

  String _formatCurrency(double amount) => '£${amount.toStringAsFixed(2)}';

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Text(
          'Your basket is empty',
          style: TextStyle(fontSize: 16, color: cinemaFontMuted),
        ),
      ),
    );
  }

  Widget _buildBasket(CartRepository cart, List<CartItem> items) {
    const itemStyle = TextStyle(
      color: cinemaFontWhite,
      fontSize: 16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('MY ORDER', style: cinemaHeaderStyle),
        const SizedBox(height: 28),
        Row(
          children: [
            const Expanded(
                flex: 1, child: Text('Item', style: cinemaHeaderStyle)),
            const SizedBox(width: 12),
            const Expanded(
                flex: 2, child: Text('Details', style: cinemaHeaderStyle)),
            const Expanded(
              flex: 1,
              child: Text('Price',
                  textAlign: TextAlign.right, style: cinemaHeaderStyle),
            ),
            const SizedBox(width: 66),
          ],
        ),
        const SizedBox(height: 16),
        ...items.map((CartItem item) {
          final int index = items.indexOf(item);
          final String screeningTime = item.screeningTime ??
              (item.movie.screeningTime.isNotEmpty
                  ? item.movie.screeningTime.first
                  : '');

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '${item.quantity} Tickets',
                    style: const TextStyle(
                      color: cinemaBrandLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item.quantity} Standard', style: itemStyle),
                      Text(item.movie.title.toUpperCase(), style: itemStyle),
                      if (screeningTime.isNotEmpty)
                        Text(screeningTime, style: itemStyle),
                      const Text('Southsea Cinema Room', style: itemStyle),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    _formatCurrency(item.itemTotal),
                    textAlign: TextAlign.right,
                    style: itemStyle,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 55,
                  height: 55,
                  child: IconButton(
                    tooltip: 'Remove ${item.movie.title} from order',
                    onPressed: () {
                      setState(() {
                        cart.removeItem(index);
                      });
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: cinemaBrandLight,
                      foregroundColor: cinemaFontWhite,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline, size: 25),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Service Charge', style: itemStyle),
            Text(_formatCurrency(cart.getDeliveryFee()), style: itemStyle),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Due',
              style: TextStyle(
                color: cinemaFontWhite,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _formatCurrency(cart.getTotalDue()),
              style: const TextStyle(
                color: cinemaFontWhite,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 23),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: PrimaryBtn(
                  label: 'UPDATE ORDER',
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: cinemaSurface,
                        title: const Text(
                          'Order updated',
                          style: TextStyle(color: cinemaFontWhite),
                        ),
                        content: Text(
                          'Your order total is '
                          '${_formatCurrency(cart.getTotalDue())}.',
                          style: const TextStyle(color: cinemaFontWhite),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: PrimaryBtn(
                  label: 'BUY TICKETS',
                  onPressed: () {
                    setState(() {
                      cart.clear();
                      _confirmationMessage = 'Your order has been confirmed.';
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> items = cart.getItems();

    final Widget content;
    if (items.isEmpty) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmptyState(),
          if (_confirmationMessage.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              _confirmationMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ],
      );
    } else {
      content = _buildBasket(cart, items);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(appTitle, style: cinemaHeaderStyle),
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: content,
      ),
    );
  }
}
