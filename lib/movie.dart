import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/internetChecker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailPage extends StatelessWidget {
  final int movieId;

  const MovieDetailPage({required this.movieId});

// Function to fetch movie details from the API
  Future<Map<String, dynamic>> _fetchMovieDetails(int movieId) async {
    // API key for accessing the movie database
    const apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    // Constructing the URL for the movie details API endpoint
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&append_to_response=videos'),
    );

    // Check if the response is successful
    if (response.statusCode == 200) {
      // If successful, decode the response body and return the movie details
      return jsonDecode(response.body);
    } else {
      // If unsuccessful, throw an exception with an error message
      throw Exception('Failed to load movie details');
    }
  }

// Function to fetch movie reviews from the API
  Future<List<Map<String, dynamic>>> _fetchMovieReviews(int movieId) async {
    // API key for accessing the movie database
    const apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    // Constructing the URL for the movie reviews API endpoint
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=$apiKey'),
    );

    // Check if the response is successful
    if (response.statusCode == 200) {
      // Decode the response body and extract the review results
      final List<dynamic> results = jsonDecode(response.body)['results'];
      // Check if there are any review results
      if (results.isNotEmpty) {
        // If reviews are available, map each review to a Map<String, dynamic>
        // with 'author' and 'content' keys and return them as a list
        return results.map((review) {
          return {
            'author': review['author'], // Placeholder for author name
            'content': review['content'], // Extracted review content
          };
        }).toList();
      } else {
        // If no reviews are available, return an empty list
        return [];
      }
    } else {
      // If unsuccessful, throw an exception with an error message
      throw Exception('Failed to load movie reviews');
    }
  }

// Function to add a movie to the watchlist
  void addToWatchlist(
      BuildContext context, Map<String, dynamic> movieData) async {
    // Get the SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Construct the key for storing the movie data in SharedPreferences
    String movieKey = 'movie_${movieData['id']}';
    // Encode the movie data as JSON
    String movieJson = jsonEncode(movieData);
    // Save the movie data to SharedPreferences
    await prefs.setString(movieKey, movieJson);

    // Show a SnackBar to indicate that the video has been added
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video added to watchlist'), // Snackbar message
        duration: Duration(seconds: 1), // Duration to display the Snackbar
        backgroundColor: Colors.red, // Background color of the Snackbar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InternetChecker(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<Map<String, dynamic>>(
          future: _fetchMovieDetails(movieId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for movie details
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // Display an error message if failed to fetch movie details
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final Map<String, dynamic> movieData = snapshot.data!;
              final String? posterPath = movieData['poster_path'];
              final String title = movieData['title'];
              final double rating = movieData['vote_average'] != null
                  ? movieData['vote_average'].toDouble() / 2
                  : 0.0;
              final List<dynamic> categories = movieData['genres'];
              final String overview = movieData['overview'];
              final List<dynamic> videoResults = movieData['videos']['results'];
              final String? videoKey =
                  videoResults.isNotEmpty ? videoResults[0]['key'] : null;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              if (posterPath != null)
                                SizedBox(
                                  height: 500,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/original$posterPath',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.98),
                                        Colors.transparent,
                                      ],
                                      stops: [0.1, 0.8],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                RatingBar.builder(
                                  itemSize: 20,
                                  initialRating: rating,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.red,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                Wrap(
                                  spacing: 8,
                                  children: categories.map((category) {
                                    return Chip(
                                      label: Text(
                                        category['name'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      backgroundColor:
                                          Colors.white.withOpacity(0.1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(
                                            color: Colors.transparent),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 10),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.3,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        overview,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Movie Trailer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  padding: const EdgeInsets.all(20),
                                  child: videoKey != null
                                      ? Transform.scale(
                                          scale: 1.14,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: YoutubePlayer(
                                              controller:
                                                  YoutubePlayerController(
                                                initialVideoId: videoKey,
                                                flags: const YoutubePlayerFlags(
                                                  autoPlay: false,
                                                  mute: false,
                                                ),
                                              ),
                                              showVideoProgressIndicator: true,
                                              progressIndicatorColor:
                                                  Colors.amber,
                                            ),
                                          ),
                                        )
                                      : const Text(
                                          'Movie Trailer Coming Soon!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      addToWatchlist(context, movieData);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                    child: const Text('Add to Watchlist'),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: _fetchMovieReviews(movieId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Display a loading indicator while waiting for movie reviews
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                // Display an error message if failed to fetch movie reviews
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final List<Map<String, dynamic>> reviews =
                                    snapshot.data ?? [];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Movie Reviews',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Display reviews with author name in red boxes within a scrollable ListView
                                    SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        physics: const PageScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: reviews.length,
                                        itemBuilder: (context, index) {
                                          final review = reviews[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${review['author']}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Container(
                                                  width: 330,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    review['content'],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                    maxLines: 5,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    if (reviews.isEmpty)
                                      const Text(
                                        'No movie reviews available',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
