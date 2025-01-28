import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:omdb_movie_app/data/datasources/movie_local_data_source.dart';
import 'package:omdb_movie_app/data/repositories/authentication_repository_impl.dart';
import 'package:omdb_movie_app/domain/usecases/user_sign_in.dart';
import 'package:omdb_movie_app/presentation/bloc/sign_in_bloc.dart';
import 'package:omdb_movie_app/presentation/pages/sign_in_page.dart';
import 'package:path_provider/path_provider.dart';

import 'data/datasources/authentication_local_data_source.dart';
import 'data/datasources/movie_remote_data_source.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'domain/usecases/get_movie_details.dart';
import 'domain/usecases/search_movies.dart';
import 'presentation/bloc/movie_bloc.dart';

// Entry point of the Flutter application.
void main() async {
  // Calls the root widget of the application.
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.openBox('userBox');
  await Hive.openBox('movieBox');

  runApp(MyApp());
}

// The root widget of the application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dependency Injection:
    // - Initialize an HTTP client to handle API requests.
    final http.Client client = http.Client();
    final userBox = Hive.box("userBox");
    final movieBox = Hive.box("movieBox");

    // - Create an instance of the remote data source, which interacts with the OMDb API.
    final movieRemoteDataSource = MovieRemoteDataSourceImpl(client: client);
    final movieLocalDataSource = MovieLocalDataSourceImpl(box: movieBox);

    final authenticationLocalDataSource = AuthenticationLocalDataSourceImpl(
      box: userBox,
    );

    // - Create an instance of the repository, which abstracts data operations
    //   and provides a single source of truth for the app.
    final movieRepository = MovieRepositoryImpl(
      remoteDataSource: movieRemoteDataSource,
      localDataSource: movieLocalDataSource,
    );
    final authenticationRepository = AuthenticationRepositoryImpl(
        localDataSource: authenticationLocalDataSource);

    // - Initialize use cases for searching movies and fetching movie details.
    final searchMovies = SearchMovies(movieRepository);
    final getMovieDetails = GetMovieDetails(movieRepository);
    final setFavoriteMovie = SetFavoriteMovie(movieRepository);
    final userSignIn = UserSignIn(authenticationRepository);

    // The `BlocProvider` is used to make the `MovieBloc` available to the widget tree.
    return MultiBlocProvider(
      providers: [
        // Create the `MovieBloc` and inject the required use cases for state management.
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc(
            searchMovies: searchMovies,
            getMovieDetails: getMovieDetails,
            setFavoriteMovie: setFavoriteMovie,
          ),
        ),
        BlocProvider<SignInBloc>(
          create: (_) => SignInBloc(
            userSignIn: userSignIn,
          ),
        ),
      ],

      // Define the app's structure and configuration.
      child: MaterialApp(
        // Remove the debug banner from the app.
        debugShowCheckedModeBanner: false,

        // Set the title of the application.
        title: 'OMDb Movie Search',

        // Apply a global theme to the app.
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        // Set the initial screen of the app to the `SearchPage`.
        home: SignInPage(),
      ),
    );
  }
}
