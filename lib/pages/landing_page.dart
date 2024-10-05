import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_view_model_bloc.dart';
import 'home_page.dart';
import 'sign_pages/sign_in_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userModelBloc = context.watch<UserViewModelBloc>();

    if (userModelBloc.state is UserViewModelBusyState) {
      return const PopScope(
        canPop: false,
        child: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    } else {
      if (userModelBloc.user == null) {
        return const SignInPage();
      } else {
        return HomePage(user: userModelBloc.user!);
      }
    }
  }
}
