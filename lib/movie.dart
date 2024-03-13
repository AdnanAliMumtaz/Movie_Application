import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailPage extends StatelessWidget {
  final int movieId;

  const MovieDetailPage({required this.movieId});

  Future<Map<String, dynamic>> _fetchMovieDetails(int movieId) async {
    const apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&append_to_response=videos'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  void addToWatchlist(BuildContext context, Map<String, dynamic> movieData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String movieKey = 'movie_${movieData['id']}';
    String movieJson = jsonEncode(movieData);
    await prefs.setString(movieKey, movieJson);

    // Show a SnackBar to indicate that the video has been added
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Video added to watchlist'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchMovieDetails(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
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
                      borderRadius: BorderRadius.circular(
                          20),
                    ),
                    margin:
                        EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            if (posterPath != null)
                              Container(
                                height: 500,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
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
                          padding: const EdgeInsets.all(
                              15.0), 
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              RatingBar.builder(
                                itemSize: 20,
                                initialRating: rating,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => Icon(
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
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor:
                                        Colors.white.withOpacity(0.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 10),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      overview,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Movie Trailer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                height: 200,
                                padding: EdgeInsets.all(20),
                                child: videoKey != null
                                    ? Transform.scale(
                                        scale: 1.14,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: YoutubePlayer(
                                            controller: YoutubePlayerController(
                                              initialVideoId: videoKey,
                                              flags: YoutubePlayerFlags(
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
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  child: Text('Add to Watchlist'),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
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
    );
  }
}