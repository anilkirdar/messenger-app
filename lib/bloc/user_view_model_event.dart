part of 'user_view_model_bloc.dart';

@immutable
abstract class UserViewModelEvent {}

class CurrentUserEvent extends UserViewModelEvent {}

class UpdateUserNameEvent extends UserViewModelEvent {
  final String userID;
  final String newUserName;
  final ValueChanged<bool> resultCallBack;

  UpdateUserNameEvent(
      {required this.userID,
      required this.newUserName,
      required this.resultCallBack});
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
