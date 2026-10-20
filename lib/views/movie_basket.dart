import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieBasket extends StatelessWidget {
  const MovieBasket({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appTitle,
          style: cinemaHeaderStyle,
        ),
      ),
      drawer: const NavDrawer(),
      body: const Center(
        child: Text(
          'Your movie basket is empty.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
