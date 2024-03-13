import 'package:flutter/material.dart';

class CategoryDetailsPage extends StatelessWidget {
  final String categoryId;

  const CategoryDetailsPage({Key? key, required this.categoryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60,),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              '$categoryId',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Top Rated Movies",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
