import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_app/internetChecker.dart';
import 'package:movie_app/movie.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> trendingMovies = [];
  List<Map<String, dynamic>> categories = [
    {'id': -1, 'name': 'All'},
  ];
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchGenres();
    fetchTrendingMovies();
  }

  // Function to fetch genres from the API
  Future<void> fetchGenres() async {
    // API key for authentication
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    // API endpoint to fetch genres
    const String genresApiUrl =
        'https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey';

    try {
      // Fetching data from the API
      final response = await http.get(Uri.parse(genresApiUrl));
      // Checking if the request was successful
      if (response.statusCode == 200) {
        // Updating the state with fetched genre data
        setState(() {
          // Extracting genres from the response and adding them to the categories list
          categories.addAll(List<Map<String, dynamic>>.from(
              json.decode(response.body)['genres']));
        });
      } else {
        // If the request was not successful, throw an exception
        throw Exception('Failed to load genres');
      }
    } catch (e) {
      // Handling errors if any occur during the process
      print('Error fetching genres: $e');
    }
  }

// Function to fetch trending movies from the API
  Future<void> fetchTrendingMovies() async {
    // API key for authentication
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    // API endpoint to fetch trending movies
    const String trendingApiUrl =
        'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey';

    try {
      // Fetching data from the API
      final response = await http.get(Uri.parse(trendingApiUrl));
      // Checking if the request was successful
      if (response.statusCode == 200) {
        // Updating the state with fetched trending movie data
        setState(() {
          // Extracting trending movies from the response and assigning them to trendingMovies
          trendingMovies = json.decode(response.body)['results'];
        });
      } else {
        // If the request was not successful, throw an exception
        throw Exception(
            'Failed to load trending movies: ${response.statusCode}');
      }
    } catch (e) {
      // Handling errors if any occur during the process
      print('Error fetching trending movies: $e');
    }
  }

// Function to fetch trending movies by category from the API
  Future<void> fetchTrendingMoviesByCategory(int categoryId) async {
    // API key for authentication
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    // Default URL for fetching trending movies
    String trendingApiUrl =
        'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey';
    // If categoryId is not -1, modify the URL to fetch movies by genre
    if (categoryId != -1) {
      trendingApiUrl =
          'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$categoryId';
    }

    try {
      // Fetching data from the API
      final response = await http.get(Uri.parse(trendingApiUrl));
      // Checking if the request was successful
      if (response.statusCode == 200) {
        // Updating the state with fetched trending movies
        setState(() {
          // Extracting trending movies from the response and updating the trendingMovies list
          trendingMovies = json.decode(response.body)['results'];
        });
      } else {
        // If the request was not successful, throw an exception
        throw Exception(
            'Failed to load trending movies: ${response.statusCode}');
      }
    } catch (e) {
      // Handling errors if any occur during the process
      print('Error fetching trending movies: $e');
    }
  }

// Function to fetch top rated movies from the API
  Future<List<dynamic>> fetchTopRatedMovies(int categoryId) async {
    // API key for authentication
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    // Default URL for fetching top rated movies
    String topRatedApiUrl =
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey';
    // If categoryId is not -1, modify the URL to fetch movies by genre and sort them by vote average
    if (categoryId != -1) {
      topRatedApiUrl =
          'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$categoryId&sort_by=vote_average.desc';
    }

    try {
      // Fetching data from the API
      final response = await http.get(Uri.parse(topRatedApiUrl));
      // Checking if the request was successful
      if (response.statusCode == 200) {
        // Extracting movie data from the response
        final List<dynamic> movies = json.decode(response.body)['results'];
        // Filtering out movies with missing poster or overview
        return movies
            .where((movie) =>
                movie['poster_path'] != null &&
                movie['overview'] != null &&
                movie['overview'].isNotEmpty)
            .toList();
      } else {
        // If the request was not successful, throw an exception
        throw Exception(
            'Failed to load top rated movies: ${response.statusCode}');
      }
    } catch (e) {
      // Handling errors if any occur during the process
      print('Error fetching top rated movies: $e');
      return [];
    }
  }

// Function to fetch upcoming movies from the API
  Future<List<dynamic>> fetchUpcomingMovies(int categoryId) async {
    // API key for authentication
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    // Default URL for fetching upcoming movies
    String upcomingApiUrl =
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey';
    // If categoryId is not -1, modify the URL to fetch movies by genre and filter by release date
    if (categoryId != -1) {
      upcomingApiUrl =
          'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$categoryId&primary_release_date.gte=${DateTime.now().toString().substring(0, 10)}';
    }

    try {
      // Fetching data from the API
      final response = await http.get(Uri.parse(upcomingApiUrl));
      // Checking if the request was successful
      if (response.statusCode == 200) {
        // Extracting movie data from the response
        final List<dynamic> movies = json.decode(response.body)['results'];
        // Filtering out movies with missing poster or overview
        return movies
            .where((movie) =>
                movie['poster_path'] != null &&
                movie['overview'] != null &&
                movie['overview'].isNotEmpty)
            .toList();
      } else {
        // If the request was not successful, throw an exception
        throw Exception(
            'Failed to load upcoming movies: ${response.statusCode}');
      }
    } catch (e) {
      // Handling errors if any occur during the process
      print('Error fetching upcoming movies: $e');
      return [];
    }
  }

// Function to fetch popular actors from the API
  Future<List<dynamic>> fetchPopularActors(int categoryId) async {
    // API key for authentication
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    // Default URL for fetching popular actors
    String popularActorsApiUrl =
        'https://api.themoviedb.org/3/person/popular?api_key=$apiKey';
    // If categoryId is not -1, modify the URL to fetch actors by genre
    if (categoryId != -1) {
      popularActorsApiUrl =
          'https://api.themoviedb.org/3/discover/person?api_key=$apiKey&with_genres=$categoryId';
    }

    try {
      // Fetching data from the API
      final response = await http.get(Uri.parse(popularActorsApiUrl));
      // Checking if the request was successful
      if (response.statusCode == 200) {
        // Extracting actor data from the response
        final List<dynamic> actors = json.decode(response.body)['results'];
        // Filtering out actors with missing profile picture
        return actors.where((actor) => actor['profile_path'] != null).toList();
      } else {
        // If the request was not successful, throw an exception
        throw Exception(
            'Failed to load popular actors: ${response.statusCode}');
      }
    } catch (e) {
      // Handling errors if any occur during the process
      print('Error fetching popular actors: $e');
      return [];
    }
  }

  void _showMovieDetail(int movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movieId: movieId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InternetChecker(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Displaying categories horizontally
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    categories.length,
                    (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                        // Fetch trending movies by category if category ID is available, else fetch trending movies
                        if (categories[index]['id'] != null) {
                          fetchTrendingMoviesByCategory(
                              categories[index]['id']);
                        } else {
                          fetchTrendingMovies();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: selectedCategoryIndex == index
                              ? Colors.red
                              : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          categories[index]['name'],
                          style: TextStyle(
                            color: selectedCategoryIndex == index
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Displaying trending movies in a carousel slider
              trendingMovies.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CarouselSlider.builder(
                      itemCount: trendingMovies.length,
                      options: CarouselOptions(
                        height: 350,
                        autoPlay: true,
                        viewportFraction: 0.65,
                        enlargeCenterPage: true,
                        pageSnapping: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        autoPlayAnimationDuration: const Duration(seconds: 1),
                      ),
                      itemBuilder: (context, index, pageViewIndex) {
                        final movie = trendingMovies[index];
                        if (movie['poster_path'] == null) {
                          return const SizedBox.shrink();
                        }
                        return GestureDetector(
                          onTap: () {
                            _showMovieDetail(movie['id']);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500/${movie['poster_path']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
              const SizedBox(
                height: 15,
              ),
              // Displaying top rated movies horizontally
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Top Rated Movies",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900),
                ),
              ),
              FutureBuilder(
                future: fetchTopRatedMovies(
                    categories[selectedCategoryIndex]['id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  List<dynamic> topRatedMovies = snapshot.data ?? [];
                  if (topRatedMovies.isEmpty) {
                    return const Center(
                        child: Text('No top rated movies available.'));
                  }
                  return SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: topRatedMovies.length,
                      itemBuilder: (context, index) {
                        final movie = topRatedMovies[index];
                        return GestureDetector(
                          onTap: () {
                            _showMovieDetail(movie['id']);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500/${movie['poster_path']}',
                                fit: BoxFit.cover,
                                height: 200,
                                width: 150,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              // Displaying upcoming movies horizontally
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Upcoming Movies",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900),
                ),
              ),
              FutureBuilder(
                future: fetchUpcomingMovies(
                    categories[selectedCategoryIndex]['id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  List<dynamic> upcomingMovies = snapshot.data ?? [];
                  if (upcomingMovies.isEmpty) {
                    return const Center(
                        child: Text('No upcoming movies available.'));
                  }
                  return SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: upcomingMovies.length,
                      itemBuilder: (context, index) {
                        final movie = upcomingMovies[index];
                        return GestureDetector(
                          onTap: () {
                            _showMovieDetail(movie['id']);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500/${movie['poster_path']}',
                                fit: BoxFit.cover,
                                height: 200,
                                width: 150,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              // Displaying popular actors horizontally
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Popular Actors",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: 150,
                width: double.infinity,
                child: FutureBuilder(
                  future: fetchPopularActors(
                      categories[selectedCategoryIndex]['id']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    List<dynamic> popularActors = snapshot.data ?? [];
                    if (popularActors.isEmpty) {
                      return const Center(
                          child: Text('No popular actors available.'));
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: popularActors.length,
                      itemBuilder: (context, index) {
                        final actor = popularActors[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ClipOval(
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500/${actor['profile_path']}',
                                  fit: BoxFit.cover,
                                  width: 85,
                                  height: 90,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                actor['name'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
