import 'package:get/get.dart';
import '../../../../core/routes/routes.dart';
import '../../domain/usecases/sign_in_anonymously.dart';
import '../../domain/usecases/get_current_user.dart';

class AuthController extends GetxController {
  final SignInAnonymously signInAnonymously;
  final GetCurrentUser getCurrentUser;

  AuthController(this.signInAnonymously, this.getCurrentUser);

  bool isLoading = false;
  String? errorMessage;

  Future<void> signIn() async {
    isLoading = true;
    errorMessage = null;
    update();

    try {
      await signInAnonymously();
      Get.offAllNamed(AppRoutes.usersList);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }
}