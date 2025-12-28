import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/chat/presentation/pages/users_list_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import 'routes.dart';

class AppPages {
  // Prevent instantiation
  AppPages._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.signIn,

    routes: [
      GoRoute(
        path: AppRoutes.signIn,
        name: AppRoutes.signInName,
        builder: (context, state) => SignInPage(),
      ),
      GoRoute(
        path: AppRoutes.usersList,
        name: AppRoutes.usersListName,
        builder: (context, state) => UsersListPage(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        name: AppRoutes.chatName,
        builder: (context, state) {
          final userId = state.pathParameters['userId'] ?? '';
          return ChatPage(userId: userId);
        },
      ),
    ],
    errorBuilder: (context, state) => SignInPage(),
  );
}
