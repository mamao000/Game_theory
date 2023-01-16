import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';

import 'auth_server.dart';

// class LoginPage extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Container(color: Colors.purple,);
//   }
// }

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  int accumulate=0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Google Login"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(
            left: 20, right: 20, top: size.height * 0.2, bottom: size.height * 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Hello, \nGoogle sign in",
                style: TextStyle(
                    fontSize: 30
                )),
            GestureDetector(
                onTap: () {
                  // print("in the login page, user_list=${user_list}");
                  print("accumulate=${accumulate}");
                  if(accumulate==0){
                    accumulate++;
                    AuthService().signInWithGoogle();
                  }else if(accumulate==2){
                    accumulate=0;
                  }else{
                    accumulate++;
                  }
                  
                },
                child: const Image(width: 100, image: AssetImage('photos/google.png'))),
          ],
        ),
      ),
    );
  }
}