import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


//Specify which stream to listen to

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.chatId,required this.userModel});

  final String chatId;
  final UserModel userModel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();

  late Stream<List<MessageModel>> messages;
  
  @override
  void initState() {
    messages = ChatService.getMessages(widget.chatId);
    messages.listen((data){
      print("new meesages");
      print(data.length);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Chat id: ${widget.chatId}");
    return Scaffold(
      backgroundColor:  AppColors.chatBackground, 
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppColors.appBarBackground, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    "username",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Online",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,color: Colors.white,))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: messages,
              builder:(context, snapshot) {
                if(snapshot.hasData){
                  return  ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                      isMe: true,
                      model: snapshot.data![index],
                      );
                  },
              );
                }
                else if(snapshot.hasError){
                  Center(
                    child: Text("Couldn't fetch messages"),
                  );
                }else if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SizedBox();
                
              }
            )
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    cursorColor: AppColors.appBarBackground,
                    decoration: InputDecoration(
                      hintText: "Enter message",
                      enabledBorder: OutlineInputBorder( 
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade300,), 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade500,), 
                      ),
                      prefixIcon:   IconButton(
                        onPressed: (){},
                          icon: Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.grey.shade600,
                          ),
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          onPressed: (){},
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.grey.shade600,
                          ),
                        )
                        ],
                      )
                    ),

                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF075E54), // WhatsApp green
                  ),
                  child: IconButton(
                    onPressed: () async {

                        final model = MessageModel(
                          id: UniqueKey().toString(),
                          message: messageController.text,
                          senderId: FirebaseAuth.instance.currentUser!.uid,
                          senderName: widget.userModel.userName,
                          createdAt: DateTime.now()
                        );
                        //Insert chatmodel to firebase

                        await ChatService.sendMessage(widget.chatId, model);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}