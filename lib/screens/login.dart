import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 200, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Lighthouse',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 45),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: RaisedButton(
                      padding: EdgeInsets.fromLTRB(45, 10, 45, 10),
                      color: Colors.blue[600],
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                      onPressed: () {
                        FocusScope.of(context)
                            .unfocus(); // dismiss keyboard on login
                        //Navigator.pushNamed(context, routeName)
                        print('Login');
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    child: Text(
                      'Forgot your password?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      //Navigator.pushNamed(context, routeName);
                      print('forgot password');
                    },
                  ),
                  SizedBox(height: 5),
                  InkWell(
                    child: Text(
                      'Create a new account',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      //Navigator.push(context, route);
                      print('create account');
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// maybe ?! why not ?!
class BgImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('assets/bgImage.jpg');
    Image image = Image(image: assetImage);
    return Container(child: image);
  }
}
