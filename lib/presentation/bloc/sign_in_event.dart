import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserSignInEvent extends SignInEvent {
  final String username;
  final String password;
  UserSignInEvent(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}
