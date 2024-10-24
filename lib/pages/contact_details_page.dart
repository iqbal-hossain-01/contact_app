import 'package:flutter/material.dart';

class ContactDetailsPage extends StatelessWidget {
  static const String routeName = '/detail';

  const ContactDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: Colors.blueGrey,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Edit'),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.ios_share),
          )
        ],
      ),
    );
  }
}
