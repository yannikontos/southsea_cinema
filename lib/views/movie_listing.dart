import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_btn.dart';

class MovieListing extends StatelessWidget {
  final Movie movie;
  final String screeningTime;

  const MovieListing({
    super.key,
    required this.movie,
    required this.screeningTime,
  });

  Widget _buildMovieDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  movie.title.toUpperCase(),
                  style: const TextStyle(
                    color: cinemaBrand,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '(${movie.ageRating})',
                style: const TextStyle(
                  color: cinemaFontMuted,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            movie.description,
            style: const TextStyle(color: cinemaFontWhite, fontSize: 16),
          ),
        ],
      );

  Widget _buildScreeningDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Southsea Cinema Room',
            style: TextStyle(color: cinemaFontWhite, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            screeningTime,
            style: const TextStyle(color: cinemaFontWhite, fontSize: 16),
          ),
          const SizedBox(height: 25),
          const Text(
            'Please note that Discounts / Membership Benefits '
            'will be applied once you have selected your tickets',
            style: TextStyle(color: cinemaFontWhite, fontSize: 16),
          ),
          const SizedBox(height: 24),
          const Text(
            'Select Quantities (Up to 5 in total)',
            style: TextStyle(color: cinemaFontWhite, fontSize: 16),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            appTitle,
            style: cinemaHeaderStyle,
          ),
        ),
        drawer: const NavDrawer(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 1400;
            final isMedium = constraints.maxWidth >= 600;
            final isSmall = constraints.maxWidth < 600;
            final detailsLayout = isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildMovieDetails()),
                      const SizedBox(width: 45),
                      Expanded(child: _buildScreeningDetails()),
                      const SizedBox(width: 45),
                      Expanded(
                        child: TicketSelection(
                          movie: movie,
                          screeningTime: screeningTime,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isMedium)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildMovieDetails()),
                            const SizedBox(width: 45),
                            Expanded(child: _buildScreeningDetails()),
                          ],
                        )
                      else if (isSmall) ...[
                        _buildMovieDetails(),
                        const SizedBox(height: 25),
                        _buildScreeningDetails(),
                      ],
                      const SizedBox(height: 30),
                      TicketSelection(
                        movie: movie,
                        screeningTime: screeningTime,
                      ),
                    ],
                  );

            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                color: cinemaBackground,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailsLayout,
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      );
}

class TicketSelection extends StatefulWidget {
  final Movie movie;
  final String screeningTime;

  const TicketSelection({
    super.key,
    required this.movie,
    required this.screeningTime,
  });

  @override
  State<TicketSelection> createState() => _TicketSelectionState();
}

class _TicketSelectionState extends State<TicketSelection> {
  int _ticketQuantity = 0;

  void _orderResult() {
    final bool ticketsChosen = _ticketQuantity > 0;
    final double totalPrice = _ticketQuantity * widget.movie.ticketPrice;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: cinemaSurface,
        title: Text(
          ticketsChosen ? 'Added to order' : 'No tickets selected',
          style: const TextStyle(fontSize: 18, color: cinemaFontWhite),
        ),
        content: Text(
          ticketsChosen
              ? 'Added $_ticketQuantity adult ticket'
                  '${_ticketQuantity == 1 ? '' : 's'} to your order.\n'
                  'Total: £${totalPrice.toStringAsFixed(2)}'
              : 'Please select at least one ticket before adding to your order.',
        ),
        actionsAlignment: MainAxisAlignment.start,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: cinemaBrand,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(right: 24),
            ),
            child: const Text('OK'),
          ),
        ],
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: cinemaFontWhite,
        ),
      ),
    );

    if (ticketsChosen) {
      final CartItem item = CartItem(
        movie: widget.movie,
        quantity: _ticketQuantity,
        screeningTime: widget.screeningTime,
      );
      CartRepository.instance.addItem(item);
    }
  }

  void _setTicketQuantity(int quantity) {
    setState(() => _ticketQuantity = quantity);
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tickets',
            style: cinemaHeaderStyle,
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              DropdownMenu<int>(
                initialSelection: 0,
                onSelected: (int? value) {
                  if (value != null) {
                    _setTicketQuantity(value);
                  }
                },
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 0, label: '0'),
                  DropdownMenuEntry(value: 1, label: '1'),
                  DropdownMenuEntry(value: 2, label: '2'),
                  DropdownMenuEntry(value: 3, label: '3'),
                  DropdownMenuEntry(value: 4, label: '4'),
                  DropdownMenuEntry(value: 5, label: '5'),
                ],
              ),
              const SizedBox(width: 10),
              Text(
                'Adult (${widget.movie.formattedPrice})',
                style: TextStyle(color: cinemaFontWhite, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          PrimaryBtn(label: 'ADD TO ORDER', onPressed: _orderResult),
        ],
      );
}
