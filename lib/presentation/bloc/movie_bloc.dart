import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_movie_details.dart';
import '../../domain/usecases/search_movies.dart';
import 'movie_event.dart';
import 'movie_state.dart';

/// Bloc for managing movie-related states and events.
/// Handles user interactions for searching movies and fetching movie details.
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  // Use case for searching movies based on a query.
  final SearchMovies searchMovies;

  // Use case for fetching detailed information about a specific movie.
  final GetMovieDetails getMovieDetails;

  final SetFavoriteMovie setFavoriteMovie;

  /// Constructor for initializing the `MovieBloc` with required dependencies.
  /// The `super` call sets the initial state to `MovieInitial`.
  MovieBloc(
      {required this.searchMovies,
      required this.getMovieDetails,
      required this.setFavoriteMovie})
      : super(MovieInitial()) {
    // Event handler for `SearchMoviesEvent`.
    // Triggered when the user initiates a search for movies.
    on<SearchMoviesEvent>((event, emit) async {
      // Emit the `MovieLoading` state to indicate loading in progress.
      emit(MovieLoading());

      // Execute the `searchMovies` use case with the user's query.
      final result = await searchMovies(event.query);

      // Handle the result using the `fold` method:
      // - On failure, emit a `MovieError` state with an error message.
      // - On success, emit a `MoviesLoaded` state with the list of movies.
      result.fold(
        (failure) => emit(MovieError('Failed to load movies.')),
        (movies) => emit(MoviesLoaded(movies)),
      );
    });

    // Event handler for `GetMovieDetailsEvent`.
    // Triggered when the user selects a movie to view its details.
    on<GetMovieDetailsEvent>((event, emit) async {
      // Emit the `MovieLoading` state to indicate loading in progress.
      emit(MovieLoading());

      // Execute the `getMovieDetails` use case with the selected movie ID.
      final result = await getMovieDetails(event.movieId);

      // Handle the result using the `fold` method:
      // - On failure, emit a `MovieError` state with an error message.
      // - On success, emit a `MovieDetailsLoaded` state with the movie details.
      result.fold(
        (failure) => emit(MovieError('Failed to load movie details.')),
        (details) => emit(MovieDetailsLoaded(details)),
      );
    });

    on<SaveFavoriteEvent>((event, emit) async {
      final result = await setFavoriteMovie(event.movieId);
      result.fold(
        (failure) => emit(MovieError('Failed to load movie details.')),
        (result) {
          if (state is MovieDetailsLoaded) {
            final movieDetailsLoaded = state as MovieDetailsLoaded;
            final details = movieDetailsLoaded.movieDetails
                .copyWith(isFavoriteMovie: result);
            emit(MovieDetailsLoaded(details));
          }
        },
      );
    });
  }
}
