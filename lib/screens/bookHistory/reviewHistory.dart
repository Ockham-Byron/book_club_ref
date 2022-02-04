import 'package:book_club_ref/models/authModel.dart';
import 'package:book_club_ref/models/bookModel.dart';
import 'package:book_club_ref/models/groupModel.dart';
import 'package:book_club_ref/models/reviewModel.dart';
import 'package:book_club_ref/models/userModel.dart';
import 'package:book_club_ref/screens/review/addareview.dart';
import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:book_club_ref/services/dbFuture.dart';
import 'package:book_club_ref/widgets/appDrawer.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

import 'local_widgets/eachReview.dart';

class ReviewHistory extends StatefulWidget {
  final UserModel currentUser;
  final AuthModel authModel;
  final String bookId;
  final String groupId;
  final BookModel currentBook;
  final GroupModel currentGroup;
  const ReviewHistory(
      {Key? key,
      required this.bookId,
      required this.groupId,
      required this.currentGroup,
      required this.currentBook,
      required this.currentUser,
      required this.authModel})
      : super(key: key);

  @override
  _ReviewHistoryState createState() => _ReviewHistoryState();
}

class _ReviewHistoryState extends State<ReviewHistory> {
  late Future<List<ReviewModel>> reviews = DBFuture()
      .getReviewHistory(widget.currentGroup, widget.groupId, widget.bookId);
  bool _doneWithBook = false;
  late int nbOfReviews = 0;
  late int nbOfFavorites = 0;

  @override
  void initState() {
    super.initState();

    _getNbOfReviews().whenComplete(() {
      setState(() {});
    });
  }

  Future _getNbOfReviews() async {
    nbOfReviews =
        await DBFuture().getNbOfReviews(widget.groupId, widget.bookId);
    nbOfFavorites =
        await DBFuture().getNbOfFavorites(widget.groupId, widget.bookId);
  }

  @override
  void didChangeDependencies() async {
    reviews = DBFuture()
        .getReviewHistory(widget.currentGroup, widget.groupId, widget.bookId);
    //check if the user is done with book
    if (widget.currentGroup.currentBookId != null) {
      if (await DBFuture().isUserDoneWithBook(
          widget.currentGroup.id!, widget.bookId, widget.currentUser.uid!)) {
        _doneWithBook = true;
      } else {
        _doneWithBook = false;
      }
      print(_doneWithBook);

      print(widget.currentUser.uid);
    }

    super.didChangeDependencies();
  }

  String _displayGroupName() {
    if (widget.currentGroup.name != null) {
      return widget.currentGroup.name!;
    } else {
      return "Groupe sans nom";
    }
  }

  bool withProfilePicture() {
    if (widget.currentUser.pictureUrl == "") {
      return false;
    } else {
      return true;
    }
  }

  Widget displayCircularAvatar() {
    if (withProfilePicture()) {
      return CircularProfileAvatar(
        widget.currentUser.pictureUrl,
        showInitialTextAbovePicture: false,
      );
    } else {
      return CircularProfileAvatar(
        "https://digitalpainting.school/static/img/default_avatar.png",
        foregroundColor: Theme.of(context).focusColor.withOpacity(0.5),
        initialsText: Text(
          widget.currentUser.pseudo![0].toUpperCase(),
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        showInitialTextAbovePicture: true,
      );
    }
  }

  void _goToReview() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddReview(
          currentGroup: widget.currentGroup,
          bookId: widget.bookId,
          fromRoute: ReviewHistory(
              bookId: widget.bookId,
              groupId: widget.currentGroup.id!,
              currentGroup: widget.currentGroup,
              currentBook: widget.currentBook,
              currentUser: widget.currentUser,
              authModel: widget.authModel),
        ),
      ),
    );
  }

  String _currentBookCoverUrl() {
    String currentBookCoverUrl;

    if (widget.currentBook.cover == "") {
      currentBookCoverUrl =
          "https://www.azendportafolio.com/static/img/not-found.png";
    } else {
      currentBookCoverUrl = widget.currentBook.cover!;
    }

    return currentBookCoverUrl;
  }

  Widget _displayBookInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(_currentBookCoverUrl()),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.currentBook.title ?? "Pas de titre",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).primaryColor),
              ),
              Text(
                widget.currentBook.author ?? "Pas d'auteur",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _displayAddReview() {
    if (!_doneWithBook) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
            onPressed: () => _goToReview(),
            child: Text("Indique que, toi, aussi, tu as terminé ce livre")),
      );
    } else {
      return Text("");
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover),
        ),
        child: FutureBuilder(
          future: reviews,
          builder: (BuildContext context,
              AsyncSnapshot<List<ReviewModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data!.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Builder(
                                      builder: (context) => GestureDetector(
                                        child: displayCircularAvatar(),
                                        onTap: () =>
                                            Scaffold.of(context).openDrawer(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    width: 200.0,
                                    decoration: new BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.grey.shade200
                                            .withOpacity(0.5)),
                                    child: Text(
                                      _displayGroupName(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.logout_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => _signOut(context),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                            ),
                            child: Column(
                              children: [
                                _displayBookInfo(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "LU PAR",
                                      style: kTitleStyle,
                                    ),
                                    Text(
                                      "FAVORIS",
                                      style: kTitleStyle,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      //ajouter nombre de reviews
                                      nbOfReviews.toString(),

                                      style: kSubtitleStyle,
                                    ),
                                    Text(
                                      //ajouter note
                                      nbOfFavorites.toString(),

                                      style: kSubtitleStyle,
                                    ),
                                  ],
                                ),
                                _displayAddReview(),
                                Text(
                                  "Avis du groupe",
                                  style: TextStyle(fontSize: 30),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 20),
                                  child: Text(
                                    "Pour info, il n'y a pas de note moyenne, car lorsque l'on a la tête dans le frigo et les pieds dans le four, notre température ne peut être qualifiée de tiède...",
                                    textAlign: TextAlign.justify,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: EachReview(
                          review: snapshot.data![index - 1],
                          currentUser: widget.currentUser,
                          currentGroup: widget.currentGroup,
                          book: widget.currentBook,
                          authModel: widget.authModel,
                        ),
                      );
                    }
                  },
                );
              } else {
                //Si pas de critique
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Builder(
                                builder: (context) => GestureDetector(
                                  child: displayCircularAvatar(),
                                  onTap: () =>
                                      Scaffold.of(context).openDrawer(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              width: 200.0,
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.grey.shade200.withOpacity(0.5)),
                              child: Text(
                                _displayGroupName(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => _signOut(context),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png"),
                                    fit: BoxFit.contain),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "Il n'y a pas encore de critique pour ce livre ;(",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 100),
                            ElevatedButton(
                              onPressed: () => _goToReview(),
                              child: Text("Ajouter la première critique"),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      drawer: AppDrawer(
        currentGroup: widget.currentGroup,
        currentUser: widget.currentUser,
        currentBook: widget.currentBook,
        authModel: widget.authModel,
      ),
    );
  }
}

final kTitleStyle = TextStyle(
  fontSize: 20,
  color: Colors.grey,
  fontWeight: FontWeight.w700,
);

final kSubtitleStyle = TextStyle(
  fontSize: 26,
  color: Colors.red[300],
  fontWeight: FontWeight.w700,
);
