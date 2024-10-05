part of 'user_view_model_bloc.dart';

@immutable
abstract class UserViewModelState {}

final class UserViewModelIdleState extends UserViewModelState {}

final class UserViewModelBusyState extends UserViewModelState {}

final class UserViewModelUserDBBusyState extends UserViewModelState {}

final class UserViewModelMessageDBBusyState extends UserViewModelState {}

final class UserViewModelErrorState extends UserViewModelState {}
