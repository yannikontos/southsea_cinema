import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // final isCompact = constraints.maxWidth < 750;

        return Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // if (isCompact)
                // AspectRatio(
                //   aspectRatio: 2 / 3,
                //   child: Image.asset(
                //     movie.imagePath,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Flexible(
                            child: Text(
                              movie.title.toUpperCase(),
                              style: TextStyle(
                                color: cinemaBrandLight,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${movie.ageRating}) ',
                            style: TextStyle(
                              color: cinemaFontMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 10),
                      // if (isCompact)
                      //   Text(
                      //     movie.description,
                      //     style: const TextStyle(
                      //       color: cinemaFontWhite,
                      //       fontSize: 16,
                      //     ),
                      //   )
                      // else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            movie.imagePath,
                            width: 95,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              movie.description,
                              style: const TextStyle(
                                color: cinemaFontWhite,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'BOOK TICKETS',
                        style: TextStyle(
                          color: cinemaFontWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        spacing: 4,
                        children: movie.screeningTime.map((time) {
                          return Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: Text(
                                  time,
                                  style: const TextStyle(
                                    color: cinemaFontWhite,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieListing(
                                        movie: movie,
                                        screeningTime: time,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cinemaBrand,
                                  foregroundColor: cinemaFontWhite,
                                ),
                                child: const Text('BOOK NOW'),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
