
import 'dart:io';

import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/pages/new_contact_page.dart';
import 'package:contact_app/providers/local_db_provider.dart';
import 'package:contact_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactDetailsPage extends StatefulWidget {
  static const String routeName = '/detail';

  const ContactDetailsPage({super.key});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late int id;
  @override
  void didChangeDependencies() {
    id = ModalRoute.of(context)!.settings.arguments as int;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: Colors.grey.withOpacity(0.3),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, NewContactPage.routeName, arguments: id)
                  .then((_) {setState(() {});});
            },
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
                  contact.image != null && contact.image!.isNotEmpty
                      ? Card(
                          elevation: 1,
                          child: Image.file(
                            File(contact.image!),
                            width: 250,
                            height: 250,
                            fit: BoxFit.cover,))
                      : const Card(
                          elevation: 1,
                          child: Icon(Icons.person, size: 250)),

                  // ListTile(
                  //   title: Text('${contact.name?.isNotEmpty == true ? contact.name : ''}'),
                  // ),
                  //if (contact.name?.isNotEmpty == true)
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: () {
                            provider.updatedFavorite(contact);
                            setState(() {});
                          }, icon: Icon(contact.favorite ? Icons.favorite : Icons.favorite_border),
                          color: contact.favorite ? Colors.amber : null,),
                          Text(contact.name?.isNotEmpty == true ? contact.name!.trim()
                              : contact.number.trim(),
                            style: const TextStyle(fontSize: 22),),
                        ],
                      )
                    ),
                  ListTile(
                    title: Text(contact.number.trim()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {
                          _launchCall(contact.number);
                        }, icon: const Icon(Icons.call)),
                        IconButton(onPressed: () {
                          _launchSms(contact.number);
                        }, icon: const Icon(Icons.message)),
                      ],
                    ),
                  ),
                  if (contact.email?.isNotEmpty == true)
                    ListTile(
                      title: Text(contact.email!.trim()),
                      trailing: IconButton(onPressed: () {
                        _launchMail(contact.email!);
                      }, icon: const Icon(Icons.email),),
                    ),
                  if (contact.address?.isNotEmpty == true)
                    ListTile(
                      title: Text(contact.address!.trim()),
                      trailing: IconButton(onPressed: () {
                        _openMap(contact.address!);
                      }, icon: const Icon(Icons.location_city_sharp),),
                    ),
                  if (contact.website?.isNotEmpty == true)
                    ListTile(
                      title: Text(contact.website!.trim()),
                      trailing: IconButton(onPressed: () {
                        _launchWeb(contact.website!);
                      }, icon: const Icon(Icons.web),),
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

  void _launchCall(String mobile) async {
    final url = 'tel:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this task');
    }
  }

  void _launchSms(String number) async {
    final url = 'sms:$number';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this task');
    }
  }
  void _launchMail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    final url = emailUri.toString();
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this task');
    }
  }

  // void _launchMail(String email) async {
  //   final url = 'mailto:$email';
  //   if (await canLaunchUrlString(url)) {
  //     await launchUrlString(url);
  //   } else {
  //     showMsg(context, 'Cannot perform this task');
  //   }
  // }

  void _launchWeb(String website) async {
    final url = 'https:$website';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this task');
    }
  }

  void _openMap(String address) async {
    String url;
    if (Platform.isAndroid) {
      url = 'geo:0,0?q=$address';
    } else {
      url = 'http://maps.apple.com/?q=$address';
    }
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this task');
    }
  }
}

/*
import 'dart:io';
import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/local_db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactDetailsPage extends StatefulWidget {
  static const String routeName = '/detail';

  const ContactDetailsPage({super.key});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  ContactModel? _contact; // store contact data

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context)!.settings.arguments as int;
    _loadContact(id); // load contact data
  }

  Future<void> _loadContact(int id) async {
    final provider = Provider.of<LocalDbProvider>(context, listen: false);
    final contact = await provider.getContactById(id);
    setState(() {
      _contact = contact;
    });
  }

  void _toggleFavorite() async {
    if (_contact != null) {
      final provider = Provider.of<LocalDbProvider>(context, listen: false);
      await provider.updatedFavorite(_contact!);
      setState(() {
        _contact = _contact!.copyWith(favorite: !_contact!.favorite);
      });
      // toggle favorite
    }
  }

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
            onPressed: _toggleFavorite,
            icon: Icon(
              _contact?.favorite == true
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: _contact?.favorite == true ? Colors.red : Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.ios_share),
          )
        ],
      ),
      body: _contact == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _contact!.image != null && _contact!.image!.isNotEmpty
                    ? Card(
                        elevation: 1,
                        child: Image.file(
                          File(_contact!.image!),
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Card(
                        elevation: 1,
                        child: Icon(Icons.person, size: 250),
                      ),
                if (_contact!.name?.isNotEmpty == true)
                  ListTile(
                    title: Text(_contact!.name!),
                  ),
                ListTile(
                  title: Text(_contact!.number),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.call)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.message)),
                    ],
                  ),
                ),
                if (_contact!.email?.isNotEmpty == true)
                  ListTile(
                    title: Text(_contact!.email!),
                    trailing: const Icon(Icons.email),
                  ),
                if (_contact!.address?.isNotEmpty == true)
                  ListTile(
                    title: Text(_contact!.address!),
                    trailing: const Icon(Icons.location_city_sharp),
                  ),
                if (_contact!.website?.isNotEmpty == true)
                  ListTile(
                    title: Text(_contact!.website!),
                    trailing: const Icon(Icons.web),
                  ),
                if (_contact!.dob?.isNotEmpty == true)
                  ListTile(
                    title: const Text('Date of Birth'),
                    trailing: Text(_contact!.dob!),
                  ),
                if (_contact!.gender?.isNotEmpty == true)
                  ListTile(
                    title: const Text('Gender'),
                    trailing: Text(_contact!.gender!),
                  ),
                if (_contact!.group?.isNotEmpty == true)
                  ListTile(
                    title: const Text('Contact Group'),
                    trailing: Text(_contact!.group!),
                  ),
              ],
            ),
    );
  }
}

 */

/*
import 'dart:io';
import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/local_db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactDetailsPage extends StatefulWidget {
  static const String routeName = '/detail';

  const ContactDetailsPage({super.key});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late Future<ContactModel> _contactFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context)!.settings.arguments as int;
    _contactFuture = context.read<LocalDbProvider>().getContactById(id);
  }

  void _toggleFavorite(ContactModel contact) async {
    await context.read<LocalDbProvider>().updatedFavorite(contact);
    setState(() {
      _contactFuture = context.read<LocalDbProvider>().getContactById(contact.id!);
    });
  }

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
          FutureBuilder<ContactModel>(
            future: _contactFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final contact = snapshot.data!;
                return IconButton(
                  onPressed: () => _toggleFavorite(contact),
                  icon: Icon(
                    contact.favorite ? Icons.favorite : Icons.favorite_border,
                    color: contact.favorite ? Colors.red : Colors.white,
                  ),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: FutureBuilder<ContactModel>(
        future: _contactFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final contact = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(8),
              children: [
                contact.image != null && contact.image!.isNotEmpty
                    ? Card(
                        elevation: 1,
                        child: Image.file(
                          File(contact.image!),
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Card(
                        elevation: 1,
                        child: Icon(Icons.person, size: 250),
                      ),
                if (contact.name?.isNotEmpty == true)
                  ListTile(
                    title: Text(contact.name!),
                  ),
                ListTile(
                  title: Text(contact.number),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.call)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.message)),
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
                // Add additional fields as in your original code
              ],
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Failed to fetch data'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

 */

