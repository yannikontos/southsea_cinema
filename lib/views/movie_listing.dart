import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatelessWidget {
  const MovieListing({super.key});

  PreferredSizeWidget _buildAppBar() => AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      );

  Widget _buildMovieDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'The Odyssey (2026)',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Text('(15)', style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Odysseus, king of Ithaca, embarks on a perilous journey to '
            'return home after the Trojan War. Crossing the Mediterranean '
            'Sea with his fellow soldiers, they soon find themselves '
            'battling not only the elements, but an array of deadly '
            'obstacles and mythical creatures along the way.',
          ),
        ],
      );

  Widget _buildScreeningDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Southsea Cinema Room'),
          const Text('Monday 12 Oct 2026, 14:00 - 16:52'),
          const SizedBox(height: 25),
          const Text(
            'Please note that Discounts / Membership Benefits '
            'will be applied once you have selected your tickets',
          ),
          const SizedBox(height: 24),
          const Text('Select Quantities (Up to 5 in total)'),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(),
        drawer: const NavDrawer(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMovieDetails(),
                const SizedBox(height: 25),
                _buildScreeningDetails(),
                const SizedBox(height: 30),
                const TicketSelection(),
              ],
            ),
          ),
        ),
      );
}

class TicketSelection extends StatefulWidget {
  const TicketSelection({super.key});

  @override
  State<TicketSelection> createState() => _TicketSelectionState();
}

class _TicketSelectionState extends State<TicketSelection> {
  int _ticketQuantity = 0;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tickets',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
              const Text('Adult (£7.50)'),
            ],
          ),
        ],
      );

  void _setTicketQuantity(int quantity) {
    setState(() => _ticketQuantity = quantity);
    print(
        'Ticket quantity set to $_ticketQuantity, total price: £${(_ticketQuantity * 7.50).toStringAsFixed(2)}');
  }
}
