import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/user_view_model_bloc.dart';
import '../consts/consts.dart';
import '../widgets/error_page_widget.dart';
import 'sign_pages/sign_page.dart';
import 'tabs_base_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<ConnectivityResult>? connectivityResult;
  bool? hasInternetConnection;
  late StreamSubscription<List<ConnectivityResult>> connectionSubscription;

  @override
  void initState() {
    super.initState();
    connectionSubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      connectivityResult = result;
      checkConnection();
    });
  }

  @override
  dispose() {
    connectionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModelBloc = context.watch<UserViewModelBloc>();

    if (hasInternetConnection != null) {
      if (hasInternetConnection!) {
        if (userModelBloc.state is UserViewModelBusyState) {
          return const PopScope(
            canPop: false,
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Consts.inactiveColor),
              ),
            ),
          );
        } else {
          if (userModelBloc.user == null) {
            return const SignPage();
          } else {
            return TabsBasePage(user: userModelBloc.user!);
          }
        }
      } else {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ErrorPageWidget(
                  text: 'An internet error occurred!',
                  iconData: FontAwesomeIcons.robot,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: checkConnection,
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
          ),
        );
      }
    } else {
      return Scaffold(body: Center(child: CircularProgressIndicator(color: Consts.inactiveColor)));
    }
  }

  void checkConnection() async {
    if (connectivityResult != null) {
      if (connectivityResult!.contains(ConnectivityResult.none)) {
        hasInternetConnection = false;
      } else {
        hasInternetConnection = true;
      }
      setState(() {});
    }
  }
}
