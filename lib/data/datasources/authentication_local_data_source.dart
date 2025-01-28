import 'package:hive/hive.dart';

import '../models/user_model.dart';
import '../../core/error/exceptions.dart';

abstract class AuthenticationLocalDataSource {
  Future<UserModel> userSignIn(String username, String password);
}

class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  final Box box;

  AuthenticationLocalDataSourceImpl({required this.box});

  @override
  Future<UserModel> userSignIn(String username, String password) async {
    final savedUsername = box.get('username');

    if (savedUsername == null) {
      box.put('id', '1');
      box.put('username', 'Nico');
      box.put('password', 'Pass123');
    }

    final user = UserModel(id: box.get('id'), username: box.get('username'));
    await Future.delayed(
      const Duration(seconds: 2),
    );
    if (user.username == username && box.get('password') == password) {
      return user;
    } else {
      throw ServerException();
    }
  }
}
