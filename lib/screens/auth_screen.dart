import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_lighthouse/providers/auth.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 8.0),
                          child: FittedBox(
                            child: Text(
                              'The\nLighthouse',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: deviceSize.width / 10.roundToDouble(),
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'name': '',
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  String _password;

  Future<void> _submit(String action) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    print(action);
    try {
      if (action == 'login') {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false).register(
            _authData['name'], _authData['email'], _authData['password']);
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showDialogue();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showDialogue() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text('something went wrong'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Approve'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return DefaultTabController(
        length: 2,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            TabBar(
              tabs: [
                Tab(text: 'SIGN IN'),
                Tab(text: 'SIGN UP'),
              ],
              labelColor: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 15),
            Flexible(
              child: Form(
                key: _formKey,
                child: TabBarView(children: [
                  Container(
                    height: deviceSize.height * 0.4,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'E-Mail'),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          validator: (value) {
                            if (value.isEmpty ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                              return 'Invalid email!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['email'] = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                          validator: (value) {
                            if (value.isEmpty || value.length < 5) {
                              return 'Password is too short!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(fontSize: 18),
                                ),
                                onPressed: () => _submit('login'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 80.0, vertical: 10.0),
                                  primary: Theme.of(context).primaryColor,
                                ),
                              ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Username'),
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              onSaved: (value) {
                                _authData['name'] = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'E-Mail'),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              validator: (value) {
                                if (value.isEmpty ||
                                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                  return 'Invalid email!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _authData['email'] = value;
                              },
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              validator: (value) {
                                _password = value;
                                if (value.isEmpty || value.length < 5) {
                                  return 'Password is too short!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _authData['password'] = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Confirm Password'),
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () =>
                                  FocusScope.of(context).unfocus(),
                              validator: (value) {
                                if (value != _password) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                        _isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                child: Text(
                                  'SIGN UP',
                                  style: TextStyle(fontSize: 18),
                                ),
                                onPressed: () {
                                  _submit('register');
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 80.0, vertical: 10.0),
                                  primary: Theme.of(context).primaryColor,
                                ),
                              ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ));
  }
}
