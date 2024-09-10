import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/user_view_model_bloc.dart';
import '../../widgets/platform_sensitive_alert_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool textFieldIsChanged;
  late Color saveButtonColor;
  late Color saveButtonTextColor;
  late String userName;

  @override
  void initState() {
    super.initState();
    textFieldIsChanged = false;
    saveButtonColor = Colors.purple.shade200;
    saveButtonTextColor = Colors.black38;
    userName = '';
  }

  @override
  Widget build(BuildContext context) {
    final userModelBloc = context.read<UserViewModelBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                makeApproveForSignOut(context, userModelBloc);
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.black, // profile icon
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: userModelBloc.user!.email,
                    canRequestFocus: false,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.black26,
                      hintText: 'example@example.com',
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    initialValue: userModelBloc.user!.userName,
                    onChanged: (value) {
                      userName = value;
                      setState(() {
                        if (value == userModelBloc.user!.userName) {
                          textFieldIsChanged = false;
                        } else {
                          textFieldIsChanged = true;
                        }
            
                        saveButtonColor = textFieldIsChanged
                            ? Colors.purple.shade500
                            : Colors.purple.shade200;
                        saveButtonTextColor =
                            textFieldIsChanged ? Colors.white : Colors.white54;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'username123',
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style:
                      ElevatedButton.styleFrom(backgroundColor: saveButtonColor),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: saveButtonTextColor,
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

  makeApproveForSignOut(
      BuildContext context, UserViewModelBloc userModelBloc) async {
    final bool? result = await const PlatformSensitiveAlertDialog(
      title: 'Sign Out',
      content: 'Are you sure?',
      mainButtonText: 'Approve',
      cancelButtonText: 'Reject',
    ).showAlertDialog(context);

    if (result!) {
      userModelBloc.add(SignOutEvent());
    }
  }
}
