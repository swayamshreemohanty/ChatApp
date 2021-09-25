import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chat_app/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading);
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File? image,
    bool isLogin,
    BuildContext context,
  ) submitFn;
  //This context actually has access to the surrounding scaffold, which in turn is the context where the
  //snack bar shoud be mounted on, because authscreen "context" doesn't have access to the scaffold,because this
  //scaffold in the auth_screen.dart is rendered by the AuthScreen. but the context of the auth screen in one level
  //above that. So in order to have access to this scaffold on which the snackbar should be rendered, we have to dive
  //into a widget which is inside that scaffold and the "context" of that which it is then the right one.

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImageFile;

  final _formKey = GlobalKey<FormState>();
  //This is used to trigger the form members simultaneously.

  void _pickedImage(File image) {
    _userImageFile = image;
    //this Function is used to get the image data from user_image_picker.dart
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    //This is used to close the soft keyboard, which might be still open as soon as the form submitted.
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please pick an Image"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
      //.trim() is used to remove the extra whitespace at the beginning and end of the user input to avoid the error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey, //Used to trigger the form simultaneously.
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    UserImagePicker(
                        _pickedImage), //here we pass the pointer of _pickedImage
                  TextFormField(
                    key: ValueKey(
                        'Email'), //This key/identifier is allow flutter to uniquely identify an element, if it have similar elements next to each other.
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      //This is used to validate the user input
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                      //The validator return null when the user input have no error.
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      //This onSaved function is only run after all the validator returns null.
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('User Name'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        //This is used to validate the user input
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter atleast 4 characters.';
                        }
                        return null;
                        //The validator return null when the user input have no error.
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'User name',
                      ),
                      onSaved: (value) {
                        //This onSaved function is only run after all the validator returns null.
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('Password'),
                    validator: (value) {
                      //This is used to validate the user input
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                      //The validator return null when the user input have no error.
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      //This onSaved function is only run after all the validator returns null.
                      _userPassword = value!;
                    },
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? "Login" : "Signup"),
                    ),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? "Create new account"
                            : "I already have an account",
                      ),
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
