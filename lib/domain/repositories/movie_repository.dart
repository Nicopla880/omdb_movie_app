import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/movie.dart';
import '../entities/movie_details.dart';

/// Abstract repository interface for movies.
/// Defines methods to search for movies and fetch movie details.
abstract class MovieRepository {
  /// Searches for movies based on a query string.
  Future<Either<Failure, List<Movie>>> searchMovies(String query);

  /// Fetches detailed information about a movie by its ID.
  Future<Either<Failure, MovieDetails>> getMovieDetails(String movieId);

  Future<Either<Failure, bool>> setFavoriteMovie(String movieId);
}
