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
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The Odyssey (2026)',
              ),
              const Text(
                  'Odysseus, king of Ithaca, embarks on a perilous journey to return home after the Trojan War. Crossing the Mediterranean Sea with his fellow soldiers, they soon find themselves battling not only the elements, but an array of deadly obstacles and mythical creatures along the way.'),
            ],
          ),
        ));
  }
}
