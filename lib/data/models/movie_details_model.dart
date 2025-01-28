import '../../domain/entities/movie_details.dart';

/// Model representing detailed movie information fetched from the OMDb API.
/// Extends the core MovieDetails entity and includes JSON parsing methods.
class MovieDetailsModel extends MovieDetails {
  MovieDetailsModel({
    required String title,
    required String year,
    required String director,
    required String actors,
    required String plot,
    required String runtime,
    required String genre,
    required String poster,
  }) : super(
            title: title,
            year: year,
            director: director,
            actors: actors,
            plot: plot,
            runtime: runtime,
            genre: genre,
            poster: poster);

  /// Factory method to create a MovieDetailsModel from a JSON map.
  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      title: json['Title'],
      year: json['Year'],
      director: json['Director'],
      actors: json['Actors'],
      plot: json['Plot'],
      runtime: json['Runtime'],
      genre: json['Genre'],
      poster: json['Poster'],
    );
  }
}
