import 'package:equatable/equatable.dart';
import 'package:omdb_movie_app/domain/entities/user.dart';

abstract class SignInState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInLoaded extends SignInState {
  final User user;

  SignInLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class SignInError extends SignInState {
  final String message;

  SignInError(this.message);

  @override
  List<Object?> get props => [message];
}
