import 'package:flutter/material.dart';
import 'package:movie_app/internetChecker.dart';
import 'package:movie_app/settings.dart';
import 'package:movie_app/search.dart';
import 'package:movie_app/home.dart';
import 'package:movie_app/watch.dart';

class NavigationBottomBar extends StatefulWidget {
  const NavigationBottomBar({Key? key}) : super(key: key);

  @override
  _NavigationBottomBarState createState() => _NavigationBottomBarState();
}

class _NavigationBottomBarState extends State<NavigationBottomBar> {
  // List of pages to be displayed
  final List<Widget> _pages = [
    Home(),
    Search(),
    Watch(),
    Settings(),
  ];

  // Icons corresponding to each page
  static const List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.watch,
    Icons.settings,
  ];

  // Controller for handling page navigation
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  // Function to handle bottom navigation bar item tap
  void _onItemTapped(int index) {
    // Only update state if the selected index changes
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InternetChecker(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Modiv',
          ),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            // PageView for displaying pages
            PageView(
              controller: _pageController,
              children: _pages,
              onPageChanged: (index) {
                // Update selected index when the page changes
                if (index != _selectedIndex) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black,
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    _icons.length,
                    (index) => buildNavBarItem(_icons[index], _pages[index], index),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for building bottom navigation bar item
  Widget buildNavBarItem(IconData icon, Widget page, int index) {
    final bool isSelected = index == _selectedIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
              ),
              const SizedBox(height: 4),
              // Display text based on the type of page
              Text(
                page is Home
                    ? 'Home'
                    : page is Search
                        ? 'Search'
                        : page is Watch
                            ? 'Watch'
                            : 'Settings',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
