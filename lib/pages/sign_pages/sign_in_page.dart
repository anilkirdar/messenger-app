import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../bloc/user_view_model_bloc.dart';
import '../../widgets/social_login_button.dart';
import 'email_sign_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userModelBloc = context.watch<UserViewModelBloc>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'SignIn / SignUp',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
              ),
              const SizedBox(height: 20),
              SocialLoginButton(
                onPressed: () => userModelBloc.add(SignWithGoogleEvent()),
                buttonColor: Colors.white,
                buttonText: 'Sign with Google',
                buttonIcon: Image.asset('assets/images/google-logo.png'),
                buttonTextColor: Colors.black87,
              ),
              SocialLoginButton(
                onPressed: () {},
                buttonColor: const Color(0xFF334D92),
                buttonText: 'Sign with Facebook',
                buttonIcon: Image.asset('assets/images/facebook-logo.png'),
                buttonTextColor: Colors.white,
              ),
              SocialLoginButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const EmailSignPage(),
                    ),
                  );
                },
                buttonColor: Colors.blue,
                buttonText: 'Sign with Email',
                buttonIcon: const FaIcon(FontAwesomeIcons.solidEnvelope,
                    size: 30, color: Colors.white),
                buttonTextColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
