import 'dart:io';
import 'package:contact_app/main.dart';
import 'package:contact_app/pages/new_contact_page.dart';
import 'package:contact_app/providers/local_db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    context.read<LocalDbProvider>().getAllContacts();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: Colors.blue,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Edit'),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, NewContactPage.routeName);
            },
            icon: const Icon(Icons.settings_outlined),
          )
        ],
      ),
      body: Consumer<LocalDbProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.contactList.length,
          itemBuilder: (context, index) {
            final contact = provider.contactList[index];
            String cleanedName = contact.name?.trim() ?? '';
            String cleanedNumber = contact.number?.trim().replaceAll(' ', '') ?? '';

            // Display logic
            String displayText;
            if (cleanedName.isNotEmpty) {
              displayText = cleanedName;
            } else {
              displayText = cleanedNumber.isNotEmpty ? cleanedNumber : ''; // Show full number
            }

            return ListTile(
              title: Text(displayText),
              leading: CircleAvatar(
                backgroundImage: contact.image != null && File(contact.image!).existsSync()
                    ? FileImage(File(contact.image!)) // Load image from path
                    : null, // If image doesn't exist
                backgroundColor: contact.image == null ? Colors.blue : null,
                child: contact.image == null
                    ? Text(
                  cleanedName.isNotEmpty
                      ? cleanedName[0].toUpperCase() // First letter of name
                      : cleanedNumber.length >= 3
                      ? cleanedNumber.substring(cleanedNumber.length - 3) // Last 3 digits of number
                      : cleanedNumber, // Display the entire number if it's less than 3 digits
                  style: const TextStyle(color: Colors.white),
                )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
