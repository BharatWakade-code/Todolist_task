import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_list/Services/to_do.dart';
import 'package:to_do_list/componets/MyTextField.dart';
import 'package:timeago/timeago.dart' as timeago;

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  TextEditingController TitleController = TextEditingController();
  TextEditingController DiscriptionController = TextEditingController();
  TodoServices _todoServices = TodoServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void AddWork() async {
    if (TitleController.text.isNotEmpty) {
      await _todoServices.RegisterWork(
          DiscriptionController.text, TitleController.text);
      DiscriptionController.clear();
      TitleController.clear();

      print("Work Send Succesful");
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentuser = _auth.currentUser!.uid;

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tasks",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(157, 89, 255, 1),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: TitleController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Titile",
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(200, 165, 250, 1),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromRGBO(157, 89, 255, 1),
                  )),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: DiscriptionController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Discription",
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(200, 165, 250, 1),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromRGBO(157, 89, 255, 1),
                  )),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Titile",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(157, 89, 255, 1),
                      ),
                    ),
                    Text(
                      "Discription",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(157, 89, 255, 1),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: StreamBuilder(
                    stream: _todoServices.getWorks(currentuser),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Error");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading...");
                      }

                      return ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((doc) => _buildTodoItem(doc))
                            .toList(),
                      );
                    }),
              ),
              GestureDetector(
                onTap: () async {
                  await _todoServices.RegisterWork(
                      DiscriptionController.text, TitleController.text);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Task Added Succesfully"),
                  ));
                  DiscriptionController.clear();
                  TitleController.clear();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                    color: Color.fromRGBO(157, 89, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                  child: Center(
                      child: const Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _todoList() {
    String currentuser = _auth.currentUser!.uid;
    return StreamBuilder(
        stream: _todoServices.getWorks(currentuser),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          return ListView(
            shrinkWrap: true,
            children:
                snapshot.data!.docs.map((doc) => _buildTodoItem(doc)).toList(),
          );
        });
  }

  Widget _buildTodoItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    var titile = data["title"];
    var description = data["description"];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(114, 16, 255, 1),
                Color.fromRGBO(157, 89, 255, 1),
              ],
            ),
          ),
          child: GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titile,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
