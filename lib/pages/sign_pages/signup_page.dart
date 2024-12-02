import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/user_view_model_bloc.dart';
import '../../consts/consts.dart';
import '../../services/error_exception.dart';
import '../../widgets/error_page_widget.dart';
import '../../widgets/sign_page_button_widget.dart';
import '../../widgets/sign_page_input_widget.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? _email, _pass1, _pass2;
  String _initialEmail = Consts.initialEmail;
  String _initialPass = Consts.initialPass;

  @override
  void initState() {
    super.initState();
    _email = _initialEmail;
    _pass1 = _initialPass;
    _pass2 = _initialPass;
  }

  @override
  Widget build(BuildContext context) {
    final userViewModelBloc = context.watch<UserViewModelBloc>();
    checkUser(userViewModelBloc);

    if (userViewModelBloc.state is UserViewModelErrorState) {
      debugPrint('ERROR CODE: ${UserViewModelBloc.errorCode}');

      Map<String, dynamic> errorMap =
          ErrorException.getError(UserViewModelBloc.errorCode);

      showError(errorMap, userViewModelBloc);

      userViewModelBloc.add(ConvertErrorStateEvent());
    }

    if (userViewModelBloc.state is UserViewModelBusyState) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Consts.inactiveColor)));
    } else {
      if (userViewModelBloc.generalErrorMessage != null) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ErrorPageWidget(
                text: userViewModelBloc.generalErrorMessage!,
                iconData: FontAwesomeIcons.robot,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  userViewModelBloc.generalErrorMessage = null;
                  setState(() {});
                },
                child: Text(
                  'Try again',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            userViewModelBloc.emailErrorMessage = null;
            userViewModelBloc.passErrorMessage = null;
            userViewModelBloc.bothErrorMessage = null;
            userViewModelBloc.generalErrorMessage = null;
            _initialEmail = '';
            _initialPass = '';
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                height: MediaQuery.of(context).size.height - 50,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1200),
                          child: Text(
                            "Create an account, It's free",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FadeInUp(
                          duration: Duration(milliseconds: 1200),
                          child: SignPageInputWidget(
                            errorText: userViewModelBloc.emailErrorMessage,
                            label: 'Email',
                            initialValue: _initialEmail,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              _initialEmail = value;
                              _email = value;
                              userViewModelBloc.emailErrorMessage = null;
                              userViewModelBloc.bothErrorMessage = null;
                              setState(() {});
                            },
                          ),
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1300),
                          child: SignPageInputWidget(
                            label: "Password",
                            errorText: userViewModelBloc.passErrorMessage,
                            obscureText: true,
                            initialValue: _initialPass,
                            onChanged: (value) {
                              userViewModelBloc.passErrorMessage = null;
                              userViewModelBloc.bothErrorMessage = null;
                              _pass1 = value;
                            },
                          ),
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1400),
                          child: SignPageInputWidget(
                            errorText: userViewModelBloc.passErrorMessage,
                            label: "Confirm Password",
                            obscureText: true,
                            initialValue: _initialPass,
                            onChanged: (value) {
                              userViewModelBloc.passErrorMessage = null;
                              userViewModelBloc.bothErrorMessage = null;
                              _pass2 = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SignPageButtonWidget(
                          fadeDuration: 1500,
                          buttonText: 'Sign Up',
                          buttonColor: Consts.primaryAppColor,
                          onPressed: () {
                            if (_pass1 == _pass2) {
                              if (_email!.trim().isNotEmpty &&
                                  _pass1!.trim().isNotEmpty &&
                                  _pass2!.trim().isNotEmpty) {
                                userViewModelBloc.add(SignUpWithEmailEvent(
                                    email: _email!, pass: _pass1!));
                              }
                            } else {
                              userViewModelBloc.passErrorMessage =
                                  'Passwords must be equal!';
                              setState(() {});
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        FadeInUp(
                          duration: Duration(milliseconds: 1600),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account?"),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).popUntil(
                                    (route) => route.isFirst,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                child: Text(
                                  " Login",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
  }

  void checkUser(UserViewModelBloc userViewModelBloc) async {
    if (userViewModelBloc.user != null) {
      await Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      });
    }
  }

  void showError(
      Map<String, dynamic> errorMap, UserViewModelBloc userViewModelBloc) {
    switch (errorMap['errorType'] as ErrorType) {
      case ErrorType.email:
        userViewModelBloc.emailErrorMessage = errorMap['error'];
      case ErrorType.pass:
        userViewModelBloc.passErrorMessage = errorMap['error'];
      case ErrorType.both:
        userViewModelBloc.bothErrorMessage = errorMap['error'];
      case ErrorType.general:
        userViewModelBloc.generalErrorMessage = errorMap['error'];
    }
  }
}
