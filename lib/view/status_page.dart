import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_chat_app/provider/auth_provider.dart';
import 'package:new_chat_app/view/auth_page.dart';
import 'package:new_chat_app/view/home_page.dart';


class StatusPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(
          builder: (context, ref, child) {
            final authData = ref.watch(authStream);
            return authData.when(
                data: (data){
                  if(data == null){
                    return AuthPage();
                  } else{
                    return HomePage();
                  }
                },
                error: (err, stack) => Center(child: Text('$err')),
                loading: () => Center(child: CircularProgressIndicator()) ,
            );
          }
        )
    );
  }
}
