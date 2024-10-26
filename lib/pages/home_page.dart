import 'dart:io';

import 'package:contact_app/pages/new_contact_page.dart';
import 'package:contact_app/providers/local_db_provider.dart';
import 'package:contact_app/widgets/contact_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    context.read<LocalDbProvider>().getAllContacts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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

            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.red,
                child: const Icon(Icons.delete_rounded),
              ),
              confirmDismiss: (direction) {
                return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: contact.name?.isNotEmpty == true
                        ? Text('Delete ${contact.name}?')
                        : Text('Delete ${contact.number}?'),
                    content: Text(
                      'Are you sure to delete contact ${contact.name?.isNotEmpty == true ? contact.name : contact.number}?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('No'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: (direction) {
                context.read<LocalDbProvider>().deleteContact(contact);
              },
              child: ContactItemView(contact: contact),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'All',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
          ],
        ),
      ),
    );
  }
}
