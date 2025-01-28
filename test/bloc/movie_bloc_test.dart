import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omdb_movie_app/core/error/failures.dart';
import 'package:omdb_movie_app/domain/entities/movie.dart';
import 'package:omdb_movie_app/domain/entities/movie_details.dart';
import 'package:omdb_movie_app/domain/usecases/get_movie_details.dart';
import 'package:omdb_movie_app/domain/usecases/search_movies.dart';
import 'package:omdb_movie_app/presentation/bloc/movie_bloc.dart';
import 'package:omdb_movie_app/presentation/bloc/movie_event.dart';
import 'package:omdb_movie_app/presentation/bloc/movie_state.dart';

import 'movie_bloc_test.mocks.dart';

// Generate Mock Classes
@GenerateMocks([SearchMovies, GetMovieDetails, SetFavoriteMovie])
void main() {
  late MockSearchMovies mockSearchMovies;
  late MockGetMovieDetails mockGetMovieDetails;
  late MockSetFavoriteMovie setFavoriteMovie;
  late MovieBloc movieBloc;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    mockGetMovieDetails = MockGetMovieDetails();
    setFavoriteMovie = MockSetFavoriteMovie();

    movieBloc = MovieBloc(
      searchMovies: mockSearchMovies,
      getMovieDetails: mockGetMovieDetails,
      setFavoriteMovie: setFavoriteMovie,
    );
  });

  tearDown(() {
    movieBloc.close();
  });

  group('SearchMoviesEvent', () {
    final tMovieList = [
      Movie(
          title: 'Inception', year: '2010', imdbID: 'tt1375666', poster: 'N/A'),
    ];

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MoviesLoaded] when search is successful',
      build: () {
        when(mockSearchMovies(any)).thenAnswer((_) async => Right(tMovieList));
        return movieBloc;
      },
      act: (bloc) => bloc.add(SearchMoviesEvent('Inception')),
      expect: () => [
        MovieLoading(),
        MoviesLoaded(tMovieList),
      ],
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MovieError] when search fails',
      build: () {
        when(mockSearchMovies(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return movieBloc;
      },
      act: (bloc) => bloc.add(SearchMoviesEvent('Unknown')),
      expect: () => [
        MovieLoading(),
        MovieError('Failed to load movies.'),
      ],
    );
  });

  group('GetMovieDetailsEvent', () {
    final tMovieDetails = MovieDetails(
        title: 'Inception',
        year: '2010',
        director: 'Christopher Nolan',
        actors: 'Leonardo DiCaprio, Joseph Gordon-Levitt, Ellen Page',
        plot:
            'A thief steals corporate secrets through dream-sharing technology.',
        runtime: '148 min',
        genre: 'Action, Adventure, Sci-Fi',
        poster: 'N/A');

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MovieDetailsLoaded] when details are fetched successfully',
      build: () {
        when(mockGetMovieDetails(any))
            .thenAnswer((_) async => Right(tMovieDetails));
        return movieBloc;
      },
      act: (bloc) => bloc.add(GetMovieDetailsEvent('tt1375666')),
      expect: () => [
        MovieLoading(),
        MovieDetailsLoaded(tMovieDetails, true),
      ],
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MovieError] when fetching details fails',
      build: () {
        when(mockGetMovieDetails(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return movieBloc;
      },
      act: (bloc) => bloc.add(GetMovieDetailsEvent('InvalidID')),
      expect: () => [
        MovieLoading(),
        MovieError('Failed to load movie details.'),
      ],
    );
  });
}
