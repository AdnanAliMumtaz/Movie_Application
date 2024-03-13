import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movie_app/category.dart';
import 'package:movie_app/movie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Search extends StatefulWidget {
  const Search({Key? key});

  @override
  _SearchState createState() => _SearchState();
}

enum SortCriteria {
  aToZ,
  latestRelease,
  oldestRelease,
  zToA,
  bestReviewed,
  worstReviewed
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  bool _showCategories = true;
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _movieCategories = [];

  SortCriteria? _selectedSortCriteria;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchTextChanged);
    fetchMovieCategories();
  }

  Future<void> fetchMovieCategories() async {
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    const String apiUrl =
        'https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _movieCategories = List<String>.from(
              responseData['genres'].map((genre) => genre['name']));
        });
      } else {
        // Handle error
        print(
            'Failed to fetch movie categories: ${responseData['status_message']}');
      }
    } catch (error) {
      // Handle error
      print('Failed to fetch movie categories: $error');
    }
  }

  _onSearchTextChanged() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _showCategories = false;
      });
      _searchMovies(_controller.text);
    } else {
      setState(() {
        _showCategories = true;
        _searchResults.clear();
      });
    }
  }

  Future<void> _searchMovies(String query) async {
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    final String apiUrl =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _searchResults =
              List<Map<String, dynamic>>.from(responseData['results']);
        });
      } else {
        // Handle error
        print('Failed to search movies: ${responseData['status_message']}');
      }
    } catch (error) {
      // Handle error
      print('Failed to search movies: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'What do you want to watch?',
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.black, size: 28.0),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(Icons.filter_list, color: Colors.black),
                onPressed: _showSortDialog,
              ),
            ),
          ],
        ),
      ),
      body: _showCategories ? _buildCategoryList() : _buildSearchResults(),
    );
  }

  Widget _buildCategoryList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: (_movieCategories.length / 2).ceil() +
            1, 
        itemBuilder: (context, index) {
          if (index == (_movieCategories.length / 2).ceil()) {
            return SizedBox(
              height: 70,
              width: 70,
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryItem(index * 2),
                const SizedBox(width: 8),
                _buildCategoryItem(index * 2 + 1),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCategoryItem(int categoryIndex) {
    List<Color> darkCategoryColors = [
      Colors.blue[900]!, // Dark blue
      Colors.green[900]!, // Dark green
      Colors.orange[900]!, // Dark orange
      Colors.deepPurple[900]!, // Dark purple
      Colors.red[900]!, // Dark red
      Colors.amber[900]!, // Dark amber
      Colors.teal[900]!, // Dark teal
      Colors.pink[900]!, // Dark pink
      Colors.cyan[900]!, // Dark cyan
      Colors.indigo[900]!, // Dark indigo
    ];

    if (categoryIndex < _movieCategories.length) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryDetailsPage(
                      categoryId: _movieCategories[categoryIndex]),
                ),
              );
            },
            child: Card(
              elevation: 4,
              color:
                  darkCategoryColors[categoryIndex % darkCategoryColors.length],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            _movieCategories[categoryIndex],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 36,
                      right: 0,
                      child: Transform.rotate(
                        angle: 0.2, 
                        child: Container(
                          width: 65,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset:
                                    Offset(0, 0), 
                                blurRadius:
                                    3, 
                                spreadRadius:
                                    0, 
                              ),
                            ],
                          ),
                          child: FutureBuilder(
                            future: fetchCategoryMoviePoster(categoryIndex),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      5), 
                                  child: Image.network(
                                    snapshot.data.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Expanded(child: Container());
    }
  }

  Future<String> fetchCategoryMoviePoster(int categoryIndex) async {
    final String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    final String apiUrl =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=${_movieCategories[categoryIndex]}';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Assuming the first movie in the search results has the poster
        return 'https://image.tmdb.org/t/p/w500${responseData['results'][0]['poster_path']}';
      } else {
        throw Exception('Failed to fetch movie poster');
      }
    } catch (error) {
      throw Exception('Failed to fetch movie poster: $error');
    }
  }

  Widget _buildSearchResults() {
    final List<Map<String, dynamic>> filteredResults =
        _searchResults.where((movie) => movie['poster_path'] != null).toList();

    return ListView.builder(
      itemCount: (filteredResults.length / 2).ceil() +
          1,
      itemBuilder: (context, index) {
        if (index < (filteredResults.length / 2).ceil()) {
          final int firstMovieIndex = index * 2;
          final int secondMovieIndex = index * 2 + 1;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildSearchResultItem(
                filteredResults[firstMovieIndex],
                secondMovieIndex < filteredResults.length
                    ? filteredResults[secondMovieIndex]
                    : null),
          );
        } else {
          return SizedBox(height: 60);
        }
      },
    );
  }

  Widget _buildSearchResultItem(
      Map<String, dynamic> movie1, Map<String, dynamic>? movie2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              _navigateToMovieDetailsPage(movie1);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie1['poster_path']}',
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  movie1['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: movie2 != null
              ? GestureDetector(
                  onTap: () {
                    _navigateToMovieDetailsPage(movie2);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 4,
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie2['poster_path']}',
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        movie2['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(), 
        ),
      ],
    );
  }

  void _navigateToMovieDetailsPage(Map<String, dynamic> movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movieId: movie['id']),
      ),
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSortOption('A to Z', SortCriteria.aToZ),
              _buildSortOption('Latest Release', SortCriteria.latestRelease),
              _buildSortOption('Oldest Release', SortCriteria.oldestRelease),
              _buildSortOption('Z to A', SortCriteria.zToA),
              _buildSortOption('Best Reviewed', SortCriteria.bestReviewed),
              _buildSortOption('Worst Reviewed', SortCriteria.worstReviewed),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String label, SortCriteria criteria) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: Colors.black),
      ),
      onTap: () {
        _sortMovies(criteria);
        Navigator.of(context).pop();
      },
    );
  }

  void _sortMovies(SortCriteria criteria) {
    switch (criteria) {
      case SortCriteria.aToZ:
        _searchResults.sort((a, b) => a['title'].compareTo(b['title']));
        break;
      case SortCriteria.latestRelease:
        _searchResults
            .sort((a, b) => b['release_date'].compareTo(a['release_date']));
        break;
      case SortCriteria.oldestRelease:
        _searchResults
            .sort((a, b) => a['release_date'].compareTo(b['release_date']));
        break;
      case SortCriteria.zToA:
        _searchResults.sort((a, b) => b['title'].compareTo(a['title']));
        break;
      case SortCriteria.bestReviewed:
        _searchResults
            .sort((a, b) => b['vote_average'].compareTo(a['vote_average']));
        break;
      case SortCriteria.worstReviewed:
        _searchResults
            .sort((a, b) => a['vote_average'].compareTo(b['vote_average']));
        break;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchTextChanged);
    _controller.dispose();
    super.dispose();
  }
}
