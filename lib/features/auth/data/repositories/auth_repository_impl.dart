import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> signInAnonymously() async {
    return await remoteDataSource.signInAnonymously();
  }

  @override
  UserEntity? getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }
}