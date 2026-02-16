import 'dart:convert';

import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static Future<void> sendMessageToGemini(String message, String chatId) async {
    final apiKey = dotenv.env["GEMINI_KEY"];
    final String endPoint = "https://openrouter.ai/api/v1/chat/completions";

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey",
    };

    final Map<String, dynamic> body = {
      "model": "google/gemini-2.5-flash-lite",
      "messages": [
        {
          "role": "user",
          "content": [
            {"type": "text", "text": message},
          ],
        },
      ],
    };

    final uri = Uri.parse(endPoint);

    final respose = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body)
    );


    // print(respose.body);

    if(respose.statusCode == 200){

      final decodedMap = jsonDecode(respose.body);

      // print(decodedMap.runtimeType);

      final responseText = decodedMap["choices"][0]["message"]["content"];

      print(responseText);

      //Insert to firestore

      final model = MessageModel(
        id: UniqueKey().toString(),
         message: responseText,
        senderId: "_gemini_",
        senderName: "Gemini",
        createdAt: DateTime.now()
        );

      await FirebaseFirestore.instance.collection("chats").doc(chatId).collection("messages").doc(model.id).set(model.toMap());

    }


  }
}
