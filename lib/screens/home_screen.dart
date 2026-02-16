import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/gemini_service.dart';
import 'package:chat_app/view_model/view_model.dart';
import 'package:chat_app/widgets/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // GeminiService.sendMessageToGemini("Who is elon musk");
    ChatService.fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        foregroundColor: Colors.white,
        toolbarHeight: 100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16)
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Whatsapp",),
            const SizedBox(height: 10,),
            ValueListenableBuilder(
              valueListenable: vm.users,
              builder: (context, value, child) {
                return Text("${vm.users.value.length} users available",style: TextStyle(color: Colors.grey.shade400,fontSize: 14),);
              }
            )
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: vm.users,
        builder:(context, value, child) {
          return ListView.separated(
          padding: EdgeInsets.only(top: 30),
          itemCount: vm.users.value.length + 1,
          separatorBuilder: (context, index) {
            return SizedBox(height: 12,);
          },
          itemBuilder:(context, index) {

            if(index == 0){
              return GestureDetector(
                onTap: () async{
                  await ChatService.createChatWithBot();
                  Navigator.push(context, MaterialPageRoute(builder:(context) => ChatScreen(chatId: "_gemini_${FirebaseAuth.instance.currentUser!.uid}"),));

                },
                child: UserCard(model: null)
                );
            }


            final model = vm.users.value[index - 1];
            return GestureDetector(
              onTap: () async{
                
                //Generate chatId
                final chatId = ChatService.generateChatId(model.id);

                //Check if chatId already exists
                final doesExist = await ChatService.checkIfChatExists(chatId);

                if(doesExist){
                  print("Chat already exists");
                }
                //If no --> Create new chat then navigate
                else{
                  print("Creating new chat");
                  //Create chat
                  await ChatService.createNewChat(chatId);
                }

                Navigator.push(context, MaterialPageRoute(builder:(context) => 
                ChatScreen(
                  chatId: chatId,
                  userModel: model,
                ),)); 

              },
              child: UserCard(
                model: model,
              ),
            );
          },
          );
        } 
      )
    );
  }
}