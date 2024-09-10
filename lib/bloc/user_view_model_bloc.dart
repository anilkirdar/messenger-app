// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../models/user_model.dart';
import '../../repository/user_repository.dart';

part 'user_view_model_event.dart';
part 'user_view_model_state.dart';

class UserViewModelBloc extends Bloc<UserViewModelEvent, UserViewModelState> {
  final UserRepository _userRepository = locator<UserRepository>();
  UserModel? user;
  String? emailErrorMessage;
  String? passErrorMessage;

  UserViewModelBloc() : super(UserViewModelIdle()) {
    bool checkUserEmailAndPassword(
        {required String email, required String pass}) {
      bool result = true;

      if (!email.contains('@')) {
        emailErrorMessage = 'Your email must contain "@".';
        result = false;
      } else {
        emailErrorMessage = null;
        result = true;
      }

      if (pass.length < 6) {
        passErrorMessage = 'Your password must be at least 6 character.';
        result = false;
      } else {
        passErrorMessage = null;
        result = true;
      }

      return result;
    }

    on<CurrentUserEvent>((event, emit) async {
      try {
        emit(UserViewModelBusy());
        user = await _userRepository.currentUser();
        emit(UserViewModelIdle());
      } catch (e) {
        emit(UserViewModelError());
      }
    });

    on<SignAnonymouslyEvent>((event, emit) async {
      try {
        emit(UserViewModelBusy());
        user = await _userRepository.signAnonymously();
        emit(UserViewModelIdle());
      } catch (e) {
        emit(UserViewModelError());
      }
    });

    on<SignOutEvent>((event, emit) {
      try {
        emit(UserViewModelBusy());
        _userRepository.signOut();
        user = null;
        emit(UserViewModelIdle());
      } catch (e) {
        emit(UserViewModelError());
      }
    });

    on<SignWithGoogleEvent>((event, emit) async {
      try {
        emit(UserViewModelBusy());
        user = await _userRepository.signWithGoogle();
        emit(UserViewModelIdle());
      } catch (e) {
        emit(UserViewModelError());
      }
    });

    on<SignInWithEmailEvent>((event, emit) async {
      try {
        emit(UserViewModelBusy());
        user = await _userRepository.signInWithEmail(event.email, event.pass);
        emit(UserViewModelIdle());
      } catch (e) {
        emit(UserViewModelError());
      }
    });

    on<SignUpWithEmailEvent>((event, emit) async {
      try {
        if (checkUserEmailAndPassword(email: event.email, pass: event.pass)) {
          emit(UserViewModelBusy());
          user = await _userRepository.signUpWithEmail(
            event.email,
            event.pass,
          );
          emit(UserViewModelIdle());
        }
      } catch (e) {
        emit(UserViewModelError());
      }
    });
  }
}
