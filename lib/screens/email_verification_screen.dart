

import 'dart:async';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> with SingleTickerProviderStateMixin{


  late final Timer timer;
  late AnimationController animationController;
  late Animation<double> iconScale;
  late Animation<double> pulsatingAnimation;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    iconScale = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.elasticOut));
    pulsatingAnimation = Tween(begin: 0.8, end: 1.2).animate(animationController);

    animationController.forward();

    animationController.repeat(reverse: true);

    bool isUserVerified;
     timer = Timer.periodic(Duration(seconds: 3), (_)async{

      isUserVerified = await AuthService.checkIfUserVerified();

      if(isUserVerified){
        //Store user into firestore
        final user = UserModel(
          id: FirebaseAuth.instance.currentUser!.uid,
          userName: FirebaseAuth.instance.currentUser!.displayName!,
          email: FirebaseAuth.instance.currentUser!.email!
          );
       await AuthService.saveUserIntoDatabase(user);
        timer.cancel();
        Navigator.pushAndRemoveUntil(
          context,
           MaterialPageRoute(builder:(context) => HomeScreen(),),
          (routes) => false
          );

      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
          const SizedBox(height: 80),
          
          // Animated email icon container
          ScaleTransition(
            scale: iconScale,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(70),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF25D366).withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: const Icon(
                Icons.mark_email_read_rounded,
                size: 70,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 50),
          
          // Title
          const Text(
            'Check Your Email',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Subtitle
          Text(
            'We\'ve sent a verification link to . Please check your inbox and click the link to verify your account.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
          
          const SizedBox(height: 60),
          
          // Animated progress container
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Animated loading indicator
                ScaleTransition(
                  scale: pulsatingAnimation,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF25D366),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  'Waiting for verification...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  'This may take a few moments',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}