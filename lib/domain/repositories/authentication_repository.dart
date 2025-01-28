import 'package:dartz/dartz.dart';
import 'package:omdb_movie_app/domain/entities/user.dart';

import '../../core/error/failures.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, User>> signIn(String username, String password);
}
