import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Search extends StatefulWidget {
  const Search({Key? key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  bool _showCategories = true;
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _movieCategories = [];

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
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'What do you want to watch?',
            hintStyle: TextStyle(
                color: Colors.grey[700]), 
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 20),
            prefixIcon: Icon(Icons.search,
                color: Colors.black, size: 28.0), 
          ),
        ),
      ),
      body: _showCategories ? _buildCategoryList() : _buildSearchResults(),
    );
  }

  Widget _buildCategoryList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16), 
      child: ListView.builder(
        itemCount: (_movieCategories.length / 2).ceil(),
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween,
            children: [
              _buildCategoryItem(index * 2),
              const SizedBox(width: 8),
              _buildCategoryItem(index * 2 + 1),
            ],
          );
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
          padding: const EdgeInsets.symmetric(
              vertical: 8), // Adjusted vertical padding
          child: Card(
            elevation: 4,
            color: darkCategoryColors[categoryIndex %
                darkCategoryColors
                    .length], // Assign a dark color based on category index
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5), 
            ),
            child: InkWell(
              onTap: () {},
              child: SizedBox(
                
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
            ),
          ),
        ),
      );
    } else {
      return Expanded(child: Container());
    }
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final movie = _searchResults[index];
        return GestureDetector(
          onTap: () {},
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    movie['title'] ?? 'Untitled',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchTextChanged);
    _controller.dispose();
    super.dispose();
  }
}
