import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/view_model/view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {

  static Future<void> fetchUsers()async{

    final usersSnapshot = await FirebaseFirestore.instance.collection("users").get();

    final allDocs = usersSnapshot.docs;

    final filteredDocs = allDocs.where(
      (doc) => doc.data()["id"] != FirebaseAuth.instance.currentUser!.uid
    );

    final userModels = filteredDocs.map((doc) {
      return UserModel.fromMap(doc.data());
    }).toList();

    vm.users.value = userModels;

  }


}