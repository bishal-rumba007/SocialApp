import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_chat_app/provider/toggle_provider.dart';


class AuthPage extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: Container(
        child: Consumer(
          builder: (context, ref, child) {
            final isLogin = ref.watch(loginProvider);
            final image = ref.watch(imageProvider);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                child: ListView(
                  children: [
                    Text(isLogin ? 'Login Form' : 'Sign Up Form', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, letterSpacing: 1.5),),
                    SizedBox(height: 30,),

                    if(!isLogin) _buildPadding(hint: 'username'),
                    _buildPadding(hint: 'email', isMail: true),
                    _buildPadding(hint: 'password', isPass: true),

                    SizedBox(height: 15,),

                    if(!isLogin) InkWell(
                      onTap: (){
                        ref.read(imageProvider.notifier).pickImage();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                        ),
                        child: image == null ? Center(child: Text('Please select an image', style: TextStyle(fontSize: 16),)) : Image.file(File(image.path)),
                      ),
                    ),


                    Row(
                      children: [
                        Text(isLogin ? 'Don\'t have an account yet?' : 'Already have an account?'),
                        TextButton(
                          onPressed: (){
                            ref.read(loginProvider.notifier).toggle();
                          },
                            child: Text(isLogin ? 'SignUp' : 'Login')
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Padding _buildPadding({required hint, bool? isPass, bool? isMail}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: TextFormField(
        obscureText: isPass == null ? false : true,
        keyboardType: isMail == null ? TextInputType.text : TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText:  hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          border: OutlineInputBorder(),
          focusColor: Colors.green
        ),
      ),
    );
  }
}
