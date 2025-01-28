import 'package:dartz/dartz.dart';

import '../entities/user.dart';
import '../repositories/authentication_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';

class UserSignIn implements UseCase<User, Map<String, String>> {
  final AuthenticationRepository repository;

  UserSignIn(this.repository);

  @override
  Future<Either<Failure, User>> call(Map<String, String> credentials) async {
    return await repository.signIn(
        credentials['username']!, credentials['password']!);
  }
}
