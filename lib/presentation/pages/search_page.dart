import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
import 'details_page.dart';

/// Page for searching movies.
/// Allows the user to input a query and displays a list of movies.
class SearchPage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movies'),
      ),
      body: Column(
        children: [
          /// Input field for movie search query.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a movie',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    context
                        .read<MovieBloc>()
                        .add(SearchMoviesEvent(_searchController.text));
                  },
                ),
              ),
              onSubmitted: (query) {
                context.read<MovieBloc>().add(SearchMoviesEvent(query));
              },
            ),
          ),

          /// Displays a list of movies or error/loading messages.
          Expanded(
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is MoviesLoaded) {
                  return ListView.builder(
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return ListTile(
                        leading: Image.network(
                          movie.poster,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.broken_image),
                        ),
                        title: Text(movie.title),
                        subtitle: Text(movie.year),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: context.read<MovieBloc>(),
                                child: DetailsPage(movieId: movie.imdbID),
                              ),
                            ),
                          );
                          _searchController.text = "";
                        },
                      );
                    },
                  );
                } else if (state is MovieError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                } else {
                  return Center(
                      child: Text('Search for movies to display here.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
