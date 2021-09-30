import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class AddBook extends StatefulWidget {
  final bool onGroupCreation;
  final bool onError;
  final String? groupName;
  final UserModel currentUser;
  final GroupModel? currentGroup;
  const AddBook(
      {Key? key,
      this.groupName,
      required this.onGroupCreation,
      required this.onError,
      required this.currentUser,
      this.currentGroup})
      : super(key: key);

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
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

  void _addBook(BuildContext context, String groupName, BookModel book) async {
    String _returnString;

    if (widget.onGroupCreation) {
      _returnString =
          await DBFuture().createGroup(groupName, widget.currentUser, book);
    } else if (widget.onError) {
      _returnString =
          await DBFuture().addCurrentBook(widget.currentUser.groupId!, book);
    } else {
      int _nbOfMembers = widget.currentGroup!.members!.length;
      int? _actualPicker = widget.currentGroup!.indexPickingBook;
      int _nextPicker;
      if (_actualPicker == (_nbOfMembers - 1)) {
        _nextPicker = 0;
      } else {
        _nextPicker = (_actualPicker! + 1);
      }
      _returnString = await DBFuture()
          .addNextBook(widget.currentGroup!.id!, book, _nextPicker);
    }

    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurRoot(),
          ),
          (route) => false);
    }
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

  Widget _displayButtons() {
    if (widget.onGroupCreation) {
      return Column(
        children: [
          ElevatedButton(
            onPressed: () {
              BookModel? book = BookModel(
                  title: _bookTitleInput.text,
                  author: _bookAuthorInput.text,
                  length: int.parse(_bookLengthInput.text),
                  cover: _bookCoverInput.text,
                  dateCompleted: Timestamp.fromDate(_selectedDate));
              _addBook(context, widget.groupName!, book);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Ajouter le livre".toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              BookModel? book = BookModel(
                  title: "pas déterminé", dateCompleted: Timestamp.now());
              _addBook(context, widget.groupName!, book);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Sauter cette étape".toUpperCase(),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).canvasColor,
              side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          BookModel? book = BookModel(
              title: _bookTitleInput.text,
              author: _bookAuthorInput.text,
              length: int.parse(_bookLengthInput.text),
              cover: _bookCoverInput.text,
              dateCompleted: Timestamp.fromDate(_selectedDate));
          _addBook(context, widget.currentGroup!.name!, book);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            "Ajoutez le livre".toUpperCase(),
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
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
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ShadowContainer(
              child: Column(
                children: [
                  TextFormField(
                    controller: _bookTitleInput,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.book,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: "Titre du livre",
                      labelStyle:
                          TextStyle(color: Theme.of(context).canvasColor),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _bookAuthorInput,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.face,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: "Auteur.e du livre",
                      labelStyle:
                          TextStyle(color: Theme.of(context).canvasColor),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _bookLengthInput,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.format_list_numbered,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: "Nombre de pages",
                      labelStyle:
                          TextStyle(color: Theme.of(context).canvasColor),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _bookCoverInput,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.auto_stories,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: "Url de la couverture du livre",
                      labelStyle:
                          TextStyle(color: Theme.of(context).canvasColor),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Rdv pour échanger sur ce livre le",
                    style: TextStyle(
                        color: Theme.of(context).canvasColor, fontSize: 20),
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
                ],
              ),
            ),
          ),
          _displayButtons(),
        ],
      ),
    );
  }
}
