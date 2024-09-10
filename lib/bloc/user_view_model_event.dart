part of 'user_view_model_bloc.dart';

@immutable
abstract class UserViewModelEvent {}

class CurrentUserEvent extends UserViewModelEvent {}

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
