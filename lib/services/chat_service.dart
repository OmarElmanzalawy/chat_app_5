import 'package:chat_app/models/message_model.dart';
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

  static String generateChatId(String receiverId){

    final currentId = FirebaseAuth.instance.currentUser!.uid;
    String id = "";




    // 
    if(receiverId.compareTo(currentId) < 0 ){
      id = "$receiverId$currentId";
    }else{
      id = "$currentId$receiverId";
    }

    return id;
  }

  static Future<bool> checkIfChatExists(String chatId)async{

    final doc = await FirebaseFirestore.instance.collection("chats").doc(chatId).get();

    return doc.exists;
  }

  static Future<void> createNewChat(String chatId)async{

    await FirebaseFirestore.instance.collection("chats").doc(chatId).set({});

  }

  static Stream<List<MessageModel>> getMessages(String chatId){

    final snapshot = FirebaseFirestore.instance.collection("chats").doc(chatId).collection("messages").snapshots();

    final model = snapshot.map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.data());
      }).toList();
    });

    return model;

  }

  static Future<void> sendMessage(String chatId, MessageModel model)async{
    
    await FirebaseFirestore.instance.collection("chats").doc(chatId).collection("messages").
    doc(model.id).set(model.toMap());

  }


}