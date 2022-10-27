import 'package:eg_reach/provider/auth_provider.dart';
import 'package:eg_reach/provider/crud_provider.dart';
import 'package:eg_reach/view/create_page.dart';
import 'package:eg_reach/view/edit_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class HomePage extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ref) {
    final userData = ref.watch(singleUserStream);
    final usersData = ref.watch(allUserStream);
    final postData = ref.watch(postStream);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    late types.User currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      drawer: Drawer(
        child: userData.when(
            data: (data){
              currentUser = data;
              return ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(data.imageUrl!), fit: BoxFit.cover)
                    ),
                      child: Text(data.firstName!)
                  ),
                  ListTile(
                    leading: Icon(Icons.mail),
                    title: Text(data.metadata!['email']),
                  ),
                  ListTile(
                    leading: Icon(Icons.add_box_outlined),
                    title: Text('Create Post'),
                    onTap: () {
                      Get.to(CreatePage(), transition: Transition.leftToRight);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Log out', style: TextStyle(fontSize: 16,),),
                    onTap: (){
                      Navigator.of(context).pop();
                      ref.read(authProvider).userLogout();
                    },
                  ),
                ],
              );
            },
            error: (err, stack) => Text('$err'),
            loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            height: 120,

            child: usersData.when(
                data: (data){
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(data[index].imageUrl!),
                                maxRadius: 40,
                              ),
                            ),
                            Text(data[index].firstName!, style: TextStyle(fontSize: 18),),
                          ],
                        );
                      },
                  );
                },
                error: (err, stack) => Center(child: Text('$err'),),
                loading: () => Container()
            ),
          ),

          Expanded(
              child: postData.when(
                  data: (data){
                    return ListView.builder(
                      itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              height: 420,
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text(data[index].title, maxLines: 1, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),)),
                                      if(uid == data[index].userId) IconButton(
                                          onPressed: (){
                                            Get.defaultDialog(
                                              title: 'Customize',
                                              content: Text('Edit or Remove the post'),
                                              actions: [
                                                IconButton(onPressed: (){
                                                  Navigator.of(context).pop();
                                                  Get.to(EditPage(data[index]), transition: Transition.leftToRight);
                                                }, icon: Icon(Icons.edit)),
                                                IconButton(onPressed: (){
                                                  Get.defaultDialog(
                                                      title: 'Hold On',
                                                      content: Text('Are you sure you want to remove post'),
                                                      actions: [
                                                        TextButton(onPressed: (){
                                                          ref.read(crudProvider).removePost(
                                                              postId: data[index].id,
                                                              imageId: data[index].imageId
                                                          );
                                                          Navigator.of(context).pop();
                                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                  duration: Duration(milliseconds: 700),
                                                                  content: Text('Successfully deleted the post!'))
                                                          );
                                                        }, child: Text('Yes')),
                                                        TextButton(onPressed: (){
                                                          Get.back();
                                                        }, child: Text('No')),
                                                      ]
                                                  );
                                                }, icon: Icon(Icons.delete))
                                              ]
                                            );
                                          },
                                          icon: Icon(Icons.more_horiz_outlined)
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15,),
                                  Image.network(data[index].imageUrl,
                                    height: 250,
                                    width: double.infinity,
                                  ),
                                  SizedBox(height: 10,),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if(uid != data[index].userId) Row(
                                            children: [
                                              IconButton(
                                                  onPressed: (){
                                                    if(data[index].like.usernames.contains(currentUser.firstName)){
                                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                              duration: Duration(milliseconds: 700),
                                                              content: Text('you\'ve already like this post'))
                                                      );
                                                    }else{
                                                      ref.read(crudProvider).likePost(
                                                          like: data[index].like.likes,
                                                          postId: data[index].id,
                                                          usernames: [...data[index].like.usernames,currentUser.firstName! ]
                                                      );
                                                    }

                                                  }, icon: Icon(CupertinoIcons.heart)
                                              ),
                                              Text(data[index].like.likes != 0 ?'${data[index].like.likes}': '')
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Text(data[index].detail, maxLines: 1, style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                    );
                  },
                  error: (err, stack) => Center(child: Text('$err'),),
                  loading: () => Center(child: CircularProgressIndicator()),
              )
          )

        ],
      ),
    );
  }
}
