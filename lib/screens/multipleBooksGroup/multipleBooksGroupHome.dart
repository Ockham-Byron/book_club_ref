// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:book_club_ref/states/currentUser.dart';
// import 'package:book_club_ref/screens/root/root.dart';

// class MultipleBooksGroupHome extends StatefulWidget {
//   final bool onGroupCreation;
//   final String? groupName;

//   const MultipleBooksGroupHome(
//       {Key? key, required this.onGroupCreation, this.groupName})
//       : super(key: key);

//   @override
//   _MultipleBooksGroupHomeState createState() => _MultipleBooksGroupHomeState();
// }

// class _MultipleBooksGroupHomeState extends State<MultipleBooksGroupHome> {
//   void _signOut(BuildContext context) async {
//     CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

//     String _returnedString = await _currentUser.signOut();
//     if (_returnedString == "success") {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (context) => OurRoot(),
//         ),
//         (route) => false,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Text("Option en construction"),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: ElevatedButton(
//                 onPressed: () => _signOut(context),
//                 child: Text("Se déconnecter")),
//           ),
//         ],
//       ),
//     );
//   }
// }
