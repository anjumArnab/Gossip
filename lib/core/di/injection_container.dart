import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_anonymously.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/get_users.dart';
import '../../features/chat/domain/usecases/send_message.dart';
import '../../features/chat/domain/usecases/get_messages.dart';
import '../../features/chat/presentation/controllers/users_controller.dart';
import '../../features/chat/presentation/controllers/chat_controller.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseDatabase.instance);
  
  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl())
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl())
  );
  sl.registerLazySingleton(() => SignInAnonymously(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerFactory(() => AuthController(sl(), sl()));
  
  // Chat
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl())
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl())
  );
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => GetMessages(sl()));
  
  sl.registerFactory(() => UsersController(sl(), sl()));
  sl.registerFactory(() => ChatController(sl(), sl(), sl()));
}