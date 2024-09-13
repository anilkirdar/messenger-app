import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
  late String _userName;
  late String? textFieldError;
  late FocusNode _focusNode;
  late final ImagePicker picker;
  XFile? newProfilePhoto;
  late bool profilePhotoIsChanged;

  @override
  void initState() {
    super.initState();
    textFieldIsChanged = false;
    saveButtonColor = Colors.purple.shade500;
    saveButtonTextColor = Colors.white;
    _userName = '';
    textFieldError = null;
    _focusNode = FocusNode();
    picker = ImagePicker();
    profilePhotoIsChanged = false;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void pickImageFromCamera() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.camera);
    setState(() {
      newProfilePhoto = pickedImage;
      profilePhotoIsChanged = true;
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void pickImageFromGallery() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      newProfilePhoto = pickedImage;
      profilePhotoIsChanged = true;
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModelBloc = context.read<UserViewModelBloc>();
    debugPrint('PROFILE PHOTO URL: ${userModelBloc.user!.profilePhotoURL}');

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
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height / 5,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera),
                                  title: const Text('Take a photo'),
                                  onTap: pickImageFromCamera,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  title: const Text('Choose from gallery'),
                                  onTap: pickImageFromGallery,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: newProfilePhoto != null
                          ? FileImage(File(newProfilePhoto!.path))
                          : NetworkImage(userModelBloc.user!.profilePhotoURL!),
                    ),
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
                    focusNode: _focusNode,
                    onChanged: (value) {
                      _userName = value;
                      setState(() {
                        if (value.isEmpty) {
                          textFieldError =
                              'You can not leave empty this field!';
                        } else {
                          textFieldError = null;
                          if (value == userModelBloc.user!.userName) {
                            textFieldIsChanged = false;
                          } else {
                            textFieldIsChanged = true;
                          }
                        }
                      });
                    },
                    decoration: InputDecoration(
                      errorText: textFieldError,
                      hintText: 'username123',
                      labelText: 'Username',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: textFieldIsChanged || profilePhotoIsChanged
                      ? () => updateUserInformation(context, userModelBloc)
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: saveButtonColor),
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

  void makeApproveForSignOut(
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

  void updateUserInformation(
      BuildContext context, UserViewModelBloc userModelBloc) async {
    if (textFieldIsChanged || profilePhotoIsChanged) {
      if (textFieldIsChanged) {
        if (_userName.isNotEmpty) {
          _focusNode.unfocus();
          userModelBloc.add(UpdateUserNameEvent(
            userID: userModelBloc.user!.userID,
            newUserName: _userName,
            resultCallBack: (result) async {
              if (!result) {
                await const PlatformSensitiveAlertDialog(
                  title: 'Alert',
                  content: "This username already taken!",
                  mainButtonText: 'Done',
                ).showAlertDialog(context);
              } else {
                textFieldIsChanged = false;
                setState(() {});
              }
            },
          ));
        } else {
          await const PlatformSensitiveAlertDialog(
            title: 'Alert',
            content: "You can not leave empty username field!",
            mainButtonText: 'Done',
          ).showAlertDialog(context);
        }
      }

      if (profilePhotoIsChanged) {
        userModelBloc.add(
          UpdateUserProfilePhotoEvent(
            userID: userModelBloc.user!.userID,
            fileType: 'profile-photo',
            newProfilePhoto: newProfilePhoto,
          ),
        );
        profilePhotoIsChanged = false;
        setState(() {});
      }
    } else {
      await const PlatformSensitiveAlertDialog(
        title: 'Alert',
        content: "You haven't made any changes!",
        mainButtonText: 'Done',
      ).showAlertDialog(context);
    }
  }
}
