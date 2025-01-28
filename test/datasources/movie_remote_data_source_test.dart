import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omdb_movie_app/core/error/exceptions.dart';
import 'package:omdb_movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:omdb_movie_app/data/models/movie_details_model.dart';
import 'package:omdb_movie_app/data/models/movie_model.dart';

import 'movie_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockHttpClient;
  late MovieRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('searchMovies', () {
    final tQuery = 'Inception';
    final tMovieModels = [
      MovieModel(
        title: 'Inception',
        year: '2010',
        imdbID: 'tt1375666',
        poster: 'N/A',
      )
    ];

    test('should perform a GET request and return a list of MovieModels',
        () async {
      // Arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
            jsonEncode({
              'Search': [
                {
                  'Title': 'Inception',
                  'Year': '2010',
                  'imdbID': 'tt1375666',
                  'Poster': 'N/A'
                }
              ]
            }),
            200),
      );

      final expectedModels = [
        MovieModel(
            title: 'Inception',
            year: '2010',
            imdbID: 'tt1375666',
            poster: 'N/A'),
      ];

      // Act
      final result = await dataSource.searchMovies('Inception');

      // Assert
      expect(result, equals(expectedModels));
    });

    test('should throw a ServerException when the response code is not 200',
        () async {
      // Arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );

      // Act
      expect(() => dataSource.searchMovies(tQuery),
          throwsA(isA<ServerException>()));
    });
  });

  group('fetchMovieDetails', () {
    final tMovieId = 'tt1375666';
    final tMovieDetails = MovieDetailsModel(
      title: 'Inception',
      year: '2010',
      director: 'Christopher Nolan',
      actors: 'Leonardo DiCaprio, Joseph Gordon-Levitt, Ellen Page',
      plot:
          'A thief steals corporate secrets through dream-sharing technology.',
      runtime: '148 min',
      genre: 'Action, Adventure, Sci-Fi',
      poster: 'N/A',
    );

    test('should perform a GET request and return a MovieDetailsModel',
        () async {
      // Arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
            jsonEncode({
              'Title': 'Inception',
              'Year': '2010',
              'Director': 'Christopher Nolan',
              'Actors': 'Leonardo DiCaprio, Joseph Gordon-Levitt, Ellen Page',
              'Plot':
                  'A thief steals corporate secrets through dream-sharing technology.',
              'Runtime': '148 min',
              'Genre': 'Action, Adventure, Sci-Fi',
            }),
            200),
      );

      final expectedModel = MovieDetailsModel(
        title: 'Inception',
        year: '2010',
        director: 'Christopher Nolan',
        actors: 'Leonardo DiCaprio, Joseph Gordon-Levitt, Ellen Page',
        plot:
            'A thief steals corporate secrets through dream-sharing technology.',
        runtime: '148 min',
        genre: 'Action, Adventure, Sci-Fi',
        poster: 'N/A',
      );

      // Act
      final result = await dataSource.fetchMovieDetails('tt1375666');

      // Assert
      expect(result, equals(expectedModel));
    });

    test('should throw a ServerException when the response code is not 200',
        () async {
      // Arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );

      // Act
      expect(() => dataSource.fetchMovieDetails(tMovieId),
          throwsA(isA<ServerException>()));
    });
  });
}
