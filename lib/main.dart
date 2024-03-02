import 'package:flutter/material.dart';
import 'trending.dart';
import 'search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData.dark(), // Set the overall theme to dark
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    Trending(),
    Search(),
    WatchPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bottom Navigation Bar Example'),
        backgroundColor: Colors.black, // Change the background color of the app bar
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // Disable splash color
          highlightColor: Colors.transparent, // Disable highlight color
        ),
        child: Container(
          height: 70, // Increase the height of the bottom navigation bar
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black,
                Colors.transparent,
              ],
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent, // Set background to transparent
            type: BottomNavigationBarType.fixed, // Ensure all labels are visible
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.white), // Change the color of the icon
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up, color: Colors.white), // Change the color of the icon
                label: 'Trending',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Colors.white), // Change the color of the icon
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.watch, color: Colors.white), // Change the color of the icon
                label: 'Watch',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white, // Change the color of the selected item
            unselectedItemColor: Colors.grey, // Change the color of the unselected items
            onTap: _onItemTapped,
            selectedLabelStyle: TextStyle(color: Colors.white), // Set the color of the selected item label
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TrendingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Trending Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Search Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class WatchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Watch Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
    );
  }
}
