import 'package:firebase/Pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'main.dart';
import 'common_data.dart';

class Price{
  final String name ;
  final int money ;
  int number;
  Price({this.name='default', this.money=0,this.number=0});
}

class Change_Title extends StatefulWidget{
  @override
   State<Change_Title> createState() => _Change_Title();
}

// class _Change_Title extends State<Change_Title>{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Container(color: Colors.purple,);
//   }
// }

class _Change_Title extends State<Change_Title>{

 //List shopping_list_title=[];
  List shopping_list_title=[];
  int choosed_title=0;

  @override
  void initState() {
    // TODO: implement initState
     choose_for_which_title();
    read_user_data();
  }


  read_user_data()async{
    DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_Own").child(global_email).child("title");
    final snap=await dbref4.get();
    if(snap.exists){
      shopping_list_title=[];
      dynamic get=snap.value;
      get.forEach(
        (key,value){
          if(key!="Default"){
            // print("key=${key}");
            shopping_list_title.add(Price(number:  int.parse(key),name: value["name"]));
          }
        }
      );
      shopping_list_title.sort((a, b) => a.number.compareTo(b.number));
      setState(() {
        
      });
    }
  }

  choose_for_which_title()async{
    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
    final snap=await dbref.get();
    if(snap.exists){
      dynamic get=snap.value;
      print("get=${get}");
      String temp_title=get["user_title"];
      for(int i=0;i<common_data.title_table.length;i++){
          if(temp_title==common_data.title_table[i]){
            choosed_title=i;
          }
      }
      print("choosed_title=${choosed_title}");
      setState(() {
        
      });
    }
  }

    @override
  Widget build(BuildContext context) {

    // TODO: implement build
      return Scaffold(
        appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        // automaticallyImplyLeading: false,
        backgroundColor: Pallete.backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: () {
          // print("咖哩拌飯");
          Navigator.pop(context,"咖哩拌飯");
        },),
        title: const Text(
          "更改稱號",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        )
      ),
        body: 
      
      ListView.builder( 
        itemCount: shopping_list_title.length,
        itemBuilder: (context, index) {
          return Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey,width: 1))),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    Container(width: 50,child: Text("NO.${shopping_list_title[index].number}")),
                    Container(width: 120,child: Text(shopping_list_title[index].name,style: TextStyle(color: Colors.blueAccent),)),
                      
                  ],),
                ) ,
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: choosed_title==shopping_list_title[index].number? Colors.green:Pallete.commentColor),
                  child: choosed_title==shopping_list_title[index].number? Text("目前選擇"):Text("選取更換"),
                  onPressed: () async{
                    if(choosed_title==shopping_list_title[index].number){
                      print("You have already choose it");
                    }else{
                      choosed_title=shopping_list_title[index].number;
                      DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                      await dbref.update(
                        {
                            "user_title":common_data.title_table[shopping_list_title[index].number]
                        }
                      );
                      setState(() {
                        
                      });
                    }
                  },
                ),
           ),
            );
        },
      ));
  }
}