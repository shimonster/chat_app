import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum authMode {
  login,
  signUp,
}

class AuthForm extends StatefulWidget {
  final Future<bool> Function(String email, String username, String password,
      File image, authMode mode, BuildContext ctx) submitData;

  AuthForm(this.submitData);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _emailFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  var _inputs = {'email': '', 'username': '', 'password': ''};
  var _authMode = authMode.login;
  var _isLoading = false;
  File _image;
  AnimationController _animationController;
  Animation _moveAnimation;

  Future<void> _pickImage() async {
    final _imagePicker = ImagePicker();
    final image = await _imagePicker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _image = File(image.path);
    });
  }

  void _submit(String email, String username, String password) {
    if (_image == null && _authMode != authMode.login) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Select an Image'),
        ),
      );
      return;
    }
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      widget
          .submitData(_inputs['email'].trim(), _inputs['username'].trim(),
              _inputs['password'].trim(), _image, _authMode, context)
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
        _animationController.forward();
      } else {
        _authMode = authMode.login;
        _usernameController.text = '';
        _animationController.reverse();
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
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    _moveAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
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
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      child: SizeTransition(
                        sizeFactor: _moveAnimation,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: InkWell(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Theme.of(context).accentColor,
                              child: _image == null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          const Icon(
                                            Icons.image,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                          const Text(
                                            'Click to pick image',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                      width: 200,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                    SizeTransition(
                      sizeFactor: _moveAnimation,
                      child: TextFormField(
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        decoration: InputDecoration(
                          labelText: 'User Name',
                          labelStyle: TextStyle(
                            color: _usernameFocusNode.hasPrimaryFocus
                                ? Theme.of(context).accentColor
                                : Colors.grey,
                          ),
                          border: Theme.of(context).inputDecorationTheme.border,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
