import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:flutter/material.dart';

class OurSplashScreen extends StatelessWidget {
  const OurSplashScreen({Key? key}) : super(key: key);

  void _signOut(BuildContext context) async {
    String _returnedString = await Auth().signOut();
    if (_returnedString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => OurRoot(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("les pages tournent, tournent, dans le vide..."),
            ElevatedButton(
                onPressed: () => _signOut(context),
                child: Text("Fermer le livre"))
          ],
        ),
      ),
    );
  }
}
