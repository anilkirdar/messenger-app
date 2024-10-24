part of 'user_view_model_bloc.dart';

@immutable
abstract class UserViewModelEvent {}

class CurrentUserEvent extends UserViewModelEvent {}

class GetUsersEvent extends UserViewModelEvent {
  final UserModel user;
  final int countOfWillBeFetchedUserCount;

  GetUsersEvent(
      {required this.user, required this.countOfWillBeFetchedUserCount});
}

class GetMessagesEvent extends UserViewModelEvent {
  final String currentUserID;
  final String otherUserID;
  final MessageModel? message;
  final int countOfWillBeFetchedMessageCount;
  final bool isInitFunction;
  final BuildContext context;

  GetMessagesEvent(
      {required this.currentUserID,
      required this.otherUserID,
      required this.message,
      required this.countOfWillBeFetchedMessageCount,
      required this.isInitFunction,
      required this.context});
}

class SaveChatMessageEvent extends UserViewModelEvent {
  final MessageModel message;
  final ValueChanged<bool> resultCallBack;

  SaveChatMessageEvent({required this.resultCallBack, required this.message});
}

class ConvertErrorStateEvent extends UserViewModelEvent {}

class GetChatsEvent extends UserViewModelEvent {
  final UserModel currentUser;
  final int countOfWillBeFetchedChatCount;

  GetChatsEvent(
      {required this.currentUser, required this.countOfWillBeFetchedChatCount});
}

class AddStoryEvent extends UserViewModelEvent {
  final String storyPhotoUrl;
  final String userID;
  final ValueChanged<bool> resultCallBack;

  AddStoryEvent(
      {required this.storyPhotoUrl,
      required this.userID,
      required this.resultCallBack});
}

class GetStoriesEvent extends UserViewModelEvent {
  final String userID;
  final int countOfWillBeFetchedStoryCount;

  GetStoriesEvent(
      {required this.userID, required this.countOfWillBeFetchedStoryCount});
}

class UpdateUserNameEvent extends UserViewModelEvent {
  final String userID;
  final String newUserName;
  final ValueChanged<bool> resultCallBack;

  UpdateUserNameEvent({
    required this.userID,
    required this.newUserName,
    required this.resultCallBack,
  });
}

class UpdateUserPassEvent extends UserViewModelEvent {
  final String userID;
  final String newPass;

  UpdateUserPassEvent({
    required this.userID,
    required this.newPass,
  });
}

class DeleteUserEvent extends UserViewModelEvent {
  final UserModel currentUser;

  DeleteUserEvent({required this.currentUser});
}

class UpdateUserProfilePhotoEvent extends UserViewModelEvent {
  final String userID;
  final String fileType;
  final XFile? newProfilePhoto;

  UpdateUserProfilePhotoEvent({
    required this.userID,
    required this.fileType,
    required this.newProfilePhoto,
  });
}

class SignAnonymouslyEvent extends UserViewModelEvent {}

class SignOutEvent extends UserViewModelEvent {}

class SignWithGoogleEvent extends UserViewModelEvent {}

class SignInWithEmailEvent extends UserViewModelEvent {
  final String email;
  final String pass;

  SignInWithEmailEvent({required this.email, required this.pass});
}

class SignUpWithEmailEvent extends UserViewModelEvent {
  final String email;
  final String pass;

  SignUpWithEmailEvent({required this.email, required this.pass});
}
