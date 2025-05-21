import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:note_train_firebase_getx/modules/home/note_model.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<NoteModel> todoList = <NoteModel>[].obs;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? todoSubscription;

  String get userId => _auth.currentUser?.uid ?? '';

  @override
  void onReady() {
    super.onReady();

    _auth.authStateChanges().listen((user) {
      todoSubscription?.cancel();

      if (user != null) {
        _startListeningToTodos(user.uid);
      } else {
        todoList.clear();
      }
    });

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
              snapshot.docs
                  .map((doc) => NoteModel.fromJson(doc.data(), doc.id))
                  .toList(),
            );
          },
          onError: (error) {
            print('Error listening to todos: $error');
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

    final note = NoteModel(
      id: '', // Firestore will generate it
      title: title.trim(),
      isDone: false,
      userID: userId,
      timestamp: Timestamp.now(),
    );

    await _firestore.collection('todo-list').add(note.toJson());
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
