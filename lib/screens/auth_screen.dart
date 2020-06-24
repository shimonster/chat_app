import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  Future<bool> _submitForm(String email, String username, String password,
      File image, authMode mode, BuildContext ctx) async {
    AuthResult authResult;
    try {
      if (mode == authMode.login) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images/${authResult.user.uid + '.jpg'}');
        await ref.putFile(image).onComplete;
        final imageUrl = await ref.getDownloadURL();
        await Firestore()
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'url': imageUrl,
        });
      }
      return true;
    } on PlatformException catch (error) {
      var message = 'Something went wrong while trying to log you in.';
      if (error != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    } catch (error) {
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Oops! Something went wrong'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitForm),
    );
  }
}
