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

  runApp(const MyApp());
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
        '/': (context) => const SplashScreen(
              child: Login(),
            ),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/home': (context) => const Navigation(),
      },
    );
  }
}