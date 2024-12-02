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
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Consts.primaryAppColor,
            selectionHandleColor: Consts.primaryAppColor,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const LandingPage(),
      ),
    );
  }
}
