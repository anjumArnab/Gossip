import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInAnonymously();
  UserModel? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<UserModel> signInAnonymously() async {
    final userCredential = await firebaseAuth.signInAnonymously();
    final user = userCredential.user!;
    
    final userModel = UserModel(
      id: user.uid,
      createdAt: DateTime.now().toIso8601String(),
    );

    await FirebaseDatabase.instance
        .ref('users/${user.uid}')
        .set(userModel.toJson());

    return userModel;
  }

  @override
  UserModel? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    
    return UserModel(
      id: user.uid,
      createdAt: DateTime.now().toIso8601String(),
    );
  }
}