import 'package:contact_app/pages/contact_details_page.dart';
import 'package:contact_app/pages/home_page.dart';
import 'package:contact_app/pages/new_contact_page.dart';
import 'package:contact_app/providers/firebase_db_provider.dart';
import 'package:contact_app/providers/local_db_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocalDbProvider(),),
        ChangeNotifierProvider(create: (context) => FirebaseDbProvider(),),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName : (context) => const HomePage(),
        NewContactPage.routeName: (context) => const NewContactPage(),
        ContactDetailsPage.routeName: (context) => const ContactDetailsPage(),
      },
    );
  }
}
