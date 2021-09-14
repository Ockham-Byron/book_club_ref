import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/screens/addBook/addBook.dart';
import 'package:book_club_ref/screens/review/addareview.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';

import 'package:book_club_ref/states/currentGroup.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InGroup extends StatefulWidget {
  const InGroup({Key? key}) : super(key: key);

  @override
  _InGroupState createState() => _InGroupState();
}

class _InGroupState extends State<InGroup> {
  @override
  void initState() {
    super.initState();
    //CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    // CurrentGroup _currentGroup =
    //     Provider.of<CurrentGroup>(context, listen: false);

    //_currentGroup.updateStateFromDatabase(_currentUser.getCurrentUser!.groupId!,
    // _currentUser.getCurrentUser!.userId!);
  }

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

  // void _goToAddBook() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => AddBook(
  //         onGroupCreation: false,
  //       ),
  //     ),
  //   );
  // }

  // void _goToReview() {
  //   CurrentGroup _currentGroup =
  //       Provider.of<CurrentGroup>(context, listen: false);
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => AddReview(
  //         currentGroup: _currentGroup,
  //       ),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.outbond_rounded,
              color: Colors.white,
            ),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      // body: ListView(
      //   children: [
      //     SizedBox(
      //       height: 40,
      //     ),
      //     Stack(
      //       alignment: Alignment.center,
      //       children: [
      //         Container(
      //           margin: EdgeInsets.only(top: 160),
      //           child: Padding(
      //             padding: const EdgeInsets.all(20),
      //             child: OurContainer(
      //               child: Padding(
      //                 padding: const EdgeInsets.only(top: 40),
      //                 child: Consumer<CurrentGroup>(
      //                   builder: (BuildContext context, value, Widget? child) {
      //                     var _currentBookTitle = value.getCurrentBook.title ??
      //                         "pas de livre choisi";
      //                     var today = DateTime.now();
      //                     var _currentBookDue =
      //                         value.getCurrentGroup.currentBookDue;
      //                     if (_currentBookDue == null) {
      //                       _currentBookDue = Timestamp.now();
      //                     }

      //                     var _remainingDays =
      //                         _currentBookDue.toDate().difference(today);
      //                     String _displayRemainingDays() {
      //                       String retVal;
      //                       if (_currentBookDue == Timestamp.now()) {
      //                         retVal = "pas de rdv fixé";
      //                       } else {
      //                         if (_remainingDays.isNegative) {
      //                           retVal = "le rdv a déjà eu lieu";
      //                         } else {
      //                           retVal = "Rdv pour échanger dans " +
      //                               _remainingDays.inDays.toString() +
      //                               " jours";
      //                         }
      //                       }

      //                       return retVal;
      //                     }

      //                     return Column(
      //                       children: [
      //                         Text(
      //                           _currentBookTitle,
      //                           style: TextStyle(
      //                             fontSize: 20,
      //                             color: Colors.white,
      //                           ),
      //                           textAlign: TextAlign.left,
      //                         ),
      //                         Padding(
      //                           padding:
      //                               const EdgeInsets.symmetric(vertical: 20),
      //                           child: Text(
      //                             _displayRemainingDays(),
      //                             style: TextStyle(
      //                               fontSize: 20,
      //                               fontWeight: FontWeight.bold,
      //                               color: Theme.of(context).accentColor,
      //                             ),
      //                           ),
      //                         ),
      //                         Padding(
      //                           padding:
      //                               const EdgeInsets.symmetric(vertical: 20),
      //                           child: ElevatedButton(
      //                             style: ButtonStyle(
      //                               backgroundColor: MaterialStateProperty
      //                                   .resolveWith<Color>(
      //                                 (Set<MaterialState> states) {
      //                                   if (states
      //                                       .contains(MaterialState.pressed))
      //                                     return Theme.of(context)
      //                                         .primaryColor
      //                                         .withOpacity(1);
      //                                   else if (states
      //                                       .contains(MaterialState.disabled))
      //                                     return Theme.of(context)
      //                                         .primaryColor
      //                                         .withOpacity(0.5);
      //                                   return Theme.of(context).canvasColor;
      //                                 },
      //                               ),
      //                             ),
      //                             onPressed: value.getDoneWithCurrentBook
      //                                 ? null
      //                                 : _goToReview,
      //                             child: Text("Livre terminé !"),
      //                           ),
      //                         )
      //                       ],
      //                     );
      //                   },
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //         Positioned(
      //           top: 10,
      //           child: Container(
      //             height: 200,
      //             width: 150,
      //             decoration: BoxDecoration(
      //               image: DecorationImage(
      //                   image: NetworkImage(
      //                       "https://products-images.di-static.com/image/mathias-enard-la-perfection-du-tir/9782742744121-475x500-1.jpg")),
      //               boxShadow: [
      //                 BoxShadow(
      //                   color: Colors.black54,
      //                   blurRadius: 10.0,
      //                   spreadRadius: 1.0,
      //                   offset: Offset(1.0, 1.0),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //     SizedBox(
      //       height: 10,
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20.0),
      //       child: ElevatedButton(
      //           onPressed: () => _goToAddBook(),
      //           child: Text("Voir l'historique du club de lecture"),
      //           style: ElevatedButton.styleFrom(
      //               primary: Theme.of(context).canvasColor,
      //               side: BorderSide(
      //                   width: 1, color: Theme.of(context).primaryColor))),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 40),
      //       child: ElevatedButton(
      //           onPressed: () => _signOut(context),
      //           child: Text("Se déconnecter")),
      //     ),
      //   ],
      // ),
    );
  }
}
