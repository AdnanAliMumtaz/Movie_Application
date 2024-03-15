import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/internetChecker.dart';
import 'package:movie_app/movie.dart';
import 'package:movie_app/moviePoster.dart';

class CategoryDetailsPage extends StatefulWidget {
  final String category;

  const CategoryDetailsPage({Key? key, required this.category})
      : super(key: key);

  @override
  _CategoryDetailsPageState createState() => _CategoryDetailsPageState();
}

// State class for the Category Details Page
class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  // List to store fetched movies
  List<MovieData> _movies = [];
  // Map to store genre names and their IDs
  Map<String, int> _genreMap = {};

  @override
  void initState() {
    super.initState();
    _fetchGenres();
  }

  // Fetching genre data from API
  Future<void> _fetchGenres() async {
    try {
      const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
      const String apiUrl =
          'https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> genres = jsonData['genres'];

        setState(() {
          _genreMap = Map.fromIterable(
            genres,
            key: (genre) => genre['name'],
            value: (genre) => genre['id'],
          );

          _fetchRandomMovies();
        });
      } else {
        throw Exception('Failed to fetch genres');
      }
    } catch (e) {
      print('Error fetching genres: $e');
    }
  }

  // Fetching random movies based on selected category
  Future<void> _fetchRandomMovies() async {
    try {
      const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
      final int genreId =
          _genreMap[widget.category] ?? 28; // Default to Action if category not found
      final String apiUrl =
          'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> results = jsonData['results'];

        setState(() {
          _movies = results.map<MovieData>((movie) {
            return MovieData(
              id: movie['id'],
              name: movie['title'],
              posterUrl: 'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to fetch movie posters');
      }
    } catch (e) {
      print('Error fetching movie posters: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InternetChecker(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60,),
            // Displaying the category name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.7, // Adjust this value as needed
                  ),
                  itemCount: _movies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(movieId: _movies[index].id),
                          ),
                        );
                      },
                      child: MoviePoster(movieData: _movies[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
