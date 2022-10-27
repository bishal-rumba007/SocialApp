import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../provider/auth_provider.dart';
import '../provider/crud_provider.dart';
import '../provider/toggle.dart';

class CreatePage extends StatelessWidget {


  final _form = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final detailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(
            builder: (context, ref, child) {
              final image = ref.watch(imageProvider);
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _form,
                    child: ListView(
                      children: [
                        Text('Create Form', style: TextStyle(fontSize: 17),),
                        SizedBox(height: 25,),
                        TextFormField(
                          controller:titleController,
                          validator: (val){
                            if(val!.isEmpty){
                              return 'please provider title';
                            }else if(val.length > 55){
                              return 'maximum character is 55';

                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: 'Title'
                          ),
                        ),
                        SizedBox(height: 15,),
                        TextFormField(
                          validator: (val){
                            if(val!.isEmpty){
                              return 'please provide detail';
                            }
                            return null;
                          },
                          controller: detailController,
                          decoration: InputDecoration(
                              hintText: 'Detail'
                          ),
                        ),

                        SizedBox(height: 15,),
                        InkWell(
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

                                if(image ==  null){
                                  Get.defaultDialog(
                                      title: 'image required',
                                      content: Text('please select an image'),
                                      actions: [
                                        TextButton(onPressed: (){
                                          Navigator.of(context).pop();
                                        }, child: Text('close'))
                                      ]
                                  );
                                }else{
                                  final response = await ref.read(crudProvider).addPost(
                                      title: titleController.text.trim(),
                                      detail: detailController.text.trim(),
                                      userId: FirebaseAuth.instance.currentUser!.uid,
                                      image: image
                                  );
                                  if(response != 'success'){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration: Duration(milliseconds: 1500),
                                            content: Text(response))
                                    );
                                  }else{
                                    Get.back();
                                  }
                                }
                              }
                              Navigator.of(context).pop();
                            }, child: Text('Submit')
                        ),
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



