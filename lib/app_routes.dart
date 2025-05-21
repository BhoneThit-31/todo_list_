import 'package:get/get.dart';
import 'package:note_train_firebase_getx/middleware/auth_middleware.dart';
import 'package:note_train_firebase_getx/modules/auth/login.dart';
import 'package:note_train_firebase_getx/modules/auth/register.dart';
import 'package:note_train_firebase_getx/modules/home/home.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';

  static final routes = [
    GetPage(name: login, page: () => Login()),
    GetPage(name: register, page: () => Register()),
    GetPage(
      name: home,
      page: () => const Home(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
