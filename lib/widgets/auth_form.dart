import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn);
  final void Function(
    String email,
    String password,
    String username,
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

  final _formKey = GlobalKey<
      FormState>(); //This is used to trigger the form members simultaneously.

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    //This is used to close the soft keyboard, which might be still open as soon as the form submitted.
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        //.trim() is used to remove the extra whitespace at the beginning and end of the user input to avoid the error.
        _userName.trim(),
        _userPassword.trim(),
        _isLogin,
        context,
      );
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
                  TextFormField(
                    key: ValueKey(
                        'Email'), //This key/identifier is allow flutter to uniquely identify an element, if it have similar elements next to each other.
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
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: _trySubmit,
                    child: Text(
                      _isLogin ? "Login" : "Signup",
                    ),
                  ),
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
