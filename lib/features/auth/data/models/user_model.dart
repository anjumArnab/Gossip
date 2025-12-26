import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.createdAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
    };
  }
}