import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_view_model_bloc.dart';
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
        //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
        //     selectedItemColor: Consts.primaryAppColor,
        //   ),
        // ),
        debugShowCheckedModeBanner: false,
        home: const LandingPage(),
      ),
    );
  }
}
