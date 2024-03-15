import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_app/login.dart';
import 'package:movie_app/register.dart';
import 'package:movie_app/splashScreen.dart';
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
      title: 'Modiv',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.red,
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.red,
          cursorColor: Colors.red,
          selectionHandleColor: Colors.red,
        ),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 75,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
      routes: {
        // Define routes for navigation
        '/': (context) => const SplashScreen(
              child: Login(), // Show SplashScreen with Login as initial route
            ),
        '/login': (context) => const Login(), // Route to login screen
        '/register': (context) => const Register(), // Route to register screen
        '/home': (context) =>
            const NavigationBottomBar(), // Route to home screen with bottom navigation bar
      },
    );
  }
}
