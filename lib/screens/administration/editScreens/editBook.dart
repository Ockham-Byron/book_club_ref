import 'dart:ui';

import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class EditBook extends StatefulWidget {
  final GroupModel currentGroup;
  final BookModel currentBook;
  const EditBook(
      {Key? key, required this.currentGroup, required this.currentBook})
      : super(key: key);

  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  String? initialTitle;
  String? initialAuthor;
  int? initialPages;
  String? initialBookCover;

  @override
  void initState() {
    initialTitle = widget.currentBook.title;
    initialAuthor = widget.currentBook.author;
    initialPages = widget.currentBook.length;
    initialBookCover = widget.currentBook.cover;

    _bookTitleInput.text = initialTitle!;
    _bookAuthorInput.text = initialAuthor!;
    _bookLengthInput.text = initialPages!.toString();
    _bookCoverInput.text = initialBookCover!;

    super.initState();
  }

  TextEditingController _bookTitleInput = TextEditingController();
  TextEditingController _bookAuthorInput = TextEditingController();
  TextEditingController _bookLengthInput = TextEditingController();
  TextEditingController _bookCoverInput = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked =
        (await DatePicker.showDateTimePicker(context, showTitleActions: true))!;
    setState(() {
      _selectedDate = picked;
    });
  }

  void _editBook(
      String groupId,
      String bookId,
      String bookTitle,
      String bookAuthor,
      String bookCover,
      int bookPages,
      Timestamp dateCompleted) async {
    String _returnString;

    _returnString = await DBFuture().editBook(
        groupId: groupId,
        bookId: bookId,
        bookTitle: bookTitle,
        bookAuthor: bookAuthor,
        bookCover: bookCover,
        bookPages: bookPages,
        dateCompleted: dateCompleted);

    if (_returnString == "success") {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => OurRoot()));
    }
  }

  TextEditingController _groupNameInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: Container(
              height: 550,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: ShadowContainer(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _bookTitleInput,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).canvasColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        prefixIcon: Icon(
                          Icons.book,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: "Titre du livre",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _bookAuthorInput,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).canvasColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        prefixIcon: Icon(
                          Icons.face,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: "Auteur.e du livre",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _bookLengthInput,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).canvasColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        prefixIcon: Icon(
                          Icons.format_list_numbered,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: "Nombre de pages",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _bookCoverInput,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).canvasColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        prefixIcon: Icon(
                          Icons.auto_stories,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: "Url de la couverture du livre",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Rdv pour échanger sur ce livre le",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(DateFormat("dd/MM à HH:mm").format(_selectedDate),
                        style: Theme.of(context).textTheme.headline6),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _editBook(
                            widget.currentGroup.id!,
                            widget.currentBook.id!,
                            _bookTitleInput.text,
                            _bookAuthorInput.text,
                            _bookCoverInput.text,
                            int.parse(_bookLengthInput.text),
                            Timestamp.fromDate(_selectedDate));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          "Modifier".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
