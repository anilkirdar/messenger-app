part of 'user_view_model_bloc.dart';

@immutable
abstract class UserViewModelState {}

final class UserViewModelIdle extends UserViewModelState {}

final class UserViewModelBusy extends UserViewModelState {}

final class UserViewModelError extends UserViewModelState {}
