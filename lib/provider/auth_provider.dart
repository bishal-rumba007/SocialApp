import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

final authStream = StreamProvider.autoDispose((ref) => FirebaseAuth.instance.authStateChanges());
final authProvider = Provider((ref) => AuthProvider());

class AuthProvider{

  Future<String> userSignup({required String username, required String email, required String password, required XFile image}) async{

    try{
      final imageId = DateTime.now().toString();
      final ref = FirebaseStorage.instance.ref().child('$imageId');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: username,
          id: credential.user!.uid,
          imageUrl: url,
          metadata: {
            'email': email
          }
        ),
      );

      return 'success';
    } on FirebaseAuthException catch(err){
      return '${err.message}';
    }
  }




  Future<String> userLogin({required String email, required String password}) async{

    try{
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      return 'success';
    } on FirebaseAuthException catch(err){
      return '${err.message}';
    }
  }


  Future<String> userLoginAnonymously() async{
    try{
      final credential = await FirebaseAuth.instance.signInAnonymously();

      return 'success';
    } on FirebaseAuthException catch(err){
      return '${err.message}';
    }
  }

  Future<String> userLogout() async{

    try{
      final credential = await FirebaseAuth.instance.signOut();

      return 'success';
    } on FirebaseAuthException catch(err){
      return '${err.message}';
    }
  }

}