import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Trending extends StatefulWidget {
  const Trending({super.key});

  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  List<Map<String, dynamic>> _videos = [];

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    const String apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
    const String apiUrl = 'https://api.themoviedb.org/3/trending/all/day?api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _videos = List<Map<String, dynamic>>.from(responseData['results']);
        });
      } else {
        // Handle error
        print('Failed to fetch videos: ${responseData['status_message']}');
      }
    } catch (error) {
      // Handle error
      print('Failed to fetch videos: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: _videos.map((video) {
          return VideoCard(
            thumbnailUrl: 'https://image.tmdb.org/t/p/w500${video['poster_path']}',
            title: video['title'] ?? video['name'] ?? 'Untitled',
            description: video['overview'] ?? 'No overview available',
          );
        }).toList(),
      ),
    );
  }
}


class VideoCard extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final String description;

  const VideoCard({
    super.key,
    required this.thumbnailUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent, 
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect( 
            borderRadius: BorderRadius.circular(12), 
            child: Image.network(
              thumbnailUrl,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}