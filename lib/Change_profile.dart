import 'package:firebase/Pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'main.dart';

class Price{
  final String name ;
  final int money ;
  int number;
  Price({this.name='default', this.money=0,this.number=0});
}

class Change_Profile extends StatefulWidget{
  @override
   State<Change_Profile> createState() => _Change_Profile();
}

class _Change_Profile extends State<Change_Profile>{


    List shopping_list_title=[];
    //List shopping_list_title=[Price(name: "levi",number: 0),Price(name: "eran",number: 1)];
    int choosed_title=0;


  read_user_data()async{
    DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_Own").child(global_email).child("profile");
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
    // print("i am here");
    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
    final snap=await dbref.get();
    if(snap.exists){
      dynamic get=snap.value;
      choosed_title=get["profile"];
      print("choosed_title=${choosed_title}");
      setState(() {
        
      });
    }
  }

    @override
  void initState() {
    // TODO: implement initState
    choose_for_which_title();
    read_user_data();
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
          Navigator.pop(context,"咖哩拌飯2");
        },),
        title: const Text(
          "更改頭貼",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        )
      ),
      body: GridView.builder(itemCount:shopping_list_title.length,gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1/1,crossAxisCount:2,mainAxisSpacing: 10,crossAxisSpacing: 5), itemBuilder:(context, index) {
        return 
                          Material(
                            color: shopping_list_title[index].number==choosed_title? Colors.green : Colors.transparent,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.44,
                              height: 150,
                              decoration: BoxDecoration(
                                  // color: Pallete.cardColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextButton(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Center(
                                      child:ClipRRect(borderRadius: BorderRadius.circular(150),child: Image.asset("photos/profile_"+shopping_list_title[index].number.toString()+".png",width: 120,height: 120,))
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 10, 0, 0),
                                      child: Text(
                                        shopping_list_title[index].name,
                                        style: TextStyle(
                                          color: shopping_list_title[index].number==choosed_title? Colors.white: Pallete.backgroundColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () async{
                                  if( shopping_list_title[index].number==choosed_title){
                                    print("You have already choose it");
                                  }else{
                                      choosed_title=shopping_list_title[index].number;
                                       DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                                      await dbref.update(
                                        {
                                          "profile":choosed_title
                                        }
                                      );
                                      setState(() {
                        
                                      });
                                  }
                                },
                              ),
                            ),
                          )
                        ;
      },)
    );
    
  }
}