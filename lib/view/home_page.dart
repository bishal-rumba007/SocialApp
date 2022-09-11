import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_chat_app/provider/auth_provider.dart';


class HomePage extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome user'),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
           ListTile(
             leading: Icon(Icons.logout),
             title: Text('Log out'),
             onTap: (){
               Navigator.of(context).pop();
               ref.read(authProvider).userLogout();
             },
           )
          ],
        ),
      ),
    );
  }
}
