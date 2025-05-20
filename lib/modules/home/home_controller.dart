import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<Map<String, dynamic>> todoList = <Map<String, dynamic>>[].obs;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? todoSubscription;

  String get userId => _auth.currentUser?.uid ?? '';

  @override
  void onReady() {
    super.onReady();

    // Listen to auth state changes (login/logout)
    _auth.authStateChanges().listen((user) {
      todoSubscription?.cancel(); // Cancel any previous subscription

      if (user != null) {
        _startListeningToTodos(user.uid);
      } else {
        todoList.clear();
      }
    });

    // Initial load if user already signed in
    if (userId.isNotEmpty) {
      _startListeningToTodos(userId);
    }
  }

  void _startListeningToTodos(String uid) {
    todoSubscription?.cancel();

    todoSubscription = _firestore
        .collection('todo-list')
        .where('userID', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            print(
              "Firestore snapshot received: ${snapshot.docs.length} documents",
            );
            todoList.assignAll(
              snapshot.docs.map((doc) {
                final data = doc.data();
                return {
                  'id': doc.id,
                  'title': data['title'] ?? '',
                  'isDone': data['isDone'] ?? false,
                  'userID': data['userID'] ?? '',
                  'timestamp': data['timestamp'] ?? Timestamp.now(),
                };
              }).toList(),
            );
          },
          onError: (error) {
            print('Error listening to todos: $error');
            // Optionally show a user-friendly error message here
          },
        );
  }

  @override
  void onClose() {
    todoSubscription?.cancel();
    super.onClose();
  }

  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) return;

    await _firestore.collection('todo-list').add({
      'title': title.trim(),
      'isDone': false,
      'userID': userId,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> toggleTodo(String id, bool currentStatus) async {
    await _firestore.collection('todo-list').doc(id).update({
      'isDone': !currentStatus,
    });
  }

  Future<void> deleteTodo(String id) async {
    await _firestore.collection('todo-list').doc(id).delete();
  }
}
