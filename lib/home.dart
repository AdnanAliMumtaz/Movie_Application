import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
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

  Future<void> fetchGenres() async {
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    const String genresApiUrl =
        'https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(genresApiUrl));
      if (response.statusCode == 200) {
        setState(() {
          categories.addAll(List<Map<String, dynamic>>.from(
              json.decode(response.body)['genres']));
        });
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (e) {
      print('Error fetching genres: $e');
    }
  }

  Future<void> fetchTrendingMovies() async {
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    const String trendingApiUrl =
        'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(trendingApiUrl));
      if (response.statusCode == 200) {
        setState(() {
          trendingMovies = json.decode(response.body)['results'];
        });
      } else {
        throw Exception(
            'Failed to load trending movies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching trending movies: $e');
    }
  }

  Future<void> fetchTrendingMoviesByCategory(int categoryId) async {
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    String trendingApiUrl =
        'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey';
    if (categoryId != -1) {
      trendingApiUrl =
          'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$categoryId';
    }

    try {
      final response = await http.get(Uri.parse(trendingApiUrl));
      if (response.statusCode == 200) {
        setState(() {
          trendingMovies = json.decode(response.body)['results'];
        });
      } else {
        throw Exception(
            'Failed to load trending movies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching trending movies: $e');
    }
  }

  Future<List<dynamic>> fetchTopRatedMovies(int categoryId) async {
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    String topRatedApiUrl =
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey';
    if (categoryId != -1) {
      topRatedApiUrl =
          'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$categoryId&sort_by=vote_average.desc';
    }

    try {
      final response = await http.get(Uri.parse(topRatedApiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> movies = json.decode(response.body)['results'];
        return movies
            .where((movie) =>
                movie['poster_path'] != null &&
                movie['overview'] != null &&
                movie['overview'].isNotEmpty)
            .toList();
      } else {
        throw Exception(
            'Failed to load top rated movies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching top rated movies: $e');
      return [];
    }
  }

  Future<List<dynamic>> fetchUpcomingMovies(int categoryId) async {
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    String upcomingApiUrl =
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey';
    if (categoryId != -1) {
      upcomingApiUrl =
          'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$categoryId&primary_release_date.gte=${DateTime.now().toString().substring(0, 10)}';
    }

    try {
      final response = await http.get(Uri.parse(upcomingApiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> movies = json.decode(response.body)['results'];
        return movies
            .where((movie) =>
                movie['poster_path'] != null &&
                movie['overview'] != null &&
                movie['overview'].isNotEmpty)
            .toList();
      } else {
        throw Exception(
            'Failed to load upcoming movies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching upcoming movies: $e');
      return [];
    }
  }

  Future<List<dynamic>> fetchPopularActors(int categoryId) async {
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    String popularActorsApiUrl =
        'https://api.themoviedb.org/3/person/popular?api_key=$apiKey';

    if (categoryId != -1) {
      popularActorsApiUrl =
          'https://api.themoviedb.org/3/discover/person?api_key=$apiKey&with_genres=$categoryId';
    }

    try {
      final response = await http.get(Uri.parse(popularActorsApiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> actors = json.decode(response.body)['results'];
        return actors.where((actor) => actor['profile_path'] != null).toList();
      } else {
        throw Exception(
            'Failed to load popular actors: ${response.statusCode}');
      }
    } catch (e) {
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      if (categories[index]['id'] != null) {
                        fetchTrendingMoviesByCategory(categories[index]['id']);
                      } else {
                        fetchTrendingMovies();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      margin: EdgeInsets.only(right: 10),
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
            const SizedBox(height: 25),
            trendingMovies.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CarouselSlider.builder(
                    itemCount: trendingMovies.length,
                    options: CarouselOptions(
                      height: 350,
                      autoPlay: true,
                      viewportFraction: 0.60,
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
              future:
                  fetchTopRatedMovies(categories[selectedCategoryIndex]['id']),
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
              future:
                  fetchUpcomingMovies(categories[selectedCategoryIndex]['id']),
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
                future:
                    fetchPopularActors(categories[selectedCategoryIndex]['id']),
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
    );
  }
}
