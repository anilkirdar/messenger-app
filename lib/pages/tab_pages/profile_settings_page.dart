import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/user_view_model_bloc.dart';
import '../../consts/consts.dart';
import '../../widgets/alert_dialog_widget.dart';
import '../../widgets/profile_page_button_widget.dart';
import '../../widgets/sign_page_button_widget.dart';
import '../profile_edit_page.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final userViewModelBloc = context.read<UserViewModelBloc>();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInUp(
                duration: Duration(milliseconds: 1100),
                child: Text(
                  'Settings',
                  style: Consts.titleTextStyle,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
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
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              userViewModelBloc
                                                  .user!.profilePhotoURL!),
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
                                          builder: (context) =>
                                              ProfileEditPage(),
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
                                    padding: EdgeInsets.only(
                                        right: 25, left: 25, top: 25),
                                    child: Divider(
                                      height: 50,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25),
                                    child: Divider(
                                      height: 50,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    child: Column(
                                      children: [
                                        ProfilePageButtonWidget(
                                          buttonText: 'Information',
                                          iconData: FontAwesomeIcons.info,
                                          onPressed: () {},
                                        ),
                                        ProfilePageButtonWidget(
                                          onPressed: () =>
                                              makeApproveForSignOut(
                                                  userViewModelBloc),
                                          buttonText: 'Log out',
                                          iconColor: Colors.red,
                                          textColor: Colors.red,
                                          iconData:
                                              FontAwesomeIcons.rightFromBracket,
                                          hasTrailing: false,
                                        ),
                                      ],
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
              ),
            ],
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
}
