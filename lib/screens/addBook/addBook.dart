import 'package:book_club_ref/models/book.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/database.dart';
import 'package:book_club_ref/states/currentUser.dart';
import 'package:book_club_ref/widgets/ourContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddBook extends StatefulWidget {
  final bool onGroupCreation;
  final String? groupName;
  const AddBook({Key? key, this.groupName, required this.onGroupCreation})
      : super(key: key);

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  void _createGroup(
    BuildContext context,
    String groupName,
    OurBook book,
  ) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await OurDataBase()
        .createGroup(groupName, _currentUser.getCurrentUser!.userId!, book);
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

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked =
        (await DatePicker.showDateTimePicker(context, showTitleActions: true))!;
    setState(() {
      _selectedDate = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [BackButton()],
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: OurContainer(
              child: Column(
                children: [
                  TextFormField(
                    controller: _bookTitleInput,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.book),
                      hintText: "Titre du livre",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _bookAuthorInput,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.face),
                      hintText: "Auteur.e du livre",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _bookLengthInput,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.format_list_numbered),
                      hintText: "Nombre de pages",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(DateFormat("dd-MM à HH-mm").format(_selectedDate)),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              OurBook? book = OurBook(
                  title: _bookTitleInput.text,
                  author: _bookAuthorInput.text,
                  length: int.parse(_bookLengthInput.text),
                  dateCompleted: Timestamp.fromDate(_selectedDate));
              if (widget.onGroupCreation) {
                _createGroup(context, widget.groupName!, book);
              } else {
                CurrentUser _currentUser =
                    Provider.of<CurrentUser>(context, listen: false);
                OurDataBase()
                    .addBook(_currentUser.getCurrentUser!.groupId!, book);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OurRoot(),
                    ),
                    (route) => false);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Ajoutez le livre".toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
