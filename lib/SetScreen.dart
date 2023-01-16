import 'package:firebase/Change_Title.dart';
import 'package:firebase/Change_profile.dart';
import 'package:flutter/material.dart';
import 'Pallete.dart';
import 'main.dart';
import 'auth_server.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:restart_app/restart_app.dart';

class SetScreen extends StatefulWidget{
  @override
  State<SetScreen> createState() => _SetScreen();
}

class _SetScreen extends State<SetScreen> {
  int input_ok=-1;
  List user_data=["default","default",0];
  int log_out=0;

  int accumulative=0;
  int check_in_state=0;
  DateTime Last_Check_Time=DateTime.now();

  String Change_to_2(String number){
    if(number.length==2){
      return number;
    }else return "0"+number;
  }

  check_check_in_button()async{
    // print("start check checkin");
   

    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
    final snap=await dbref.get();
    if(snap.exists){
      dynamic get=snap.value;
      String Last_Check_Time_String=get["last_check_in"].toString();
        Last_Check_Time=DateTime.utc(int.parse(Last_Check_Time_String.substring(0, 4)),int.parse(Last_Check_Time_String.substring(4, 6)),int.parse(Last_Check_Time_String.substring(6, 8)),0,0,0);
        Last_Check_Time = Last_Check_Time.add(Duration(days: 1));

        print("Last_Check_Time=${Last_Check_Time}");
        print("Now=${DateTime.now().add(Duration(hours:8))}");

         if(DateTime.now().add(Duration(hours:8)).isAfter(Last_Check_Time)){
          // print("You can check in now");
          check_in_state=1;
        }
         if(check_in_state==0){
          accumulative=0;
        }
        print("check_in_state=${check_in_state}");
    }
  }

  Future<void> Log_out(BuildContext context) {
    return showDialog<void>(context:context,builder:(context) {
      return AlertDialog(
        title: Text("確定要登出?"),
        actions: [
            ElevatedButton(
              child: Text('取消', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop("cancel");
              },
            ),
            ElevatedButton(
              child: Text('確定', style: TextStyle(color: Colors.white)),
              onPressed: () {
                log_out=1;
                Navigator.of(context).pop("cancel");
              },
            ),
        ],
      );
    });
  }

Future<void> day_error(BuildContext context) {
    return showDialog<void>(context:context,builder:(context) {
      return AlertDialog(
        title: Text("您今日已經簽到過了"),
        content: Text("請到明日00:00再進行簽到"),
        actions: [
            ElevatedButton(
            child: Text('取消', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop("cancel");
            },
          ),
        ],
      );
    });
  }
  

  Future<void> revise_the_name(BuildContext context) {
    return showDialog<void>(context:context,builder:(context) {
      TextEditingController name_input = TextEditingController();
      int money=0;
    

      return AlertDialog(
        title: Text("更改暱稱"),
        content:TextField(
          controller: name_input,
          decoration: InputDecoration(
            hintText: "輸入名稱請介於 1~7 個字",
            // enabledBorder: UnderlineInputBorder( //<-- SEE HERE
            //   borderSide: BorderSide(
            //     width: 3, color: input_ok==0? Colors.grey:Colors.red), 
            // ),
            focusedBorder: UnderlineInputBorder( //<-- SEE HERE
              borderSide: BorderSide(
                width: 3, color:input_ok==0? Colors.grey:Colors.grey), 
            ),
            // helperText: input_ok==0? null: "輸入長度請介於1~7個字",
            // helperStyle: TextStyle(color: Colors.red,)                    
          )
          ,onChanged: (value) { 
            print("value.length=${value.length}");
            print("input_ok=${input_ok}");
            if(value.length==0){
              print("You speak too little");
              input_ok=-1;
            }else if(value.length>=8){
              print("You speak too much");
              input_ok=-1;
            }else input_ok=0;
            setState(() {
                              
            });
          },
        ),
        actions: [
           ElevatedButton(
            child: Text('取消', style: TextStyle(color: Colors.white)),
            onPressed: () {
              print("input_ok=${input_ok}");
              Navigator.of(context).pop("cancel");
            },
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: input_ok==0? Colors.green:Colors.green
              ),
              child: Text('確定'),
              onPressed: ()async{
                print("input_ok=${input_ok}");
                if(input_ok!=0){
                  print("You input null");
                }
                else{
                  DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                    await dbref.update(
                        {
                          "user_name": name_input.text
                        }
                    );
                  }
                  Navigator.pop(context);
                peep_user();
                
                  
              },
            ),
        ],
      );
    }, );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    peep_user();
  }

  void peep_user()async{
    DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Gambling_Users").child(global_email);
    // await dbref4.onValue.listen((event) {
    //     // print("read_user_data");
    //     dynamic get=event.snapshot.value;
    //     user_data=[];
    //     user_data.add(get["user_title"]);
    //     user_data.add(get["user_name"]);
    //     user_data.add(get["profile"]);
    //     setState(() {
          
    //     });
    //     print("In Personal_Page, reading personal_information");
    // });
    final snap=await dbref4.get();
    if(snap.exists){
      user_data=[];
      dynamic get=snap.value;
      print("In Personal Page,get=${get}");
      user_data.add(get["user_title"]);
      user_data.add(get["user_name"]);
      user_data.add(get["profile"]);
      setState(() {
        
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    // peep_user();
    check_check_in_button();
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
          "帳戶設置",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(padding: EdgeInsets.all(7)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                          child: Container(
                            height: 60,
                            width: 60,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset("photos/profile_"+user_data[2].toString()+".png", //change!!
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                             Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                              child: Text(
                                "歡迎，${user_data[0]}", //change!!
                              textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children:  [
                                // Text(
                                //   user_data[0],
                                //   textAlign: TextAlign.start,
                                //   overflow: TextOverflow.clip,
                                //   style: TextStyle(
                                //     fontWeight: FontWeight.w500,
                                //     fontStyle: FontStyle.normal,
                                //     fontSize: 15,
                                //     color: Colors.white,
                                //   ),
                                // ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      4, 0, 0, 0),
                                  child: Text(
                                    user_data[1], //change!!
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 17,
                                      color: Pallete.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // const Padding(
                            //   padding:
                            //       EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                            //   child: Text(
                            //     "Your latest updates are below.", //change!!
                            //     textAlign: TextAlign.start,
                            //     overflow: TextOverflow.clip,
                            //     style: TextStyle(
                            //       fontWeight: FontWeight.w400,
                            //       fontStyle: FontStyle.normal,
                            //       fontSize: 14,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(12)),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.44,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Pallete.cardColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextButton(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Center(
                                      child: Icon(
                                        Icons.attach_money,
                                        color: Pallete.commentBgColor,
                                        size: 45,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 10, 0, 0),
                                      child: Text(
                                        "收支紀錄",
                                        style: TextStyle(
                                          color: Pallete.commentBgColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/History_Page");
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.44,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Pallete.cardColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextButton(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Center(
                                      child: Icon(
                                        Icons.location_history_sharp,
                                        color: Pallete.commentBgColor,
                                        size: 45,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 10, 0, 0),
                                      child: Text(
                                        "更改暱稱",
                                        style: TextStyle(
                                          color: Pallete.commentBgColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  
                                  revise_the_name(context);
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.44,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Pallete.cardColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextButton(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Center(
                                      child: Icon(
                                        Icons.theater_comedy,
                                        color: Pallete.commentBgColor,
                                        size: 45,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 10, 0, 0),
                                      child: Text(
                                        "更換稱號",
                                        style: TextStyle(
                                          color: Pallete.commentBgColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () async{
                                  // Navigator.pushNamed(context, "/Change_title");
                                  // remember to set state after back
                                   String ?resultData = await Navigator.push(context,
                                      MaterialPageRoute(builder:(BuildContext context) {
                                        return Change_Title(); 
                                      }) 
                                    );
                                    if(resultData!=null){
                                      peep_user();
                                      // setState(() {
                                        
                                      // });
                                   }
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.44,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Pallete.cardColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextButton(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Center(
                                      child: Icon(
                                        Icons.supervised_user_circle_rounded,
                                        color: Pallete.commentBgColor,
                                        size: 45,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 10, 0, 0),
                                      child: Text(
                                        "設定頭像",
                                        style: TextStyle(
                                          color: Pallete.commentBgColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: ()async {
                                  // Navigator.pushNamed(context, "/Change_profile");
                                  String ?resultData = await Navigator.push(context,
                                      MaterialPageRoute(builder:(BuildContext context) {
                                        return Change_Profile(); 
                                      }) 
                                    );
                                    if(resultData!=null){
                                      peep_user();
                                      // setState(() {
                                        
                                      // });
                                   }
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.44,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Pallete.cardColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextButton(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Center(
                                      child: Icon(
                                        Icons.theater_comedy,
                                        color: Pallete.commentBgColor,
                                        size: 45,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 10, 0, 0),
                                      child: Text(
                                        "登出",
                                        style: TextStyle(
                                          color: Pallete.commentBgColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () async{
                                  
                                  
                                   await Log_out(context); 
                                  print("log_out=${log_out}");
                                  if(log_out==1){
                                    if(isfaker!=1){
                                      print("Iam not faker");
                                      GoogleSignIn _googleSignIn = GoogleSignIn();
                                      await _googleSignIn.disconnect();
                                      await AuthService().signOut();
                                    }
                                    
                                    print("start to pop");
                                   
                                    if(account_exist==1){ //new user

                                      // Navigator.pop(context,"NAK");
                                      if(isfaker!=1){
                                        account_exist=0;
                                      } 
                                      Restart.restartApp();
                                      // Navigator.pushNamed(context, "/Login_page");
                                    }else{
                                      // Restart.restartApp();
                                       Navigator.pop(context);
                                    }
                                    
                                    
                                    
                                    //User user = FirebaseAuth.instance.currentUser; 
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.44,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Pallete.cardColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextButton(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Center(
                                      child: Icon(
                                        Icons.event_available,
                                        color: check_in_state==0? Pallete.commentBgColor : Colors.green,
                                        size: 45,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 10, 0, 0),
                                      child: Text(
                                        "每日簽到",
                                        style: TextStyle(
                                          color: check_in_state==0? Pallete.commentBgColor : Colors.green,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () async{
                                     int money_now=0;
                  if(check_in_state==1&&accumulative==0){
                    check_in_state=0;
                    accumulative=1;
                    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                    final snap=await dbref.get();
                    if(snap.exists){
                      dynamic get=snap.value;
                      money_now=get["user_money"];
                      print("peep, money_now=${money_now}");
                    }
                    // await dbref.onValue.listen((event) {
                    //   dynamic get=event.snapshot.value;
                    //   money_now=get["user_money"];
                    //   print("peep, money_now=${money_now}");
                    // });
                    await dbref.update(
                        {
                          "user_money":money_now+5000
                        }
                    );
                    print("set done user money");
                    
                    DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                    DateTime now_time=DateTime.now().add(Duration(hours: 8));
                     String now_time_string=now_time.year.toString()+Change_to_2(now_time.month.toString())+Change_to_2(now_time.day.toString())+Change_to_2(now_time.hour.toString())+Change_to_2(now_time.minute.toString())+Change_to_2(now_time.second.toString());
                    await dbref2.update(
                      {
                        "last_check_in":now_time_string
                      }
                    );
                    
                    print("check_in_state=${check_in_state}");

 
                    DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Users_History/").child(global_email).child("C"+now_time_string);
                    await dbref3.set(
                      {
                        "time":now_time_string,
                        "money":5000,
                        "attribute":0, //0 for add
                        "why":"每日簽到"
                      }
                    );
                    setState(() {
                    
                  });

                  }else{
                    print("You can't check in");
                    day_error(context);
                  }
                  
                  

                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
