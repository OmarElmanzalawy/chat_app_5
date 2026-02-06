import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/view_model/view_model.dart';
import 'package:chat_app/widgets/user_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
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
            Text("3 users available",style: TextStyle(color: Colors.grey.shade400,fontSize: 14),)
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: vm.users,
        builder:(context, value, child) {
          return ListView.separated(
          padding: EdgeInsets.only(top: 30),
          itemCount: vm.users.value.length,
          separatorBuilder: (context, index) {
            return SizedBox(height: 12,);
          },
          itemBuilder:(context, index) {
            return UserCard();
          },
          );
        } 
      )
    );
  }
}