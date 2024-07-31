import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String? id;
  String title;
  String description;

  Todo({
    required this.id,
    required this.title,
    required this.description,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
