part of 'user_view_model_bloc.dart';

@immutable
sealed class UserViewModelState {
  // final List<MessageModel>? messageList;

  // const UserViewModelState({this.messageList});
}

final class UserViewModelIdleState extends UserViewModelState {
  // const UserViewModelIdleState({super.messageList});
}

final class UserViewModelBusyState extends UserViewModelState {}

final class UserViewModelUserDBBusyState extends UserViewModelState {}

final class UserViewModelMessageDBBusyState extends UserViewModelState {}

final class UserViewModelErrorState extends UserViewModelState {}
