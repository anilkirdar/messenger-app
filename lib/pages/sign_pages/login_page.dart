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
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _email, _pass;
  String _initialEmail = Consts.initialEmail;
  String _initialPass = Consts.initialPass;

  @override
  void initState() {
    super.initState();
    _email = _initialEmail;
    _pass = _initialPass;
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
      if (userViewModelBloc.state is UserViewModelBusyState) {
        return const Scaffold(body: Center(child: CircularProgressIndicator(color: Consts.inactiveColor)));
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
            resizeToAvoidBottomInset: false,
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
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FadeInUp(
                              duration: Duration(milliseconds: 1000),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 20),
                            FadeInUp(
                              duration: Duration(milliseconds: 1200),
                              child: Text(
                                "Login to your account",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: <Widget>[
                              FadeInUp(
                                duration: Duration(milliseconds: 1200),
                                child: SignPageInputWidget(
                                  label: 'Email',
                                  initialValue: _initialEmail,
                                  errorText:
                                      userViewModelBloc.emailErrorMessage,
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
                                  obscureText: true,
                                  errorText: userViewModelBloc.passErrorMessage,
                                  initialValue: _initialPass,
                                  onChanged: (value) {
                                    userViewModelBloc.passErrorMessage = null;
                                    userViewModelBloc.bothErrorMessage = null;
                                    _pass = value;
                                  },
                                ),
                              ),
                              if (userViewModelBloc.bothErrorMessage != null)
                                FadeInUp(
                                  duration: Duration(milliseconds: 1400),
                                  child: Text(
                                    userViewModelBloc.bothErrorMessage!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SignPageButtonWidget(
                          fadeDuration: 1400,
                          buttonText: 'Login',
                          buttonColor: Consts.secondaryAppColor,
                          extraHorizontalPadding: 40,
                          onPressed: () {
                            if (_email!.trim().isNotEmpty &&
                                _pass!.trim().isNotEmpty) {
                              userViewModelBloc.add(SignInWithEmailEvent(
                                  email: _email!, pass: _pass!));
                            }
                          },
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't have an account?"),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).popUntil(
                                    (route) => route.isFirst,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage()),
                                  );
                                },
                                child: Text(
                                  " Sign up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1200),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
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
