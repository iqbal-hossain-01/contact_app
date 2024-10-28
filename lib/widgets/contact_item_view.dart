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
    String cleanedNumber = contact.number.trim().replaceAll(' ', '') ?? '';
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

/*
import 'dart:io';

import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/pages/contact_details_page.dart';
import 'package:flutter/material.dart';

class ContactItemView extends StatelessWidget {
  final ContactModel contact;
  const ContactItemView({super.key, required this.contact});

  // Utility function to check if the contact has an image
  bool hasValidImage(String? imagePath) {
    return imagePath != null && File(imagePath).existsSync();
  }

  // Utility to get display text for the avatar
  String getAvatarText(String cleanedName, String cleanedNumber) {
    if (cleanedName.isNotEmpty) {
      return cleanedName[0].toUpperCase();
    } else if (cleanedNumber.length >= 3) {
      return cleanedNumber.substring(cleanedNumber.length - 3);
    }
    return cleanedNumber; // Show the entire number if less than 3 digits
  }

  @override
  Widget build(BuildContext context) {
    String cleanedName = contact.name?.trim() ?? '';
    String cleanedNumber = contact.number?.trim().replaceAll(' ', '') ?? '';

    // Set display text for ListTile title
    String displayText = cleanedName.isNotEmpty ? cleanedName : cleanedNumber;

    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, ContactDetailsPage.routeName, arguments: contact.id);
      },
      title: Text(displayText),
      leading: CircleAvatar(
        backgroundImage: hasValidImage(contact.image) ? FileImage(File(contact.image!)) : null,
        backgroundColor: contact.image == null ? Colors.blue : null,
        child: contact.image == null
            ? Text(
                getAvatarText(cleanedName, cleanedNumber),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }
}

 */

/*
Widget buildAvatar(ContactModel contact) {
  return CircleAvatar(
    backgroundColor: contact.image != null && contact.image!.isNotEmpty ? Colors.transparent : Colors.purple,
    backgroundImage: contact.image != null && contact.image!.isNotEmpty ? FileImage(File(contact.image!)) : null,
    child: contact.image == null || contact.image!.isEmpty
        ? Text(
            contact.name != null && contact.name!.isNotEmpty
                ? contact.name![0]
                : contact.number.substring(contact.number.length - 3),
            style: TextStyle(color: Colors.white),
          )
        : null,
  );
}

 */
