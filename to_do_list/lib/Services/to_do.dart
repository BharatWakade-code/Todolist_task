import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/models/todo.dart';

class TodoServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> RegisterWork(
    String Description,
    Titile,
  ) async {
    final String currentUser = _auth.currentUser!.uid;

    Todo todo = Todo(
      id: currentUser,
      description: Description,
      title: Titile,
    );
    await _firestore
        .collection("Works")
        .doc(currentUser)
        .collection("WorkList")
        .add(todo.toMap());
  }

  Stream<QuerySnapshot> getWorks(String currentuser) {
    return _firestore
        .collection("Works")
        .doc(currentuser)
        .collection("WorkList")
        .snapshots();
  }

  Future<void> deleteTask(String Documentid) {
    String currentuser = _auth.currentUser!.uid;
    return _firestore
        .collection("Works")
        .doc(currentuser)
        .collection("WorkList")
        .doc(currentuser)
        .delete();
  }
}
