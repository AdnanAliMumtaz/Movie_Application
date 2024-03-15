import 'package:flutter/material.dart';
import 'package:movie_app/internetChecker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Watch extends StatefulWidget {
  @override
  _WatchState createState() => _WatchState();
}

class _WatchState extends State<Watch> {
  late List<Map<String, dynamic>> _watchlist = [];

  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  /// Loads the user's watchlist from SharedPreferences.
  Future<void> _loadWatchlist() async {
    // Get instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get all keys from SharedPreferences that start with 'movie_'
    List<String> movieKeys =
        prefs.getKeys().where((key) => key.startsWith('movie_')).toList();

    // List to store watchlist
    List<Map<String, dynamic>> watchlist = [];

    // Iterate through movieKeys and retrieve movie data from SharedPreferences
    for (String key in movieKeys) {
      String? movieJson = prefs.getString(key);
      if (movieJson != null) {
        // Decode movie data from JSON and add to watchlist
        Map<String, dynamic> movieData = jsonDecode(movieJson);
        watchlist.add(movieData);
      }
    }

    // Update watchlist state with retrieved data
    setState(() {
      _watchlist = watchlist;
    });
  }

  /// Removes a movie from the watchlist at the specified index.
  Future<void> _removeFromWatchlist(int index) async {
    // Get instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Generate the movie key based on its ID
    String movieKey = 'movie_${_watchlist[index]['id']}';

    // Remove movie data from SharedPreferences
    await prefs.remove(movieKey);

    // Update the watchlist state by removing the movie at the specified index
    setState(() {
      _watchlist.removeAt(index);
    });

    // Show a SnackBar to indicate that the movie has been removed from the watchlist
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Movie removed from watchlist',
          style: TextStyle(color: Colors.black),
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InternetChecker(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _watchlist.isEmpty
            ? const Center(
                child: Text(
                  'Your watchlist is empty',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: _watchlist.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> movieData = _watchlist[index];
                  String title = movieData['title'];
                  String releaseDate = movieData['release_date'];
                  String posterPath = movieData['poster_path'];

                  return ListTile(
                    leading: Image.network(
                      'https://image.tmdb.org/t/p/w200$posterPath',
                      width: 50,
                    ),
                    title: Text(title),
                    subtitle: Text(releaseDate),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () => _removeFromWatchlist(index),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
