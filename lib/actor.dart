import 'package:flutter/material.dart';

class ActorDetailPage extends StatelessWidget {
  final int actorId;

  const ActorDetailPage({required Key key, required this.actorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch actor details based on actorId and display them
    return Scaffold(
      appBar: AppBar(
        title: Text('Actor Details'),
      ),
      body: Center(
        child: Text('Actor ID: $actorId'),
      ),
    );
  }
}
