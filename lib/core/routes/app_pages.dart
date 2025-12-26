import 'package:get/get.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/chat/presentation/pages/users_list_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import 'routes.dart';

class AppPages {
  // Prevent instantiation
  AppPages._();

  static final routes = [
    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInPage(),
    ),
    GetPage(
      name: AppRoutes.usersList,
      page: () => const UsersListPage(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () {
        final userId = Get.arguments as String? ?? Get.parameters['userId'] ?? '';
        return ChatPage(userId: userId);
      },
    ),
  ];
}