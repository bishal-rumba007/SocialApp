import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../models/post.dart';
import '../provider/auth_provider.dart';
import '../provider/crud_provider.dart';
import '../provider/toggle.dart';

class EditPage extends StatelessWidget {
  final Post post;
  EditPage(this.post);

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
                        Text('Edit Post', style: TextStyle(fontSize: 17),),
                        SizedBox(height: 25,),
                        TextFormField(
                          controller:titleController..text = post.title,
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
                          controller: detailController..text = post.detail,
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
                            child: image == null ? Image.network(post.imageUrl) : Image.file(File(image.path)),
                          ),
                        ),
                        SizedBox(height: 15,),
                        ElevatedButton(
                            onPressed: () async{
                              _form.currentState!.save();
                              if(_form.currentState!.validate()){

                                if(image ==  null){
                                  final response = await ref.read(crudProvider).updatePost(
                                      title: titleController.text.trim(),
                                      detail: detailController.text.trim(),
                                      postId: post.id
                                  );
                                    if(response != 'success'){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              duration: Duration(milliseconds: 1500),
                                              content: Text(response)
                                          )
                                      );
                                    } else{
                                      Get.back();
                                    }

                                } else{
                                  final response = await ref.read(crudProvider).updatePost(
                                      title: titleController.text.trim(),
                                      detail: detailController.text.trim(),
                                      postId: post.id,
                                      image: image,
                                      imageId: post.imageId
                                  );
                                  if(response != 'success'){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration: Duration(milliseconds: 1500),
                                            content: Text(response)
                                        )
                                    );
                                  } else{
                                    Get.back();
                                  }
                                 }
                              }
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



