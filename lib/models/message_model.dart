import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {

  final String id;
  final String message;
  final String senderId;
  final String senderName;
  final DateTime createdAt;

 

  //Convert MessageModel to Map (send to firebase)

  Map<String,dynamic> toMap(){

    return {
      "id": id,
      "message": message,
      "senderId": senderId,
      "senderName": senderName,
      "createdAt": createdAt
    };
  }

  //Convert Map to MessageModel (fetch from firebase)

  factory MessageModel.fromMap(Map<String,dynamic> map){
    return MessageModel(
      id: map["id"],
      message: map["message"],
      senderId: map["senderId"],
      senderName: map["senderName"],
      createdAt: (map["createdAt"] as Timestamp).toDate()
    );
  }

  MessageModel({required this.id, required this.message, required this.senderId, required this.senderName, required this.createdAt});



}