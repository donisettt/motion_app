import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/movie_model.dart';

class NowPlayingCarousel extends StatelessWidget {
  final Future<List<Movie>> movieFuture;

  const NowPlayingCarousel({Key? key, required this.movieFuture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: movieFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 400,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Container(
            height: 400,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final movies = snapshot.data!;
          return CarouselSlider(
            options: CarouselOptions(
              height: 400.0,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
              autoPlay: true,
            ),
            items: movies.map((movie) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            movie.fullBackdropUrl,
                            fit: BoxFit.cover,
                            height: 400,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Text(
                            movie.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          );
        } else {
          return Container(height: 400, child: Center(child: Text('No data')));
        }
      },
    );
  }
}