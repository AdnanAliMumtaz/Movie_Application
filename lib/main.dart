import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_app/login.dart';
import 'package:movie_app/register.dart';
import 'package:movie_app/splashScreen.dart';
import 'trending.dart';
import 'search.dart';
import 'home.dart';
import 'package:movie_app/Common_Utilities/navigationBar.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBJO74hNa58P3Q7y2_CYgsR8aXXXk9OXNQ",
            appId: "1:667588317697:android:643a8e3dedd79ddc55a600",
            messagingSenderId: "667588317697",
            projectId: "movietrackapplication-9ce11"));

  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      routes: {
        '/': (context) => const splashScreen(
          child: Login(),
        ),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/home': (context) => const Navigation(),
      },
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// void main() {
//   runApp(MyApp());
// }

// class Movie {
//   final int id;
//   final String title;
//   final String overview;
//   final String videoKey;
//   final double? rating;
//   final List<String> categories;
//   final int duration; // Duration of the movie in minutes
//   final DateTime releaseDate; // Release date of the movie

//   Movie({
//     required this.id,
//     required this.title,
//     required this.overview,
//     required this.videoKey,
//     this.rating,
//     required this.categories,
//     required this.duration,
//     required this.releaseDate,
//   });

//   factory Movie.fromJson(Map<String, dynamic> json) {
//     String videoKey = '';
//     if (json['videos'] != null &&
//         json['videos']['results'] != null &&
//         json['videos']['results'].isNotEmpty) {
//       videoKey = json['videos']['results'][0]['key'];
//     }

//     return Movie(
//       id: json['id'],
//       title: json['title'],
//       overview: json['overview'],
//       videoKey: videoKey,
//       rating: json['vote_average'] != null ? json['vote_average'].toDouble() / 2 : null,
//       categories: List<String>.from(json['genres']?.map((x) => x['name']) ?? []),
//       duration: json['runtime'] ?? 0,
//       releaseDate: DateTime.tryParse(json['release_date'] ?? '') ?? DateTime.now(),
//     );
//   }
// }

// class Review {
//   final String author;
//   final String content;

//   Review({
//     required this.author,
//     required this.content,
//   });

//   factory Review.fromJson(Map<String, dynamic> json) {
//     return Review(
//       author: json['author'],
//       content: json['content'],
//     );
//   }
// }

// class Actor {
//   final String name;
//   final String character;
//   final String profilePath;

//   Actor({
//     required this.name,
//     required this.character,
//     required this.profilePath,
//   });

//   factory Actor.fromJson(Map<String, dynamic> json) {
//     return Actor(
//       name: json['name'],
//       character: json['character'],
//       profilePath: json['profile_path'] ?? '',
//     );
//   }
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late Future<Movie> _randomMovieFuture;
//   late Future<List<Review>> _reviewsFuture;
//   late Future<List<Actor>> _actorsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _randomMovieFuture = _fetchRandomMovie();
//     _reviewsFuture = _fetchMovieReviews();
//     _actorsFuture = _fetchMovieActors();
//   }

//   Future<Movie> _fetchRandomMovie() async {
//     final apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
//     final response = await http.get(
//       Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=$apiKey'),
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = jsonDecode(response.body);
//       final List<dynamic> results = data['results'];
//       final randomMovieData = results.isNotEmpty ? results.first : {};
//       final int movieId = randomMovieData['id'];
      
//       // Fetch additional details for the specific movie
//       final movieDetailsResponse = await http.get(
//         Uri.parse('https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&append_to_response=videos'),
//       );

//       if (movieDetailsResponse.statusCode == 200) {
//         final Map<String, dynamic> movieDetailsData = jsonDecode(movieDetailsResponse.body);
//         return Movie.fromJson(movieDetailsData);
//       } else {
//         throw Exception('Failed to load random movie details');
//       }
//     } else {
//       throw Exception('Failed to load random movie');
//     }
//   }

//   Future<List<Review>> _fetchMovieReviews() async {
//     final apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
//     final movieId = (await _randomMovieFuture).id;
//     final response = await http.get(
//       Uri.parse('https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=$apiKey'),
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = jsonDecode(response.body);
//       final List<dynamic> results = data['results'];
//       return results.map((reviewData) => Review.fromJson(reviewData)).toList();
//     } else {
//       throw Exception('Failed to load movie reviews');
//     }
//   }

//   Future<List<Actor>> _fetchMovieActors() async {
//     final apiKey = '80cc2e03cf6fa0d932e0efafa543fb2e';
//     final movieId = (await _randomMovieFuture).id;
//     final response = await http.get(
//       Uri.parse('https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey'),
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = jsonDecode(response.body);
//       final List<dynamic> cast = data['cast'];
//       return cast.map((actorData) => Actor.fromJson(actorData)).toList();
//     } else {
//       throw Exception('Failed to load movie actors');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Random Movie Details'),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 FutureBuilder<Movie>(
//                   future: _randomMovieFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return CircularProgressIndicator();
//                     } else if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     } else {
//                       final Movie movie = snapshot.data!;
//                       final YoutubePlayerController _videoController = YoutubePlayerController(
//                         initialVideoId: movie.videoKey,
//                         flags: YoutubePlayerFlags(
//                           autoPlay: true,
//                           mute: false,
//                         ),
//                       );
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             height: 200,
//                             width: double.infinity,
//                             child: YoutubePlayer(
//                               controller: _videoController,
//                               showVideoProgressIndicator: true,
//                               progressIndicatorColor: Colors.amber,
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                           Text(
//                             'Title: ${movie.title}',
//                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'Overview: ${movie.overview}',
//                             textAlign: TextAlign.justify,
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             children: [
//                               Text(
//                                 'Rating: ',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               RatingBar.builder(
//                                 itemSize: 20,
//                                 initialRating: movie.rating ?? 0,
//                                 minRating: 0,
//                                 direction: Axis.horizontal,
//                                 allowHalfRating: true,
//                                 itemCount: 5,
//                                 itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
//                                 itemBuilder: (context, _) => Icon(
//                                   Icons.star,
//                                   color: Colors.amber,
//                                 ),
//                                 onRatingUpdate: (rating) {
//                                   print(rating);
//                                 },
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'Duration: ${movie.duration} mins',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'Release Date: ${movie.releaseDate.year}-${movie.releaseDate.month}-${movie.releaseDate.day}',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 10),
//                           Wrap(
//                             spacing: 8.0,
//                             children: movie.categories
//                                 .map((category) => Chip(label: Text(category)))
//                                 .toList(),
//                           ),
//                         ],
//                       );
//                     }
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Reviews:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 FutureBuilder<List<Review>>(
//                   future: _reviewsFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     } else {
//                       final List<Review> reviews = snapshot.data!;
//                       return Column(
//                         children: reviews
//                             .map(
//                               (review) => Card(
//                                 margin: EdgeInsets.symmetric(vertical: 4),
//                                 child: Padding(
//                                   padding: EdgeInsets.all(8),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Author: ${review.author}',
//                                         style: TextStyle(fontWeight: FontWeight.bold),
//                                       ),
//                                       SizedBox(height: 4),
//                                       Text(
//                                         review.content,
//                                         textAlign: TextAlign.justify,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                       );
//                     }
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Actors:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 FutureBuilder<List<Actor>>(
//                   future: _actorsFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     } else {
//                       final List<Actor> actors = snapshot.data!;
//                       return SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: actors
//                               .map(
//                                 (actor) => Card(
//                                   margin: EdgeInsets.symmetric(horizontal: 4),
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Name: ${actor.name}',
//                                           style: TextStyle(fontWeight: FontWeight.bold),
//                                         ),
//                                         SizedBox(height: 4),
//                                         Text(
//                                           'Character: ${actor.character}',
//                                         ),
//                                         SizedBox(height: 4),
//                                         if (actor.profilePath.isNotEmpty)
//                                           Image.network(
//                                             'https://image.tmdb.org/t/p/w200${actor.profilePath}',
//                                             width: 100,
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               )
//                               .toList(),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
