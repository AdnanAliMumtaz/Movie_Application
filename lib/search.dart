import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controller = TextEditingController();
  List<String> _movieCategories = ['Action', 'Adventure', 'Comedy', 'Drama', 'Fantasy', 'Horror', 'Romance', 'Sci-Fi']; // Sample categories
  bool _showCategories = true;
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchTextChanged);
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
    final String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    final String apiUrl = 'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _searchResults = List<Map<String, dynamic>>.from(responseData['results']);
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
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search movies...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
      ),
      body: _showCategories ? _buildCategoryList() : _buildSearchResults(),
    );
  }

  Widget _buildCategoryList() {
    return ListView.builder(
      itemCount: (_movieCategories.length / 2).ceil(), // Calculate the number of rows needed
      itemBuilder: (context, index) {
        return Row(
          children: [
            _buildCategoryItem(index * 2), // First box in the row
            SizedBox(width: 8), // Add some space between boxes
            _buildCategoryItem(index * 2 + 1), // Second box in the row
          ],
        );
      },
    );
  }

  Widget _buildCategoryItem(int categoryIndex) {
    if (categoryIndex < _movieCategories.length) {
      return Expanded(
        child: Card(
          elevation: 4,
          child: InkWell(
            onTap: () {
              // Handle category selection
            },
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: Text(
                  _movieCategories[categoryIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Expanded(child: Container()); // Empty container if no more categories
    }
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final movie = _searchResults[index];
        return GestureDetector(
          onTap: () {
            // Add functionality to navigate to movie details page
          },
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
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    movie['title'] ?? 'Untitled',
                    style: TextStyle(fontWeight: FontWeight.bold),
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