// lib/widgets/horizontal_movie_list.dart
import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../screens/detail_screen.dart';

class HorizontalMovieList extends StatelessWidget {
  final String title;
  final Future<List<Movie>> movieFuture;

  const HorizontalMovieList({
    Key? key,
    required this.title,
    required this.movieFuture,
  }) : super(key: key);

  Widget _buildRatingBar(double rating, String year) {
    final displayRating = rating / 2;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 14.0,
        ),
        const SizedBox(width: 4),
        Text(
          displayRating.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '($year)',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "More",
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ),

        // list
        SizedBox(
          height: 250,
          child: FutureBuilder<List<Movie>>(
            future: movieFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    'No data',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final movies = snapshot.data!;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      left: (index == 0) ? 16.0 : 8.0,
                      right: 8.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(movie: movie),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                movie.fullPosterUrl,
                                height: 180,
                                width: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 180,
                                    width: 120,
                                    color: Colors.grey,
                                    child: const Center(
                                      child: Icon(
                                        Icons.error_outline,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 5),
                            _buildRatingBar(
                              movie.voteAverage,
                              movie.releaseYear,
                            ),
                            Text(
                              movie.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}