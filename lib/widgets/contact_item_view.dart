import 'dart:io';

import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/pages/contact_details_page.dart';
import 'package:flutter/material.dart';

class ContactItemView extends StatelessWidget {
  final ContactModel contact;
  const ContactItemView({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
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
      onTap: () {
        Navigator.pushNamed(context, ContactDetailsPage.routeName, arguments: contact.id);
      },
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
  }
}
