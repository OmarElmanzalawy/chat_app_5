import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  static Future<bool> checkIfUserVerified()async{

    final user = FirebaseAuth.instance.currentUser!;

    user.reload();

    return user.emailVerified;

  }

  static Future<void> sendVerificationEmail()async{

    await FirebaseAuth.instance.currentUser!.sendEmailVerification();

  }

  static Future<void> sendResetEmail(String email)async{

    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

  }

  static Future<void> createUser(String email, String password, String userName)async{

    try{

    final newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

    await newUser.user!.updateDisplayName(userName);

    await sendVerificationEmail();

    }catch(e){
      print("An error happened while signing up");
      print(e.toString());
    }

  }

  static Future<void> loginUser(String email, String password)async{

    try{

      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

    }catch(e){
      print("An error while signing in");
      print(e.toString());
    }

  }

  


}