import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/user_view_model_bloc.dart';
import '../consts/consts.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/profile_edit_page_input_widget.dart';
import '../widgets/sign_page_button_widget.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late ImagePicker _picker;
  XFile? _newPickedImage;
  late bool _isProfilePhotoChanged;
  late bool _isUserNameChanged;
  late Color _saveButtonColor;
  late Color _saveButtonTextColor;
  late String _userName;
  late TextEditingController _newPassController, _confirmPassController;
  late String? _userNameTextFieldError, _passTextFieldError;
  late FocusNode _focusNode1, _focusNode2, _focusNode3;

  @override
  void initState() {
    super.initState();
    _isUserNameChanged = false;
    _userName = '';
    _newPassController = TextEditingController();
    _confirmPassController = TextEditingController();
    _saveButtonColor = Consts.inactiveColor;
    _saveButtonTextColor = Colors.grey.shade400;
    _userNameTextFieldError = null;
    _passTextFieldError = null;
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
    _picker = ImagePicker();
    _isProfilePhotoChanged = false;
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModelBloc = context.read<UserViewModelBloc>();
    Size size = MediaQuery.of(context).size;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        _userNameTextFieldError = null;
        _passTextFieldError = null;
      },
      child: Scaffold(
        appBar: AppBar(
          // leading: Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: IconButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     icon: Icon(
          //       Icons.arrow_back_ios,
          //       color: Colors.black54,
          //     ),
          //   ),
          // ),
          centerTitle: true,
          title: const Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage: _newPickedImage != null
                                ? FileImage(File(_newPickedImage!.path))
                                : NetworkImage(
                                    userViewModelBloc.user!.profilePhotoURL!),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: const FaIcon(
                                            FontAwesomeIcons.camera),
                                        title: const Text('Take a photo'),
                                        onTap: () async {
                                          await pickImageFromCamera().then(
                                            (value) {
                                              if (_isProfilePhotoChanged) {
                                                _saveButtonColor =
                                                    Consts.primaryAppColor;
                                                _saveButtonTextColor =
                                                    Colors.black;
                                              } else {
                                                _saveButtonColor =
                                                    Consts.inactiveColor;
                                                _saveButtonTextColor =
                                                    Colors.grey.shade400;
                                              }
                                              setState(() {});
                                            },
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const FaIcon(
                                            FontAwesomeIcons.image),
                                        title:
                                            const Text('Choose from gallery'),
                                        onTap: () async {
                                          await pickImageFromGallery().then(
                                            (value) {
                                              if (_isProfilePhotoChanged) {
                                                _saveButtonColor =
                                                    Consts.primaryAppColor;
                                                _saveButtonTextColor =
                                                    Colors.black;
                                              } else {
                                                _saveButtonColor =
                                                    Consts.inactiveColor;
                                                _saveButtonTextColor =
                                                    Colors.grey.shade400;
                                              }
                                              setState(() {});
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: Consts.primaryAppColor,
                            child: FaIcon(
                              FontAwesomeIcons.pencil,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Edit your profile',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: Column(
                      children: [
                        ProfilePageInputWidget(
                          errorText: _userNameTextFieldError,
                          initialValue: userViewModelBloc.user!.userName,
                          labelText: 'Username',
                          focusNode: _focusNode1,
                          onChanged: (value) {
                            _userName = value;

                            if (value.trim().isEmpty) {
                              _userNameTextFieldError =
                                  'You can not leave empty this field!';
                            } else {
                              _userNameTextFieldError = null;
                              if (value == userViewModelBloc.user!.userName) {
                                _isUserNameChanged = false;
                              } else {
                                _isUserNameChanged = true;
                              }
                            }

                            if (_newPassController.text.isNotEmpty ||
                                _confirmPassController.text.isNotEmpty ||
                                _isUserNameChanged) {
                              _saveButtonColor = Consts.primaryAppColor;
                              _saveButtonTextColor = Colors.black;
                            } else {
                              _saveButtonColor = Consts.inactiveColor;
                              _saveButtonTextColor = Colors.grey.shade400;
                            }
                            setState(() {});
                          },
                          prefixIcon: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: FaIcon(
                                FontAwesomeIcons.solidUser,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ProfilePageInputWidget(
                          fillColor:
                              CupertinoColors.inactiveGray.withOpacity(0.5),
                          readOnly: true,
                          initialValue: userViewModelBloc.user!.email,
                          labelText: '',
                          prefixIcon: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: FaIcon(
                                FontAwesomeIcons.solidEnvelope,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ProfilePageInputWidget(
                          controller: _newPassController,
                          focusNode: _focusNode2,
                          errorText: _passTextFieldError,
                          onChanged: (value) {
                            _passTextFieldError = null;
                            _newPassController.text = value;
                            if (_newPassController.text.isNotEmpty ||
                                _confirmPassController.text.isNotEmpty ||
                                _isUserNameChanged) {
                              _saveButtonColor = Consts.primaryAppColor;
                              _saveButtonTextColor = Colors.black;
                            } else {
                              _saveButtonColor = Consts.inactiveColor;
                              _saveButtonTextColor = Colors.grey.shade400;
                            }
                            setState(() {});
                          },
                          labelText: 'New Password',
                          obscureText: true,
                          prefixIcon: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: FaIcon(
                                FontAwesomeIcons.lock,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ProfilePageInputWidget(
                          focusNode: _focusNode3,
                          controller: _confirmPassController,
                          errorText: _passTextFieldError,
                          onChanged: (value) {
                            _passTextFieldError = null;
                            _confirmPassController.text = value;
                            if (_newPassController.text.isNotEmpty ||
                                _confirmPassController.text.isNotEmpty ||
                                _isUserNameChanged) {
                              _saveButtonColor = Consts.primaryAppColor;
                              _saveButtonTextColor = Colors.black;
                            } else {
                              _saveButtonColor = Consts.inactiveColor;
                              _saveButtonTextColor = Colors.grey.shade400;
                            }
                            setState(() {});
                          },
                          labelText: 'Confirm Password',
                          obscureText: true,
                          prefixIcon: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: FaIcon(
                                FontAwesomeIcons.lock,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SignPageButtonWidget(
                    extraHorizontalPadding: 50,
                    hasBorder: false,
                    buttonText: 'Save Changes',
                    buttonColor: _saveButtonColor,
                    buttonTextColor: _saveButtonTextColor,
                    onPressed: updateUserInformation,
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text('Joined'),
                            Text(
                              ' ${_dateTimeFormatter(userViewModelBloc.user!.createdAt!)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              makeApproveForDeleteUser(userViewModelBloc),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade100,
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void makeApproveForDeleteUser(UserViewModelBloc userViewModelBloc) async {
    final bool? result = await const AlertDialogWidget(
      content: 'Are you sure for delete account?',
      mainButtonTextColor: Colors.red,
      mainButtonText: 'Delete',
      cancelButtonText: 'Cancel',
    ).showAlertDialog(context);

    if (result!) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade600,
          content: Text(
            'User successfully deleted!',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

      userViewModelBloc
          .add(DeleteUserEvent(currentUser: userViewModelBloc.user!));
      // ignore: use_build_context_synchronously
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  String _dateTimeFormatter(Timestamp timestamp) {
    DateTime time = timestamp.toDate();

    return '${time.day} ${getMonthName(monthNumber: time.month)} ${time.year}';
  }

  String getMonthName({required int monthNumber}) {
    switch (monthNumber) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'January';

      default:
        return 'January';
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);

    _newPickedImage = pickedImage;
    if (pickedImage != null) {
      _isProfilePhotoChanged = true;
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> pickImageFromGallery() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    _newPickedImage = pickedImage;
    if (pickedImage != null) {
      _isProfilePhotoChanged = true;
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void updateUserInformation() async {
    final userViewModelBloc = context.read<UserViewModelBloc>();

    if (_isUserNameChanged ||
        _isProfilePhotoChanged ||
        _newPassController.text.trim().isNotEmpty ||
        _confirmPassController.text.trim().isNotEmpty) {
      if (_isUserNameChanged) {
        if (_userName.trim().isNotEmpty) {
          userViewModelBloc.add(UpdateUserNameEvent(
            userID: userViewModelBloc.user!.userID,
            newUserName: _userName.trim(),
            resultCallBack: (result) {
              if (!result) {
                _userNameTextFieldError = "This username already taken!";
              } else {
                _isUserNameChanged = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Consts.tertiaryAppColor,
                    content: Text(
                      'Username successfully changed!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
            },
          ));
        }
      }
      if (_isProfilePhotoChanged) {
        userViewModelBloc.add(
          UpdateUserProfilePhotoEvent(
            userID: userViewModelBloc.user!.userID,
            fileType: 'profile-photo',
            newProfilePhoto: _newPickedImage,
          ),
        );
        _isProfilePhotoChanged = false;
      }
      if (_newPassController.text == _confirmPassController.text) {
        if (_newPassController.text.trim().isNotEmpty ||
            _confirmPassController.text.trim().isNotEmpty) {
          _passTextFieldError = null;
          userViewModelBloc.add(
            UpdateUserPassEvent(
              userID: userViewModelBloc.user!.userID,
              newPass: _newPassController.text.trim(),
            ),
          );
          _newPassController.clear();
          _confirmPassController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Consts.tertiaryAppColor,
              content: Text(
                'Password successfully changed!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      } else {
        _passTextFieldError = 'Passwords must be equal!';
      }

      _saveButtonColor = Consts.inactiveColor;
      _saveButtonTextColor = Colors.grey.shade400;
      _focusNode1.unfocus();
      _focusNode2.unfocus();
      _focusNode3.unfocus();

      setState(() {});
    } else {
      await const AlertDialogWidget(
        content: "You haven't made any changes!",
        mainButtonText: 'Done',
        mainButtonTextColor: Colors.black,
      ).showAlertDialog(context);
    }
  }
}
