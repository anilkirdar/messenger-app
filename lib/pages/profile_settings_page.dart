import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/user_view_model_bloc.dart';
import '../consts/consts.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/profile_page_button_widget.dart';
import '../widgets/sign_page_button_widget.dart';
import 'profile_edit_page.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late bool textFieldIsChanged;
  late Color saveButtonColor;
  late Color saveButtonTextColor;
  late String _userName;
  late String? textFieldError;
  late FocusNode _focusNode;
  late final ImagePicker picker;
  late bool profilePhotoIsChanged;
  XFile? newProfilePhoto;

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
      Navigator.of(context).pop(true);
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
    final userViewModelBloc = context.read<UserViewModelBloc>();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  FadeInUp(
                    duration: Duration(milliseconds: 1200),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage: newProfilePhoto != null
                                ? FileImage(File(newProfilePhoto!.path))
                                : CachedNetworkImageProvider(
                                    userViewModelBloc.user!.profilePhotoURL!),
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            Text(
                              userViewModelBloc.user!.userName!,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userViewModelBloc.user!.email,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        SignPageButtonWidget(
                          extraHorizontalPadding: 50,
                          hasBorder: false,
                          buttonText: 'Edit Profile',
                          buttonColor: Consts.primaryAppColor,
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(
                              CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => ProfileEditPage(),
                              ),
                            )
                                .then(
                              (value) {
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1300),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(right: 25, left: 25, top: 25),
                          child: Divider(
                            height: 50,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              ProfilePageButtonWidget(
                                buttonText: 'Settings',
                                iconData: FontAwesomeIcons.gear,
                                onPressed: () {},
                              ),
                              ProfilePageButtonWidget(
                                buttonText: 'Billing Details',
                                iconData: FontAwesomeIcons.wallet,
                                onPressed: () {},
                              ),
                              ProfilePageButtonWidget(
                                buttonText: 'User Management',
                                iconData: FontAwesomeIcons.solidUser,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1400),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Divider(
                            height: 50,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              ProfilePageButtonWidget(
                                buttonText: 'Information',
                                iconData: FontAwesomeIcons.info,
                                onPressed: () {},
                              ),
                              ProfilePageButtonWidget(
                                onPressed: () =>
                                    makeApproveForSignOut(userViewModelBloc),
                                buttonText: 'Log out',
                                iconColor: Colors.red,
                                textColor: Colors.red,
                                iconData: FontAwesomeIcons.rightFromBracket,
                                hasTrailing: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8),
                  //   child: TextFormField(
                  //     readOnly: true,
                  //     initialValue: userViewModelBloc.user!.email,
                  //     canRequestFocus: false,
                  //     decoration: const InputDecoration(
                  //       filled: true,
                  //       fillColor: Colors.black26,
                  //       hintText: 'example@example.com',
                  //       labelText: 'Email',
                  //       border: OutlineInputBorder(),
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8),
                  //   child: TextFormField(
                  //     initialValue: userViewModelBloc.user!.userName,
                  //     focusNode: _focusNode,
                  //     onChanged: (value) {
                  //       _userName = value;
                  //       setState(() {
                  //         if (value.trim().isEmpty) {
                  //           textFieldError =
                  //               'You can not leave empty this field!';
                  //         } else {
                  //           textFieldError = null;
                  //           if (value == userViewModelBloc.user!.userName) {
                  //             textFieldIsChanged = false;
                  //           } else {
                  //             textFieldIsChanged = true;
                  //           }
                  //         }
                  //       });
                  //     },
                  //     decoration: InputDecoration(
                  //       errorText: textFieldError,
                  //       hintText: 'username123',
                  //       labelText: 'Username',
                  //       border: const OutlineInputBorder(),
                  //     ),
                  //   ),
                  // ),
                  // ElevatedButton(
                  //   onPressed: textFieldIsChanged || profilePhotoIsChanged
                  //       ? () => updateUserInformation(context, userViewModelBloc)
                  //       : null,
                  //   style: ElevatedButton.styleFrom(
                  //       backgroundColor: saveButtonColor),
                  //   child: Text(
                  //     'Save',
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       color: saveButtonTextColor,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void makeApproveForSignOut(UserViewModelBloc userViewModelBloc) async {
    final bool? result = await const AlertDialogWidget(
      content: 'Log out of your account?',
      mainButtonTextColor: Colors.red,
      mainButtonText: 'Log out',
      cancelButtonText: 'Cancel',
    ).showAlertDialog(context);

    if (result!) {
      userViewModelBloc.add(SignOutEvent());
      // ignore: use_build_context_synchronously
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void updateUserInformation(UserViewModelBloc userViewModelBloc) async {
    if (textFieldIsChanged || profilePhotoIsChanged) {
      if (textFieldIsChanged) {
        if (_userName.trim().isNotEmpty) {
          _focusNode.unfocus();
          userViewModelBloc.add(UpdateUserNameEvent(
            userID: userViewModelBloc.user!.userID,
            newUserName: _userName.trim(),
            resultCallBack: (result) {
              if (!result) {
                setState(() {
                  textFieldError = "This username already taken!";
                });
              } else {
                textFieldIsChanged = false;
                setState(() {});
              }
            },
          ));
        }
      }

      if (profilePhotoIsChanged) {
        userViewModelBloc.add(
          UpdateUserProfilePhotoEvent(
            userID: userViewModelBloc.user!.userID,
            newProfilePhoto: newProfilePhoto,
          ),
        );
        profilePhotoIsChanged = false;
        setState(() {});
      }
    } else {
      await const AlertDialogWidget(
        content: "You haven't made any changes!",
        mainButtonText: 'Done',
        mainButtonTextColor: Colors.black,
      ).showAlertDialog(context);
    }
  }
}
