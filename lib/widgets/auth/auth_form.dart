import 'package:flutter/material.dart';

enum authMode {
  login,
  signUp,
}

class AuthForm extends StatefulWidget {
  final Future<bool> Function(String email, String username, String password,
      authMode mode, BuildContext ctx) submitData;

  AuthForm(this.submitData);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _emailFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  var _inputs = {'email': '', 'username': '', 'password': ''};
  var _authMode = authMode.login;
  var _isLoading = false;

  void _submit(String email, String username, String password) {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      widget
          .submitData(_inputs['email'].trim(), _inputs['username'].trim(),
              _inputs['password'].trim(), _authMode, context)
          .then((suc) {
        if (!suc) {
          setState(() {
            _isLoading = false;
          });
        }
      });
      FocusScope.of(context).unfocus();
      print(_inputs);
    }
  }

  void _switchAuthMode() {
    setState(() {
      if (_authMode == authMode.login) {
        _authMode = authMode.signUp;
      } else {
        _authMode = authMode.login;
        _usernameController.text = '';
      }
      Future.delayed(Duration(milliseconds: 50))
          .then((value) => _formKey.currentState.reset());
    });
  }

  @override
  void initState() {
    _emailFocusNode.addListener(() {
      setState(() {});
    });
    _usernameFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(() {});
    _usernameFocusNode.removeListener(() {});
    _passwordFocusNode.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(30),
        child: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 4 / 5,
          constraints: BoxConstraints(
            maxWidth: 350,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: _emailFocusNode.hasFocus
                            ? Theme.of(context).accentColor
                            : Colors.grey,
                      ),
                      border: Theme.of(context).inputDecorationTheme.border,
                    ),
                    validator: (input) {
                      if (input == '') {
                        return 'Please enter an email';
                      }
                      if (!input.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (input) {
                      _inputs['email'] = input;
                    },
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    height: _authMode == authMode.signUp ? 59 : 0,
                    child: _authMode == authMode.login
                        ? null
                        : TextFormField(
                            controller: _usernameController,
                            focusNode: _usernameFocusNode,
                            decoration: InputDecoration(
                              labelText: 'User Name',
                              labelStyle: TextStyle(
                                color: _usernameFocusNode.hasPrimaryFocus
                                    ? Theme.of(context).accentColor
                                    : Colors.grey,
                              ),
                              border:
                                  Theme.of(context).inputDecorationTheme.border,
                            ),
                            validator: _authMode == authMode.login
                                ? null
                                : (input) {
                                    if (input == '') {
                                      return 'Please enter a username';
                                    }
                                    return null;
                                  },
                            onSaved: _authMode == authMode.login
                                ? null
                                : (input) {
                                    _inputs['username'] = input;
                                  },
                          ),
                  ),
                  TextFormField(
                    focusNode: _passwordFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: _passwordFocusNode.hasFocus
                            ? Theme.of(context).accentColor
                            : Colors.grey,
                      ),
                      border: Theme.of(context).inputDecorationTheme.border,
                    ),
                    obscureText: true,
                    validator: (input) {
                      if (input == '') {
                        return 'Please enter a password';
                      }
                      if (input.length < 0) {
                        return 'Please enter a password with more than 7 characters';
                      }
                      return null;
                    },
                    onSaved: (input) {
                      _inputs['password'] = input;
                    },
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          child: Text(_authMode == authMode.signUp
                              ? 'Signup'
                              : 'Login'),
                          onPressed: () {
                            _submit(_inputs['email'], _inputs['username'],
                                _inputs['password']);
                          },
                        ),
                  FlatButton(
                    textColor: Theme.of(context).accentColor,
                    child: Text(_authMode == authMode.signUp
                        ? 'Login'
                        : 'Create New Acount'),
                    onPressed: _switchAuthMode,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
