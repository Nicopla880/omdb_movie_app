import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdb_movie_app/domain/usecases/get_movie_details.dart';

import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';

/// Page displaying detailed information about a selected movie.
class DetailsPage extends StatelessWidget {
  final String movieId;

  DetailsPage({required this.movieId});

  @override
  Widget build(BuildContext context) {
    // Fetch movie details when the page is built.
    context.read<MovieBloc>().add(GetMovieDetailsEvent(movieId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
        actions: [
          BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
            if (state is MovieDetailsLoaded) {
              final isFavorite = state.movieDetails.isFavoriteMovie;
              return IconButton(
                onPressed: () {
                  context.read<MovieBloc>().add(
                        SaveFavoriteEvent(
                          movieId,
                        ),
                      );
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                  color: isFavorite ? Colors.red : Colors.black,
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MovieDetailsLoaded) {
            final details = state.movieDetails;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  CachedNetworkImage(
                    imageUrl: details.poster,
                    fit: BoxFit.fitHeight,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  SizedBox(height: 10),
                  Text('Year: ${details.year}', style: TextStyle(fontSize: 16)),
                  Text('Director: ${details.director}',
                      style: TextStyle(fontSize: 16)),
                  Text('Actors: ${details.actors}',
                      style: TextStyle(fontSize: 16)),
                  Text('Runtime: ${details.runtime}',
                      style: TextStyle(fontSize: 16)),
                  Text('Genre: ${details.genre}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Text(
                    'Plot',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(details.plot, style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          } else if (state is MovieError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: TextStyle(color: Colors.red)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<MovieBloc>()
                          .add(GetMovieDetailsEvent(movieId));
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Unexpected error occurred.'));
          }
        },
      ),
    );
  }
}
