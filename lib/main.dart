import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/views/home_view.dart';
// import 'package:southsea_cinema/views/movie_listing.dart';
// import 'package:southsea_cinema/models/movie.dart';

void main() {
  runApp(const SouthseaCinemaApp());
}

class SouthseaCinemaApp extends StatelessWidget {
  const SouthseaCinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Southsea Cinema & Arts Centre",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: cinemaBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: cinemaBrand,
          primary: cinemaBrand,
          surface: cinemaSurface,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        // '/listing': (context) => MovieListing(
        //     movie: Movie(
        //         id: 'odyssey2026',
        //         title: "The Odyssey",
        //         ageRating: "(15)",
        //         description: "a dummy text...",
        //         imagePath: "assets/images/odyssey.jpg",
        //         screeningTime: ["7:00 PM", "9:30 PM"]),
        //     screeningTime: "7:00 PM"),
      },
    );
  }
}
