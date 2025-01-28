import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String username,
  }) : super(id: id, username: username);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['Id'],
      username: json['Username'],
    );
  }
}
