import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_train_firebase_getx/firebase_options.dart';
import 'package:note_train_firebase_getx/modules/auth/login.dart';
import 'package:note_train_firebase_getx/modules/home/home.dart';
import 'package:note_train_firebase_getx/modules/auth/auth_controller.dart';
import 'package:note_train_firebase_getx/modules/home/home_controller.dart';
import 'package:note_train_firebase_getx/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthController(), permanent: true);
  Get.put(HomeController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      home: const Root(),
      getPages: AppRoutes.routes,
    );
  }
}

class Root extends GetWidget<AuthController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.firebaseUser.value;
      if (user == null) {
        return Login();
      } else {
        return const Home();
      }
    });
  }
}
