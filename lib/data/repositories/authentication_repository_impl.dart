import 'package:dartz/dartz.dart';
import 'package:omdb_movie_app/domain/entities/user.dart';
import 'package:omdb_movie_app/domain/repositories/authentication_repository.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../datasources/authentication_local_data_source.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationLocalDataSource localDataSource;

  AuthenticationRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, User>> signIn(String username, String password) async {
    try {
      final model = await localDataSource.userSignIn(username, password);
      final user = User(id: model.id, username: model.username);
      return Right(user);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
