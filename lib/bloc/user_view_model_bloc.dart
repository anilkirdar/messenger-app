import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../locator.dart';
import '../../models/user_model.dart';
import '../../repository/user_repository.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/story_model.dart';

part 'user_view_model_event.dart';
part 'user_view_model_state.dart';

class UserViewModelBloc extends Bloc<UserViewModelEvent, UserViewModelState> {
  final UserRepository _userRepository = locator<UserRepository>();
  List<UserModel>? userList;
  List<StoryModel>? storyList;
  List<MessageModel>? messageList;
  Stream<List<ChatModel>>? chatListStream;
  UserModel? user;
  static String? errorCode;
  String? emailErrorMessage;
  String? passErrorMessage;
  String? bothErrorMessage;
  String? generalErrorMessage;

  UserViewModelBloc() : super(UserViewModelIdleState()) {
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

    on<ConvertErrorStateEvent>((event, emit) {
      if (state is UserViewModelErrorState) {
        emit(UserViewModelIdleState());
      }
    });

    on<CurrentUserEvent>((event, emit) async {
      user = null;
      userList = null;
      storyList = null;
      messageList = null;
      chatListStream = null;
      emit(UserViewModelBusyState());
      user = await _userRepository.currentUser();
      emit(UserViewModelIdleState());
    });

    on<GetChatsEvent>((event, emit) async {
      chatListStream = await _userRepository.getChats(
        currentUser: event.currentUser,
        countOfWillBeFetchedChatCount: event.countOfWillBeFetchedChatCount,
      );
      emit(UserViewModelIdleState());
    });

    on<SaveChatMessageEvent>((event, emit) async {
      await _userRepository.saveChatMessage(
          message: event.message, resultCallBack: event.resultCallBack);
      emit(UserViewModelIdleState());
    });

    on<GetUsersEvent>((event, emit) async {
      emit(UserViewModelUserDBBusyState());
      userList = await _userRepository.getUsers(
        user: event.user,
        countOfWillBeFetchedUserCount: event.countOfWillBeFetchedUserCount,
      );
      emit(UserViewModelIdleState());
    });

    on<GetStoriesEvent>((event, emit) async {
      emit(UserViewModelUserDBBusyState());
      storyList = await _userRepository.getStories(
          userID: event.userID,
          countOfWillBeFetchedStoryCount: event.countOfWillBeFetchedStoryCount,
          currentUser: user!);
      emit(UserViewModelIdleState());
    });

    on<GetMessagesEvent>((event, emit) async {
      if (event.isInitFunction) {
        messageList = null;
      }
      emit(UserViewModelMessageDBBusyState());
      messageList = await _userRepository.getMessages(
        currentUserID: event.currentUserID,
        otherUserID: event.otherUserID,
        message: event.message,
        countOfWillBeFetchedMessageCount:
            event.countOfWillBeFetchedMessageCount,
        isInitFunction: event.isInitFunction,
      );

      emit(UserViewModelIdleState());
    });

    on<AddStoryEvent>((event, emit) async {
      await _userRepository.addStory(
          storyPhotoUrl: event.storyPhotoUrl,
          userID: event.userID,
          resultCallBack: event.resultCallBack);
      emit(UserViewModelIdleState());
    });

    on<UpdateUserNameEvent>((event, emit) async {
      bool? result = await _userRepository.updateUserName(
          userID: event.userID,
          newUserName: event.newUserName,
          resultCallBack: event.resultCallBack);

      if (result!) {
        user!.userName = event.newUserName;
      }
      emit(UserViewModelIdleState());
    });

    on<UpdateUserPassEvent>((event, emit) async {
      await _userRepository.updateUserPass(
          userID: event.userID, newPass: event.newPass);
      emit(UserViewModelIdleState());
    });

    on<DeleteUserEvent>((event, emit) async {
      bool result = await _userRepository.deleteUser(currentUser: event.currentUser);
      if (result) {
        user = null;
      }
      emit(UserViewModelIdleState());
    });

    on<UpdateUserProfilePhotoEvent>((event, emit) async {
      String? url = await _userRepository.updateUserProfilePhoto(
          userID: event.userID,
          fileType: event.fileType,
          newProfilePhoto: event.newProfilePhoto!);

      user!.profilePhotoURL = url;
    });

    on<SignAnonymouslyEvent>((event, emit) async {
      emit(UserViewModelBusyState());
      user = await _userRepository.signAnonymously();
      emit(UserViewModelIdleState());
    });

    on<SignOutEvent>((event, emit) {
      _userRepository.signOut();
      user = null;
      emit(UserViewModelIdleState());
    });

    on<SignWithGoogleEvent>((event, emit) async {
      try {
        emit(UserViewModelBusyState());
        user = await _userRepository.signWithGoogle();
        emit(UserViewModelIdleState());
      } catch (e) {
        emit(UserViewModelErrorState());
      }
    });

    on<SignInWithEmailEvent>((event, emit) async {
      emit(UserViewModelBusyState());
      user = await _userRepository.signInWithEmail(event.email, event.pass);
      if (user != null) {
        emit(UserViewModelIdleState());
      } else {
        emit(UserViewModelErrorState());
      }
    });

    on<SignUpWithEmailEvent>((event, emit) async {
      if (checkUserEmailAndPassword(email: event.email, pass: event.pass)) {
        emit(UserViewModelBusyState());
        user = await _userRepository.signUpWithEmail(
          event.email,
          event.pass,
        );

        if (user != null) {
          emit(UserViewModelIdleState());
        } else {
          emit(UserViewModelErrorState());
        }
      }
    });
  }
}
