import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/local_db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactDetailsPage extends StatelessWidget {
  static const String routeName = '/detail';

  const ContactDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
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
      body: Consumer<LocalDbProvider>(
        builder: (context, provider, child) => FutureBuilder<ContactModel>(
          future: provider.getContactById(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final contact = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  // ListTile(
                  //   title: Text('${contact.name?.isNotEmpty == true ? contact.name : ''}'),
                  // ),
                  if (contact.name?.isNotEmpty == true)
                    ListTile(
                      title: Text(contact.name!),
                    ),
                  ListTile(
                    title: Text(contact.number),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
                      ],
                    ),
                  ),
                  if (contact.email?.isNotEmpty == true)
                    ListTile(
                      title: Text(contact.email!),
                      trailing: const Icon(Icons.email),
                    ),
                  if (contact.address?.isNotEmpty == true)
                    ListTile(
                      title: Text(contact.address!),
                      trailing: const Icon(Icons.location_city_sharp),
                    ),
                  if (contact.website?.isNotEmpty == true)
                    ListTile(
                      title: Text(contact.website!),
                      trailing: const Icon(Icons.web),
                    ),
                  if (contact.dob?.isNotEmpty == true)
                    ListTile(
                      title: const Text('Date of Brith'),
                      trailing: Text(contact.dob!),
                    ),
                  if (contact.gender?.isNotEmpty == true)
                    ListTile(
                      title: const Text('Gender'),
                      trailing: Text(contact.gender!),
                    ),
                  if (contact.group?.isNotEmpty == true)
                    ListTile(
                      title: const Text('Contact Group'),
                      trailing: Text(contact.group!),
                    ),
                ],
              );
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Failed to fetch data'),);
            }
            return const Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}
