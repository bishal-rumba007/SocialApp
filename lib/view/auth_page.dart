import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../provider/auth_provider.dart';
import '../provider/toggle.dart';



class AuthPage extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff36EEE0),
        body: Consumer(
            builder: (context, ref, child) {
              final isLogin = ref.watch(loginProvider);
              final image = ref.watch(imageProvider);
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _form,
                    child: ListView(
                      children: [
                        SizedBox(height: 50,),
                        Text('Welcome',
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Poppins',

                            )
                        ),
                        Text(isLogin == true ? 'Fill up the credential to Sign in' : 'Fill up the credential to Sign Up',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                              fontSize: 14
                          ),
                        ),
                        SizedBox(height: 30,),
                        if(isLogin == false)   TextFormField(
                          controller: nameController,
                          validator: (val){
                            if(val!.isEmpty){
                              return 'please provide username';
                            }else if(val.length > 15){
                              return 'maximum character is 15';

                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Username',
                              hintStyle: TextStyle(
                                  color: Color(0xff4C5270)
                              ),
                              prefixIcon: Icon(Icons.person),
                              prefixIconColor: Color(0xff4C5270),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              )
                          ),
                        ),
                        SizedBox(height: 15,),
                        TextFormField(
                          validator: (val){
                            if(val!.isEmpty){
                              return 'email required';
                            }else if(!val.contains('@')){
                              return 'please provide valid email';

                            }
                            return null;
                          },
                          controller: mailController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                  color: Color(0xff4C5270)
                              ),
                              prefixIcon: Icon(Icons.mail),
                              prefixIconColor: Color(0xff4C5270),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)
                              )
                          ),
                        ),
                        SizedBox(height: 15,),
                        TextFormField(
                          obscureText: true,
                          validator: (val){
                            if(val!.isEmpty){
                              return 'password required';
                            }else if(val.length > 15){
                              return 'maximum character is 15';
                            }
                            return null;
                          },
                          controller: passController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Password',
                              hintStyle: TextStyle(
                              color: Color(0xff4C5270)
                            ),
                            prefixIcon: Icon(Icons.key),
                            prefixIconColor: Color(0xff4C5270),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            )
                          ),
                        ),

                        SizedBox(height: 15,),

                        if(isLogin == false)  InkWell(
                          onTap: (){
                            ref.read(imageProvider.notifier).pickImage();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.white,
                              child: image == null ?Center(child: Text('please select an image')) : Image.file(File(image.path)),
                            ),
                          ),
                        ),

                        SizedBox(height: 30,),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xfff652a0),
                            minimumSize: Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            )
                          ),
                            onPressed: () async{
                              _form.currentState!.save();
                              if(_form.currentState!.validate()){
                                if(isLogin){
                                  final response = await ref.read(authProvider).userLogin(
                                    email: mailController.text.trim(),
                                    password: passController.text.trim(),
                                  );

                                  // final response = await ref.read(authProvider).userLoginAnonymously();
                                  if(response != 'success'){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(milliseconds: 1500) , content: Text(response)));
                                  }
                                } else{
                                  if(image == null){
                                    Get.defaultDialog(
                                        titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,),
                                        title: 'Image required',
                                        content: Text('Please select an image for your profile!'),
                                        actions: [
                                          TextButton(
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('close', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),)
                                          )
                                        ]
                                    );
                                  } else{
                                    final response = await ref.read(authProvider).userSignup(
                                      username: nameController.text.trim(),
                                      email: mailController.text.trim(),
                                      password: passController.text.trim(),
                                      image: image,
                                    );

                                    if(response != 'success'){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(milliseconds: 1500) , content: Text(response)));
                                    }
                                  }
                                }
                                
                              }
                              
                            }, child: Text('Submit', style: TextStyle( fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500) ,)
                        ),
                        SizedBox(height: 30,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(isLogin == true ? 'Don\'t have an account ?' : 'Already Have an account',),
                            TextButton(onPressed: (){
                              ref.read(loginProvider.notifier).toggle();
                            }, child: Text(isLogin == true ? 'Sign Up' : 'Login', style: TextStyle(color: Color(0xfff652a0)),))
                          ],
                        )

                      ],
                    ),
                  ),
                ),
              );
            }
        )
    );
  }
}
