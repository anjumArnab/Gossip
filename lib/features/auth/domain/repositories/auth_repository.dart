import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInAnonymously();
  UserEntity? getCurrentUser();
}