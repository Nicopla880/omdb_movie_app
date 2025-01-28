import 'package:hive/hive.dart';

abstract class MovieLocalDataSource {
  Future<bool> setFavoriteMovie(String id);
  Future<bool> isFavoriteMovie(String id);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Box box;

  MovieLocalDataSourceImpl({required this.box});

  @override
  Future<bool> setFavoriteMovie(String id) async {
    final movieIdList = await box.get("favorite-movies", defaultValue: []);
    bool result = false;
    if (movieIdList.isNotEmpty && movieIdList.contains(id)) {
      movieIdList.remove(id);
    } else {
      movieIdList.add(id);
      result = true;
    }

    await box.put(
      "favorite-movies",
      movieIdList,
    );

    return result;
  }

  @override
  Future<bool> isFavoriteMovie(String id) async {
    final List<dynamic>? movieIdList = await box.get(
      "favorite-movies",
    );

    if (movieIdList == null) return false;
    final result = movieIdList.contains(id);
    return result;
  }
}
