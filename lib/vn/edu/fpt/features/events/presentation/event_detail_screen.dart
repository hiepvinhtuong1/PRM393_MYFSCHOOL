import 'package:flutter/material.dart';

/// TODO: Implement EventDetailScreen.
class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({required this.eventId, super.key});
  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sự kiện')),
      body: Center(child: Text('Event: \$eventId')),
    );
  }
}
