// import 'package:book_club_ref/screens/root/root.dart';
// import 'package:book_club_ref/states/currentUser.dart';
// import 'package:book_club_ref/widgets/ourContainer.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class OurSignUpForm extends StatefulWidget {
//   const OurSignUpForm({Key? key}) : super(key: key);

//   @override
//   _OurSignUpFormState createState() => _OurSignUpFormState();
// }

// class _OurSignUpFormState extends State<OurSignUpForm> {
//   TextEditingController _pseudoInput = TextEditingController();
//   TextEditingController _emailInput = TextEditingController();
//   TextEditingController _passwordInput = TextEditingController();
//   TextEditingController _passwordBisInput = TextEditingController();

//   void _signUpUser(String email, String password, String pseudo,
//       BuildContext context) async {
//     CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
//     String _returnString =
//         await _currentUser.signUpUser(email, password, pseudo);

//     try {
//       if (_returnString == "success") {
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => OurRoot()));
//       } else {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(_returnString)));
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   bool _isHidden = true;

//   @override
//   Widget build(BuildContext context) {
//     return OurContainer(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               "Tout commence par un incipit",
//               style: TextStyle(
//                 color: Theme.of(context).primaryColor,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           TextFormField(
//             controller: _pseudoInput,
//             decoration: InputDecoration(
//               prefixIcon: Icon(Icons.person),
//               hintText: "pseudo",
//             ),
//           ),
//           TextFormField(
//             controller: _emailInput,
//             decoration: InputDecoration(
//               prefixIcon: Icon(Icons.alternate_email),
//               hintText: "courriel",
//             ),
//           ),
//           TextFormField(
//             controller: _passwordInput,
//             obscureText: _isHidden,
//             decoration: InputDecoration(
//               prefixIcon: Icon(Icons.lock_outline),
//               hintText: "mot de passe",
//               suffixIcon: IconButton(
//                 onPressed: _togglePasswordView,
//                 icon: Icon(
//                   _isHidden ? Icons.visibility : Icons.visibility_off,
//                 ),
//               ),
//             ),
//           ),
//           TextFormField(
//             controller: _passwordBisInput,
//             decoration: InputDecoration(
//               prefixIcon: Icon(Icons.lock_outline),
//               hintText: "mot de passe bis repetita",
//               suffixIcon: IconButton(
//                 onPressed: _togglePasswordView,
//                 icon: Icon(
//                   _isHidden ? Icons.visibility : Icons.visibility_off,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 40,
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               primary: Theme.of(context).primaryColor,
//               minimumSize: Size(250, 50),
//             ),
//             onPressed: () {
//               if (_passwordInput.text == _passwordBisInput.text) {
//                 _signUpUser(_emailInput.text, _passwordInput.text,
//                     _pseudoInput.text, context);
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text("mots de passe différents"),
//                   ),
//                 );
//               }
//             },
//             child: Text(
//               "S'inscrire",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text(
//               "Vous avez déjà un compte ? Connectez-vous",
//               style: TextStyle(
//                 color: Theme.of(context).canvasColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _togglePasswordView() {
//     setState(() {
//       _isHidden = !_isHidden;
//     });
//   }
// }
