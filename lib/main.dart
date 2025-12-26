import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:gossip/firebase_options.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  runApp(const Gossip());
}

class Gossip extends StatelessWidget {
  const Gossip({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gossip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme(),),
      initialRoute: AppRoutes.signIn,
      getPages: AppPages.routes,
    );
  }
}