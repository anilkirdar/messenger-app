import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/user_view_model_bloc.dart';
import '../../consts/consts.dart';
import '../../widgets/sign_page_button_widget.dart';
import 'login_page.dart';
import 'signup_page.dart';

class SignPage extends StatelessWidget {
  const SignPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModelBloc = context.read<UserViewModelBloc>();

    return Scaffold(
      backgroundColor: Consts.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "Welcome",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    SizedBox(height: 10),
                    FadeInUp(
                      duration: Duration(milliseconds: 1200),
                      child: Text(
                        "Automatic identity verification which enables you to verify your identity",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700], fontSize: 15),
                      ),
                    ),
                  ],
                ),
                FadeInUp(
                  duration: Duration(milliseconds: 1400),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/sign-page-illustration.png'),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SignPageButtonWidget(
                      fadeDuration: 1500,
                      buttonText: 'Login',
                      buttonColor: Consts.primaryAppColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    SignPageButtonWidget(
                      fadeDuration: 1600,
                      buttonText: 'Sign up',
                      buttonColor: Consts.secondaryAppColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    SignPageButtonWidget(
                      fadeDuration: 1700,
                      buttonText: 'Sign with Google',
                      buttonColor: Colors.white,
                      buttonIcon: Image.asset('assets/images/google-logo.png'),
                      onPressed: () =>
                          userViewModelBloc.add(SignWithGoogleEvent()),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
