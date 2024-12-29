import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_view_model_bloc.dart';
import 'consts/consts.dart';
import 'firebase_options.dart';
import 'locator.dart';
import 'pages/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.playIntegrity);

  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserViewModelBloc()..add(CurrentUserEvent()),
      child: MaterialApp(
        title: 'Chatrix',
        theme: ThemeData(
          primaryColor: Consts.primaryAppColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: Consts.backgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black87),
          ),
          scaffoldBackgroundColor: Consts.backgroundColor,
          dialogBackgroundColor: Consts.backgroundColor,
          buttonTheme: ButtonThemeData(
            buttonColor: Consts.primaryAppColor,
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Consts.primaryAppColor,
            selectionHandleColor: Consts.primaryAppColor,
            selectionColor: Colors.blue.withValues(alpha: 0.5),
          ),
        ),
        // theme: ThemeData(
        //   colorScheme: ColorScheme(
        //     primary: Colors.black87,
        //     secondary: Consts.secondaryAppColor,
        //     surface: Colors.white,
        //     error: Colors.red,
        //     onPrimary: Colors.red,
        //     onSecondary: Colors.deepOrange,
        //     onSurface: Colors.black87,
        //     onError: Colors.redAccent,
        //     brightness: Brightness.light,
        //   ),
        // ),
        debugShowCheckedModeBanner: false,
        home: const LandingPage(),
      ),
    );
  }
}
