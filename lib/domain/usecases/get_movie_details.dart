import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/movie_details.dart';
import '../repositories/movie_repository.dart';

/// Use case to fetch detailed information about a movie by its ID.
class GetMovieDetails implements UseCase<MovieDetails, String> {
  final MovieRepository repository;

  GetMovieDetails(this.repository);

  /// Executes the use case by delegating to the repository.
  @override
  Future<Either<Failure, MovieDetails>> call(String movieId) async {
    return await repository.getMovieDetails(movieId);
  }
}

class SetFavoriteMovie implements UseCase<void, String> {
  final MovieRepository repository;

  SetFavoriteMovie(this.repository);

  /// Executes the use case by delegating to the repository.
  @override
  Future<Either<Failure, bool>> call(String movieId) async {
    return await repository.setFavoriteMovie(movieId);
  }
}
