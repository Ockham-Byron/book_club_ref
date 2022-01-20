import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/services/auth.dart';
import 'package:book_club_ref/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  FocusNode? fmail;
  FocusNode? fpassword;

  @override
  void initState() {
    super.initState();
    fmail = FocusNode();
    fpassword = FocusNode();
  }

  @override
  void dispose() {
    fmail?.dispose();
    fpassword?.dispose();
    super.dispose();
  }

  TextEditingController _emailInput = TextEditingController();
  TextEditingController _passwordInput = TextEditingController();
  bool _isHidden = true;

  void _loginUser(String email, String password, BuildContext context) async {
    try {
      if (await Auth().loginUser(email, password)) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OurRoot(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Mauvais email ou mauvais mot de passe, du coup ça marche pas"),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void _resetPassword(String email) async {
    try {
      String _returnString = await Auth().sendPasswordResetEmail(email);
    } catch (e) {
      print(e);
    }
  }

  Widget _buildPopupResetPassword(BuildContext context) {
    return new AlertDialog(
      title: Text("Ca arrive aux meilleurs..."),
      content: SizedBox(
        height: 110,
        child: Column(
          children: [
            Text(
                "Indiquez votre email et nous vous enverrons un lien pour changer votre mot de passe"),
            TextField(
              controller: _emailInput,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            _resetPassword(_emailInput.text);
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Salut à toi, avide de lectures !",
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
            autofocus: true,
            focusNode: fmail,
            onTap: () {
              setState(() {
                FocusScope.of(context).requestFocus(fmail);
              });
            },
            textInputAction: TextInputAction.next,
            controller: _emailInput,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).canvasColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColor)),
              labelText: "courriel",
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              prefixIcon: Icon(
                Icons.alternate_email,
                color: Theme.of(context).primaryColor,
              ),
            ),
            style: Theme.of(context).textTheme.headline6,
            onFieldSubmitted: (term) {
              fmail!.unfocus();
              FocusScope.of(context).requestFocus(fpassword);
            },
          ),
          TextFormField(
            focusNode: fpassword,
            obscureText: _isHidden,
            controller: _passwordInput,
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
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              minimumSize: Size(250, 50),
            ),
            onPressed: () {
              _loginUser(_emailInput.text, _passwordInput.text, context);
            },
            child: Text(
              "SE CONNECTER",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => _buildPopupResetPassword(context));
              },
              child: Text(
                "Oubli du mot de passe ?",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ))
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
