import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_train_firebase_getx/modules/auth/auth_controller.dart';
import 'package:note_train_firebase_getx/modules/home/home_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController todoController = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My ToDo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.find<AuthController>().logout();
            },
          ),
        ],
      ),
      body: Obx(() {
        final todos = todoController.todoList;

        if (todos.isEmpty) {
          return const Center(child: Text('No todos yet!'));
        }

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];

            return ListTile(
              title: Text(todo['title']),
              leading: Checkbox(
                value: todo['isDone'] ?? false,
                onChanged: (value) {
                  if (value != null) {
                    todoController.toggleTodo(todo['id'], todo['isDone']);
                  }
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  todoController.deleteTodo(todo['id']);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final TextEditingController textController =
                  TextEditingController();

              return AlertDialog(
                title: const Text('Add Todo'),
                content: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'Enter todo title',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final text = textController.text.trim();
                      if (text.isNotEmpty) {
                        todoController.addTodo(text);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
