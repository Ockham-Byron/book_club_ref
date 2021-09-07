import 'package:book_club_ref/screens/home/home.dart';
import 'package:book_club_ref/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/root/root.dart';
import 'utils/ourTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Book Club',
        theme: OurTheme().buildTheme(),
        home: OurRoot(),
        routes: {
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
