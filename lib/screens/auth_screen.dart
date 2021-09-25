import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;
  Future<void> _submitAuthForm(
    String email,
    String password,
    String username,
    File? image,
    bool isLogin,
    BuildContext context,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        //login
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        print(email);
      } else {
        //signup
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //image upload to firebase
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user!.uid + '.jpg');

        await ref.putFile(image!);
        final imageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'imageUrl': imageUrl,
        });
        //here we use .doc(authResult.user!.uid), for use the existing user ID (generate during sign-up) as our ID in this user collection.
        //if we use .add() instead of .doc(), the user id will generate dynamically.
      }
    } on PlatformException catch (error) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An error occurred, please check your credentials!';
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print("**ERROR**");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$error"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
