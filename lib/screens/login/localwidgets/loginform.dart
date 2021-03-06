import 'package:book_club_ref/screens/root/root.dart';
import 'package:book_club_ref/screens/signup/signup.dart';
import 'package:book_club_ref/states/currentUser.dart';
import 'package:book_club_ref/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurLoginForm extends StatefulWidget {
  const OurLoginForm({Key? key}) : super(key: key);

  @override
  _OurLoginFormState createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  TextEditingController _emailInput = TextEditingController();
  TextEditingController _passwordInput = TextEditingController();
  bool _isHidden = true;

  void _loginUser(String email, String password, BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      if (await _currentUser.loginUser(email, password)) {
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

  @override
  Widget build(BuildContext context) {
    return OurContainer(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Salut à toi, avide de lectures !",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _emailInput,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.alternate_email,
              color: Theme.of(context).canvasColor,
            ),
            hintText: "courriel",
          ),
        ),
        TextFormField(
          obscureText: _isHidden,
          controller: _passwordInput,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Theme.of(context).canvasColor,
            ),
            hintText: "mot de passe",
            suffixIcon: IconButton(
              onPressed: _togglePasswordView,
              icon: Icon(
                _isHidden ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
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
            "Se connecter",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUp()));
          },
          child: Text(
            "Première visite ici ? Créez un compte",
            style: TextStyle(
              color: Theme.of(context).canvasColor,
            ),
          ),
        ),
      ],
    ));
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
