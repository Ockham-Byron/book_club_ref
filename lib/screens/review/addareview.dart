import 'package:book_club_ref/states/currentGroup.dart';
import 'package:book_club_ref/states/currentUser.dart';
import 'package:book_club_ref/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddReview extends StatefulWidget {
  final CurrentGroup currentGroup;
  const AddReview({Key? key, required this.currentGroup}) : super(key: key);

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  int _dropdownValue = 1;
  TextEditingController _reviewInput = TextEditingController();

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
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Evaluez le livre de 1 à 10",
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).accentColor),
              ),
              DropdownButton<int>(
                  value: _dropdownValue,
                  icon: Icon(
                    Icons.arrow_downward,
                    color: Theme.of(context).accentColor,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).accentColor),
                  underline: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 2,
                    color: Theme.of(context).accentColor,
                  ),
                  onChanged: (int? newValue) {
                    setState(() {
                      _dropdownValue = newValue!;
                    });
                  },
                  items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList())
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: OurContainer(
              child: Column(
                children: [
                  TextFormField(
                    controller: _reviewInput,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Votre critique du livre",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String uid = Provider.of<CurrentUser>(context, listen: false)
                  .getCurrentUser!
                  .userId!;
              widget.currentGroup
                  .finishedBook(uid, _dropdownValue, _reviewInput.text);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Envoyer votre critique".toUpperCase(),
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
