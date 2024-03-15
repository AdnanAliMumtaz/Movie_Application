import 'package:flutter/material.dart';

// Class to hold movie data
class MovieData {
  final int id; // Movie ID
  final String name; // Movie name
  final String posterUrl; // URL for the movie poster

  MovieData({required this.id, required this.name, required this.posterUrl});
}

// Widget to display movie poster and name
class MoviePoster extends StatelessWidget {
  final MovieData movieData; // Movie data object

  const MoviePoster({Key? key, required this.movieData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              movieData.posterUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          movieData.name, // Display movie name
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
