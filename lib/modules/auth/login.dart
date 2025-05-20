import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_train_firebase_getx/modules/auth/auth_controller.dart';
import 'package:note_train_firebase_getx/modules/auth/register.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator:
                    (value) =>
                        value == null || !value.contains('@')
                            ? 'Enter valid email'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator:
                    (value) =>
                        value == null || value.length < 6
                            ? 'Min 6 characters'
                            : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    authController.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 12),

              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Get.to(Register());
                },
                child: const Text("Don't have an account? Register here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
