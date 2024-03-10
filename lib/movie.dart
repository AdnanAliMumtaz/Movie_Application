import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  final int movieId;

  const MovieDetailPage({required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Detail'),
      ),
      body: Center(
        child: Text('Movie ID: $movieId'), 
      ),
    );
  }
}
