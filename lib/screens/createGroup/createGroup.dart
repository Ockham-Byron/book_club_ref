// import 'package:book_club_ref/screens/addBook/addBook.dart';
// import 'package:book_club_ref/screens/root/root.dart';

// import 'package:book_club_ref/states/currentUser.dart';
// import 'package:book_club_ref/widgets/ourContainer.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class OurCreateGroup extends StatefulWidget {
//   const OurCreateGroup({Key? key}) : super(key: key);

//   @override
//   _OurCreateGroupState createState() => _OurCreateGroupState();
// }

// class _OurCreateGroupState extends State<OurCreateGroup> {
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

//   TextEditingController _groupNameInput = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [BackButton()],
//             ),
//           ),
//           SizedBox(
//             height: 100,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: OurContainer(
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _groupNameInput,
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.group),
//                       hintText: "Nom du groupe",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pushAndRemoveUntil(
//                   MaterialPageRoute(
//                     builder: (context) => AddBook(
//                       groupName: _groupNameInput.text,
//                       onGroupCreation: true,
//                     ),
//                   ),
//                   (route) => false);
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 50),
//               child: Text(
//                 "Créez le groupe".toUpperCase(),
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20),
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _signOut(context);
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 50),
//               child: Text(
//                 "Se déconnecter".toUpperCase(),
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
