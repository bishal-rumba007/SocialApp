import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:new_chat_app/provider/auth_provider.dart';
import 'package:new_chat_app/provider/toggle_provider.dart';




class AuthPage extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(
            builder: (context, ref, child) {
              final isLogin = ref.watch(loginProvider);
              final image = ref.watch(imageProvider);
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _form,
                    child: ListView(
                      children: [
                        Text(isLogin == true ? 'Login Form' : 'Sign Up Form', style: TextStyle(fontSize: 17),),
                        SizedBox(height: 25,),
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
                              hintText: 'Username'
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
                              hintText: 'Email'
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
                          decoration: InputDecoration(
                              hintText: 'Password'
                          ),
                        ),

                        SizedBox(height: 15,),

                        if(isLogin == false)  InkWell(
                          onTap: (){
                            ref.read(imageProvider.notifier).pickImage();
                          },
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            child: image == null ?Center(child: Text('please select an image')) : Image.file(File(image.path)),
                          ),
                        ),

                        SizedBox(height: 15,),

                        ElevatedButton(
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


                            }, child: Text('Submit')
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Text(isLogin == true ? 'Don\t have an account ?' : 'Already Have an account'),
                            TextButton(onPressed: (){
                              ref.read(loginProvider.notifier).toggle();
                            }, child: Text(isLogin == true ? 'Sign Up' : 'Login'))
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

