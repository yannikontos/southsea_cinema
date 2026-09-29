import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatelessWidget {
  const MovieListing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(appTitle, style: cinemaHeaderStyle),
          backgroundColor: cinemaSurface,
          iconTheme: const IconThemeData(color: cinemaBrand),
          elevation: 0,
        ),
        drawer: const NavDrawer(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'The Odyssey (2026)',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '(15)',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
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
                const SizedBox(height: 25),
                Text('Southsea Cinema Room'),
                Text('Monday 12 Oct 2026, 14:00 - 16:52'),
                const SizedBox(height: 25),
                Text('Please note that Discounts / Membership Benefits '
                    'will be applied once you have selected your tickets'),
                const SizedBox(height: 24),
                Text('Select Quantities (Up to 5 in total)'),
                const SizedBox(height: 30),
                Text('Tickets',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 7),
                Row(children: [
                  DropdownMenu<int>(
                    initialSelection: 5,
                    onSelected: (int? value) {
                      if (value != null) {
                        // setState(() {});
                      }
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 1, label: '1'),
                      DropdownMenuEntry(value: 2, label: '2'),
                      DropdownMenuEntry(value: 3, label: '3'),
                      DropdownMenuEntry(value: 4, label: '4'),
                      DropdownMenuEntry(value: 5, label: '5'),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Text('Adult (£7.50)')
                ])
              ],
            ),
          ),
        ));
  }
}
