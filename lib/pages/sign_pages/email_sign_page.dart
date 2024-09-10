import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/user_view_model_bloc.dart';
import '../../services/error_exception.dart';
import '../../widgets/platform_sensitive_alert_dialog.dart';
import '../../widgets/social_login_button.dart';

class EmailSignPage extends StatefulWidget {
  static String? errorCode;
  const EmailSignPage({super.key});

  @override
  State<EmailSignPage> createState() => _EmailSignPageState();
}

enum FormType { signup, signin }

class _EmailSignPageState extends State<EmailSignPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String? _email, _pass;
  FormType _formType = FormType.signin;
  String buttonText = 'SignIn';
  String bottomText = "Let's Sign Up";
  String initialEmail = 'anil@gmail.com';
  String initialPass = '123456';

  @override
  Widget build(BuildContext context) {
    final userModelBloc = context.watch<UserViewModelBloc>();
    checkUser(userModelBloc);

    if (userModelBloc.state is UserViewModelError) {
      debugPrint('ERROR CODE: ${EmailSignPage.errorCode}');
      String errorMessage = ErrorException.showError(EmailSignPage.errorCode);

      showTheDialog(errorMessage);
    }

    if (userModelBloc.state is UserViewModelBusy) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('Email Sign Page')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: initialEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      errorText: userModelBloc.emailErrorMessage,
                      prefixIcon: const Icon(Icons.mail),
                      hintText: 'Email',
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                    ),
                    onSaved: (newValue) {
                      _email = newValue;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: initialPass,
                    obscureText: true,
                    decoration: InputDecoration(
                      errorText: userModelBloc.passErrorMessage,
                      prefixIcon: const Icon(Icons.password),
                      hintText: 'Password',
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                    ),
                    onSaved: (newValue) {
                      _pass = newValue;
                    },
                  ),
                  const SizedBox(height: 8),
                  SocialLoginButton(
                    buttonText:
                        _formType == FormType.signin ? 'SignIn' : 'SignUp',
                    buttonColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      _formKey.currentState!.save();

                      if (_email!.isNotEmpty && _pass!.isNotEmpty) {
                        if (_formType == FormType.signin) {
                          userModelBloc.add(SignInWithEmailEvent(
                              email: _email!, pass: _pass!));
                        } else {
                          userModelBloc.add(SignUpWithEmailEvent(
                              email: _email!, pass: _pass!));
                        }
                      }
                    },
                    buttonTextColor: Colors.white,
                    radius: 10,
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _formType = _formType == FormType.signin
                            ? FormType.signup
                            : FormType.signin;
                      });
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _formType == FormType.signin
                            ? "Let's Sign Up"
                            : "Let's Sign In",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  void checkUser(UserViewModelBloc userModelBloc) async {
    if (userModelBloc.user != null) {
      await Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          // ignore: use_build_context_synchronously
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      });
    }
  }

  void showTheDialog(String errorMessage) async {
    await Future.delayed(const Duration(milliseconds: 200), () async {
      if (mounted) {
        await PlatformSensitiveAlertDialog(
          title: 'Error occurred while sign',
          content: errorMessage,
          mainButtonText: 'Done',
        ).showAlertDialog(context);
      }
    });
  }
}
