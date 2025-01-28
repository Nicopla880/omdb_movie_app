import 'package:equatable/equatable.dart';

/// Base class for all movie-related events.
/// Extends the `Equatable` package for easy comparison of event instances.
/// This allows the Bloc to differentiate between events based on their properties.
abstract class MovieEvent extends Equatable {
  /// Override the `props` property to define which fields are considered
  /// for event comparison. By default, it returns an empty list.
  @override
  List<Object?> get props => [];
}

/// Event triggered when the user initiates a search for movies.
/// This event contains the query string entered by the user.
class SearchMoviesEvent extends MovieEvent {
  // The query string provided by the user to search for movies.
  final String query;

  /// Constructor to initialize the `SearchMoviesEvent` with the user's query.
  SearchMoviesEvent(this.query);

  /// Override the `props` property to include the `query` field.
  /// This ensures that events with the same query are considered equal.
  @override
  List<Object?> get props => [query];
}

/// Event triggered when the user selects a movie to view its details.
/// This event contains the ID of the selected movie.
class GetMovieDetailsEvent extends MovieEvent {
  // The unique identifier of the movie selected by the user.
  final String movieId;

  /// Constructor to initialize the `GetMovieDetailsEvent` with the movie ID.
  GetMovieDetailsEvent(this.movieId);

  /// Override the `props` property to include the `movieId` field.
  /// This ensures that events with the same movie ID are considered equal.
  @override
  List<Object?> get props => [movieId];
}

class SaveFavoriteEvent extends MovieEvent {
  final String movieId;

  SaveFavoriteEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
