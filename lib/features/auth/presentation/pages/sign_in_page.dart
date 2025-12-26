import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gossip/features/auth/presentation/widgets/auth_button.dart';
import '../../../../core/di/injection_container.dart';
import '../controllers/auth_controller.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(sl<AuthController>());

    return Scaffold(
      body: Center(
        child: GetBuilder<AuthController>(
          builder: (ctrl) {
            if (ctrl.isLoading) {
              return const CircularProgressIndicator();
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF7B68EE),
                        Color(0xFF6A5ACD),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: const Color(0xFF7B68EE).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Gossip',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 100),
                  AuthButton(label: 'Sign In Anonymously', onTap: ctrl.signIn),
                  if (ctrl.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        ctrl.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
