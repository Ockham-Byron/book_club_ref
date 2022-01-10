import 'package:book_club_ref/services/auth.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  FocusNode? fpseudo;
  FocusNode? fmail;
  FocusNode? fpassword;
  FocusNode? fpasswordbis;
  FocusNode? fpicture;

  @override
  void initState() {
    super.initState();
    fmail = FocusNode();
    fpassword = FocusNode();
    fpseudo = FocusNode();
    fpasswordbis = FocusNode();
  }

  @override
  void dispose() {
    fmail?.dispose();
    fpassword?.dispose();
    fpseudo?.dispose();
    fpasswordbis?.dispose();
    super.dispose();
  }

  TextEditingController _pseudoInput = TextEditingController();
  TextEditingController _emailInput = TextEditingController();
  TextEditingController _passwordInput = TextEditingController();
  TextEditingController _passwordBisInput = TextEditingController();
  TextEditingController _pictureInput = TextEditingController();
  String pictureUrl = "";

  void _signUpUser(String email, String password, String pseudo,
      String pictureUrl, BuildContext context) async {
    try {
      String _returnString =
          await Auth().signUpUser(email, password, pseudo, pictureUrl);
      if (_returnString == "success") {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_returnString)));
      }
    } catch (e) {
      print(e);
    }
  }

  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Tout commence par un incipit",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            focusNode: fpseudo,
            controller: _pseudoInput,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).canvasColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColor)),
              prefixIcon:
                  Icon(Icons.person, color: Theme.of(context).primaryColor),
              labelText: "pseudo",
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
          TextFormField(
            focusNode: fmail,
            controller: _emailInput,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).canvasColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColor)),
              prefixIcon: Icon(Icons.alternate_email,
                  color: Theme.of(context).primaryColor),
              labelText: "courriel",
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
          TextFormField(
            focusNode: fpassword,
            controller: _passwordInput,
            obscureText: _isHidden,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).canvasColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColor)),
              prefixIcon: Icon(Icons.lock_outline,
                  color: Theme.of(context).primaryColor),
              labelText: "mot de passe",
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              suffixIcon: IconButton(
                onPressed: _togglePasswordView,
                icon: Icon(
                  _isHidden ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
          TextFormField(
            focusNode: fpasswordbis,
            controller: _passwordBisInput,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).canvasColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColor)),
              prefixIcon: Icon(Icons.lock_outline,
                  color: Theme.of(context).primaryColor),
              labelText: "mot de passe bis repetita",
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              suffixIcon: IconButton(
                onPressed: _togglePasswordView,
                icon: Icon(
                  _isHidden ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
          TextFormField(
            focusNode: fpicture,
            controller: _pictureInput,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).canvasColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColor)),
              prefixIcon:
                  Icon(Icons.camera, color: Theme.of(context).primaryColor),
              labelText: "adresse url de votre photo de profil",
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              minimumSize: Size(250, 50),
            ),
            onPressed: () {
              if (_passwordInput.text == _passwordBisInput.text) {
                _signUpUser(_emailInput.text, _passwordInput.text,
                    _pseudoInput.text, _pictureInput.text, context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("mots de passe différents"),
                  ),
                );
              }
            },
            child: Text(
              "S'INSCRIRE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
