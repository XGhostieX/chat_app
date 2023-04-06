import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
    BuildContext context,
  ) submitAuthForm;
  final bool isLoading;

  const AuthForm({
    Key? key,
    required this.submitAuthForm,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _islogin = true;
  String _email = '';
  String _username = '';
  String _password = '';
  File? _userImage;

  void _pickedImage(File image) {
    _userImage = image;
  }

  void _submitForm() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImage == null && !_islogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please Pick an Image."),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitAuthForm(
        _email.trim(),
        _username.trim(),
        _password.trim(),
        _userImage!,
        _islogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_islogin) UserImagePicker(imageForm: _pickedImage),
                TextFormField(
                  key: const ValueKey("email"),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-Mail',
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return 'Please Enter a Valid E-Mail.';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) => _email = newValue!,
                ),
                if (!_islogin)
                  TextFormField(
                    key: const ValueKey("username"),
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Username Must be at least 4 Characters.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) => _username = newValue!,
                  ),
                TextFormField(
                  key: const ValueKey("password"),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password Must be at least 7 Characters.';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) => _password = newValue!,
                ),
                const SizedBox(height: 20),
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(_islogin ? "Log In" : "Sign Up"),
                  ),
                if (!widget.isLoading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _islogin = !_islogin;
                      });
                    },
                    child: Text(_islogin
                        ? "Create New Account"
                        : "aleardy Have an Account ?"),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
