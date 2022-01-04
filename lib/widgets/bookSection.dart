// import 'package:flutter/material.dart';

// class BookSection extends StatelessWidget {
//   final String heading;
//   BookSection({required this.heading});
//   @override
//   Widget build(BuildContext context) {
//     List<Book> bookList;
//     if (heading == "Continue Reading") {
//       bookList = recentBooks;
//     } else if (heading == "Discover More") {
//       bookList = allBooks;
//     } else if (heading == "BookShelf") {
//       bookList = allBooks;
//     }
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             heading,
//             style: TextStyle(
//               fontSize: 30,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(
//               vertical: 10,
//             ),
//             height: MediaQuery.of(context).size.height * 0.4,
//             child: ListView.builder(
//               itemBuilder: (ctx, i) => GestureDetector(
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (ctx) => BooksDetails(
//                       index: i,
//                       section: heading,
//                     ),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Column(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(
//                             top: 10,
//                             left: 5,
//                           ),
//                           height: MediaQuery.of(context).size.height * 0.27,
//                           width: MediaQuery.of(context).size.width * 0.4,
//                           child: Stack(
//                             children: [
//                               Container(
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.4),
//                                       blurRadius: 5,
//                                       offset: Offset(8, 8),
//                                       spreadRadius: 1,
//                                     )
//                                   ],
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(20),
//                                   child: Image.asset(
//                                     bookList[i].coverImage,
//                                     fit: BoxFit.fill,
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.27,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                   gradient: new LinearGradient(
//                                     colors: [
//                                       Colors.black.withOpacity(0.4),
//                                       Colors.transparent,
//                                       Colors.black.withOpacity(0.4),
//                                     ],
//                                     begin: Alignment.centerLeft,
//                                     end: Alignment.centerRight,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           bookList[i].name,
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 2,
//                         ),
//                         Text(
//                           bookList[i].author,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       width: 30,
//                     ),
//                   ],
//                 ),
//               ),
//               itemCount: bookList.length,
//               scrollDirection: Axis.horizontal,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }