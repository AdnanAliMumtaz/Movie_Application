import 'package:flutter/material.dart';
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

  Future<void> _loadWatchlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> movieKeys = prefs.getKeys().where((key) => key.startsWith('movie_')).toList();
    List<Map<String, dynamic>> watchlist = [];

    for (String key in movieKeys) {
      String? movieJson = prefs.getString(key);
      if (movieJson != null) {
        Map<String, dynamic> movieData = jsonDecode(movieJson);
        watchlist.add(movieData);
      }
    }

    setState(() {
      _watchlist = watchlist;
    });
  }

  Future<void> _removeFromWatchlist(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String movieKey = 'movie_${_watchlist[index]['id']}';
    await prefs.remove(movieKey);

    setState(() {
      _watchlist.removeAt(index);
    });

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
    return Scaffold(
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
    );
  }
}
