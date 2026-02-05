import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Reset password"),
            CustomTextField(
              hintText: "Enter your email here",
              labelText: "Email",
              controller: _emailController
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ()async{
                    await AuthService.sendResetEmail(_emailController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("An email has been sent to ${_emailController.text}"))
                    );
                  },
                  child: Text("Send reset email")
                  ),
              )
          ],
        ),
      ),
    );
  }
}