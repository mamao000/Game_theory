import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'main.dart';
import 'team_nba.dart';

import 'Pallete.dart';

class History{
  DateTime time=DateTime.now();
  String why;
  int money;
  int attribute;

  History({this.why="Default",required this.time,this.money=0,this.attribute=1});
}

class HistoryPage extends StatefulWidget{
    @override
  State<HistoryPage> createState() => _HistoryPage();
}

class _HistoryPage extends State<HistoryPage> {

  int show_nothing=0;
  List<History> show_array=[];
  List show_array_color=[Colors.green,Colors.red];

  initState(){
    get_the_history();
  }

  get_the_history()async{ //static
    DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_History").child(global_email);
    final snap=await dbref4.get();
    if(snap.exists){
      show_array=[];
      dynamic get=snap.value;
      // print("In History Page,get=${get}");
      // print("get_length=${get.length}");
      if(get.length==1){ //Only Default
        show_nothing=-1;
      }
      get.forEach(
        (key,value){
          // print("key=${key}");
          if(key!="Default"){
            DateTime this_time=DateTime.utc(int.parse(value["time"].substring(0, 4)),int.parse(value["time"].substring(4, 6)),int.parse(value["time"].substring(6, 8)),int.parse(value["time"].substring(8, 10)),int.parse(value["time"].substring(10, 12)),int.parse(value["time"].substring(12, 14)));
            show_array.add(History(why: value["why"],money: value["money"],time: this_time,attribute: value["attribute"]));
          }
        }
      );
      show_array.sort((a, b) => b.time.compareTo(a.time));
      show_array.forEach((element) {
        print("${element.time}");
      });
      
    }
    setState(() {
        
    });
  }

  @override
  Widget build(BuildContext context) {
    // get_the_history();
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        // automaticallyImplyLeading: false,
        backgroundColor: Pallete.backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "收支紀錄",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),actions: [
           IconButton(onPressed: (){  
            get_the_history();
          }, icon:  Icon(Icons.refresh)),
        ]
      ),
      body: Center(
        child: show_nothing==-1? Text("目前沒有比賽喔"):
        SizedBox(
          width: 0.85* MediaQuery.of(context).size.width,
          child: ListView.builder(itemCount: show_array.length,itemBuilder:(context, index) {
       
                return Container(
                  margin: index==0? EdgeInsets.fromLTRB(0, 25, 0, 7.5) : EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
                  child: Material(
                    color: show_array_color[show_array[index].attribute],
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text("${show_array[index].why}",style: TextStyle(fontSize: 15,color: Colors.white),),
                            Text(" ${show_array[index].money}",style: TextStyle(fontSize: 15,color: Colors.white))
                        ],
                      ),
                    ),
                  ),
                );

          },),
        )
      )
    );
  }
}