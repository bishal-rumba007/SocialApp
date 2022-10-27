import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';
import 'auth_page.dart';
import 'home_page.dart';


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
