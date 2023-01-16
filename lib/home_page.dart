import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'auth_server.dart';

import 'mainpage.dart';
import 'main.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage>{

  int old_user_or_not=0;

  Check_old_user()async{
    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child("Gioruno");
    final snap=await dbref.get();
    if(snap.exists){
      print("account exist");
    }else{
    print("account not exist");
    } 
  }

  @override
  void initState() {
    print("Home_page initializing");
    // TODO: implement initState
    super.initState();
    Check_old_user();
  }

  @override
  Widget build(BuildContext context){
    print("old_user_or_not=${old_user_or_not}");
    // if(old_user_or_not==0){
    //   return Sign_in_Page();//return Sign_in Page;
    // }else{
    //   return DefaultTabController(length: 2, child: MyHomePage(title: 'My Casino'));
    // }
    return DefaultTabController(length: 2, child: MyHomePage(title: 'My Casino'));
     
  }
}

class Sign_in_Page extends StatelessWidget{

  // String email;
  // Sign_in_Page({required email});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.purple,);
  }
}

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   //String? user = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.displayName;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[

//             Text(
//               FirebaseAuth.instance.currentUser!.displayName!,
//               style: const TextStyle(
//                   fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Text(
//               FirebaseAuth.instance.currentUser!.email!,
//               style: const TextStyle(
//                   fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             MaterialButton(
//               padding: const EdgeInsets.all(10),
//               color: Colors.green,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//               child: const Text(
//                 'LOG OUT',
//                 style: TextStyle(color: Colors.white, fontSize: 15),
//               ),
//               onPressed: () {
//                 AuthService().signOut();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }