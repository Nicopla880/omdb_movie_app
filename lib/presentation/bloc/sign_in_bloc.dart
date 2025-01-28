import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdb_movie_app/domain/usecases/user_sign_in.dart';

import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserSignIn userSignIn;

  SignInBloc({
    required this.userSignIn,
  }) : super(SignInInitial()) {
    on<UserSignInEvent>((event, emit) async {
      emit(SignInLoading());

      final result = await userSignIn({
        'username': event.username,
        'password': event.password,
      });

      result.fold(
        (failure) => emit(SignInError('Incorrect username or password.')),
        (user) => emit(SignInLoaded(user)),
      );
    });
  }
}
