import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/bookHistory/booksDetails.dart';
import 'package:flutter/material.dart';

class BookSection extends StatelessWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  final BookModel currentBook;
  final String heading;
  BookSection(
      {required this.currentGroup,
      required this.currentUser,
      required this.currentBook,
      required this.heading});

  @override
  Widget build(BuildContext context) {
    List<BookModel> bookList = [];
    List<BookModel> recentBooks = [currentBook];
    if (heading == "Continuer de lire") {
      bookList = recentBooks;
    }
    // else if (heading == "Livres lus") {
    //   bookList = readBooks;
    // } else if (heading == "Livres à lire") {
    //   bookList = noReadBooks;
    // } else if (heading == "Livres du groupe") {
    //   bookList = allBooks;
    // }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            height: MediaQuery.of(context).size.height * 0.4,
            child: ListView.builder(
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => BooksDetails(
                      index: i,
                      section: heading,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 5,
                          ),
                          height: MediaQuery.of(context).size.height * 0.27,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(currentBook.cover!,
                                        scale: 1),
                                  ),
                                  //borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.27,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          bookList[i].title!,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          bookList[i].author!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ),
              itemCount: bookList.length,
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }
}
