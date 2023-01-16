///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

// Add a selected circle

import 'package:firebase/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase/Pallete.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:firebase/team_nba.dart';

class Comment{
   String user_name;
   String comment;
   DateTime comment_time=DateTime.now();
   int profile;
   String title;
   
   Comment({this.user_name="Default",this.comment="Bla Bla Bla",required pass_time,this.profile=0,this.title="default"}){
      this.comment_time=pass_time;
   }
   
}

class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  String game_folder="Default";
  Game game=Game("Default", "Default", 0.1, 0.1, 0, 0, 0, 0, 0, 0, "Default",DateTime.utc(2002,07,08,10,08,30));
  int vote_for=-1; // read the database 
  int money_drop=0;  // maybe not
  String name = "kira yoshikage";
  DatabaseReference ?dbref;
  int percent1=0;
  int init_state=0;
  int comment_total_number=0;
  
  int check_team1=0;
  int check_team2=0;
  int last_money=0;
  int ready_for_discussion=0;


  // List discussion_user_name=[];
  // List discussion_comment=[];
  List<Comment> comment_list=[];
  List user_data=["default","default",99,0];
  List game_money=[0,0];
  Map whole_app_user={};
  // int comment_number=0;

  TextEditingController the_word=TextEditingController();

  Future<void> input_empty_error(BuildContext context) {
    return showDialog<void>(context:context,builder:(context) {
      return AlertDialog(
        title: Text("輸入金額不可為空"),
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

  Future<void> input_money_error(BuildContext context) {
    return showDialog<void>(context:context,builder:(context) {
      return AlertDialog(
        title: Text("遊戲幣數不夠"),
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

  Future<void> _choose_for_left(BuildContext context,String team) {
    return showDialog<void>(context:context,builder:(context) {
      TextEditingController money_input = TextEditingController();
      int money=0;

      return AlertDialog(
        title: Text("選擇 ${team}"),
        content:TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: "投入金額 (最多 ${user_data[2]})"),
          controller: money_input,
          // onSubmitted: (value) {
          //   print("value ${value}");
          // },  
        ),
        actions: [
          
           ElevatedButton(
            child: Text('取消', style: TextStyle(color: Colors.white)),
            onPressed: () {
              vote_for=-1;
              // print("vote_for=${vote_for},money_drop=${money_drop}");
              
              Navigator.of(context).pop("cancel");
            },
          ),
          ElevatedButton(
              child: Text('確定'),
              onPressed: ()async{
                if(money_input.text.isEmpty||int.parse(money_input.text)<=0){
                  print("You input null");
                  vote_for=-1;
                   Navigator.of(context).pop();
                   input_empty_error(context);
                }else if(int.parse(money_input.text)>user_data[2]){
                  print("You input too much money");
                  vote_for=-1;
                  Navigator.of(context).pop();
                  input_money_error(context);
                }
                else{
                  print("game_folder=${this.game_folder}");
                  if(team==NBATeam.name[game.team1] ){
                    vote_for=0;
                    print(1.0 is double);
                    
                    //revise database
                    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Game_Users/").child(this.game_folder).child(game.team1).child(global_email);
                    await dbref.set(
                        {
                          "money":int.parse(money_input.text)
                        }
                    );

                    DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                    await dbref2.update(
                        {
                          "user_money":user_data[2]-int.parse(money_input.text)
                        }
                    );


                    DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Gambling/").child(game_folder);
                    await dbref3.update(
                        {
                          "dollar1":game.dollar1+int.parse(money_input.text),
                          "people_num1":game.people_num1+1,
                          // "odd1": 25.0
                          "odd1": game.dollar2==0? 1.0 : double.parse((game.dollar2/(game.dollar1+int.parse(money_input.text))).toStringAsFixed(2)),
                          "odd2": game.dollar2==0?  double.parse((game.dollar1+int.parse(money_input.text)).toString()): double.parse(((game.dollar1+int.parse(money_input.text))/game.dollar2).toStringAsFixed(2)),
                        }
                    );

                    DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_History/").child(global_email).child("G"+game_folder);
                    DateTime now_time=DateTime.now().add(Duration(hours: 8));
                    String now_time_string=now_time.year.toString()+Change_to_2(now_time.month.toString())+Change_to_2(now_time.day.toString())+Change_to_2(now_time.hour.toString())+Change_to_2(now_time.minute.toString())+Change_to_2(now_time.second.toString());
                    await dbref4.set(
                      {
                        "time":now_time_string,
                        "money":int.parse(money_input.text),
                        "attribute":1, //0 for add
                        "why":"${NBATeam.name[game.team1] }(選擇) VS ${NBATeam.name[game.team2]}"
                      }
                    );

                  }else{
                    vote_for=1;
                    //revise database
                    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Game_Users/").child(game_folder).child(game.team2).child(global_email);
                    await dbref.set(
                        {
                          "money":int.parse(money_input.text)
                        }
                    );

                    DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                    await dbref2.update(
                        {
                          "user_money":user_data[2]-int.parse(money_input.text)
                        }
                    );

                    DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Gambling/").child(game_folder);
                    await dbref3.update(
                        {
                          "dollar2":game.dollar2+int.parse(money_input.text),
                          "people_num2":game.people_num2+1,
                          "odd1": game.dollar1==0? double.parse((game.dollar2+int.parse(money_input.text)).toString()) : double.parse(((game.dollar2+int.parse(money_input.text))/game.dollar1).toStringAsFixed(2)),
                          "odd2": game.dollar1==0? 1.0 : double.parse(((game.dollar1)/(game.dollar2+int.parse(money_input.text))).toStringAsFixed(2)),
                        }
                    );

                    DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_History/").child(global_email).child("G"+game_folder);
                    DateTime now_time=DateTime.now().add(Duration(hours: 8));
                    String now_time_string=now_time.year.toString()+Change_to_2(now_time.month.toString())+Change_to_2(now_time.day.toString())+Change_to_2(now_time.hour.toString())+Change_to_2(now_time.minute.toString())+Change_to_2(now_time.second.toString());
                    
                    await dbref4.set(
                      {
                        "time":now_time_string,
                        "money":int.parse(money_input.text),
                        "attribute":1, //0 for add
                        "why":"${NBATeam.name[game.team1]} VS ${NBATeam.name[game.team2]}(選擇)"
                      }
                    );
                  }
                  money_drop=int.parse(money_input.text);
                  print("vote_for=${vote_for},money_drop=${money_drop}");
                   Navigator.of(context).pop();
                }
               
              },
            ),
        ],
      );
    }, );
  }
  Future<void> _revise_money_drop(BuildContext context,String team) {
    return showDialog<void>(context:context,builder:(context) {
      TextEditingController money_input = TextEditingController();
      int money=0;

      return AlertDialog(
        title: Text("${team} : 更改金額"),
        content:SizedBox(
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "投入金額 (最多${user_data[2]+last_money})"), //(money range)
                controller: money_input,
                // onSubmitted: (value) {
                //   print("value ${value}");
                // },  
              ),
              Container(margin: EdgeInsets.only(top: 30),child: Text("原本投注 : ${last_money}",textAlign: TextAlign.left,))
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            child: Text('取消下注', style: TextStyle(color: Colors.white)),
            onPressed: ()async{
              money_drop=0;
              //if team1 else team2
              if(vote_for==0){
                DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Game_Users/").child(this.game_folder).child(game.team1).child(global_email);
                int original_money=0;
                final snap=await dbref.get();
                if(snap.exists){
                  dynamic get=snap.value;
                  original_money=get["money"];
                  await dbref.remove();
                }

                print("original_money=${original_money}");
                
                DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                await dbref2.update(
                  {
                    "user_money":user_data[2]+original_money
                  }
                );
                
                DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Gambling/").child(game_folder);
                    
                if(game.dollar1-original_money==0){
                  await dbref3.update(
                        {
                          "dollar1":game.dollar1-original_money,
                          "people_num1":game.people_num1-1,
                          "odd1": game.dollar2==0? 1.0 : double.parse((game.dollar2/1).toStringAsFixed(2)),
                          "odd2": game.dollar2==0?  1.0: 1.0,
                        }
                    );
                }else{
                  await dbref3.update(
                        {
                          "dollar1":game.dollar1-original_money,
                          "people_num1":game.people_num1-1,
                          "odd1": game.dollar2==0? 1.0 : double.parse((game.dollar2/(game.dollar1-original_money)).toStringAsFixed(2)),
                          "odd2": game.dollar2==0?  double.parse((game.dollar1-original_money).toString()): double.parse(((game.dollar1-original_money)/game.dollar2).toStringAsFixed(2)),
                        }
                    );
                }

                    

                // DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_History/").child(global_email).child("G"+game_folder);
                // await dbref4.remove();
                  
                 
              }else{
                DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Game_Users/").child(this.game_folder).child(game.team2).child(global_email);
                int original_money=0;
                final snap=await dbref.get();
                if(snap.exists){
                  dynamic get=snap.value;
                  original_money=get["money"];
                  await dbref.remove();
                }
                
                DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                await dbref2.update(
                  {
                    "user_money":user_data[2]+original_money
                  }
                );

                DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Gambling/").child(game_folder);
                if(game.dollar2-original_money==0){
                  await dbref3.update(
                    {
                      "dollar2":game.dollar2-original_money,
                      "people_num2":game.people_num2-1,
                      "odd1": game.dollar1==0?  1.0 : 1.0,
                      "odd2": game.dollar1==0? 1.0 : double.parse((game.dollar1/1).toStringAsFixed(2)),
                    }
                  );
                }else{
                  await dbref3.update(
                    {
                      "dollar2":game.dollar2-original_money,
                      "people_num2":game.people_num2-1,
                      "odd1": game.dollar1==0?  double.parse((game.dollar2-original_money).toString()) : double.parse(((game.dollar2-original_money)/game.dollar1).toStringAsFixed(2)),
                      "odd2": game.dollar1==0? 1.0 : double.parse(((game.dollar1)/(game.dollar2-original_money)).toStringAsFixed(2)),
                    }
                  );
                }
                
              }
              DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_History/").child(global_email).child("G"+game_folder);
              await dbref4.remove();
              vote_for=-1;
              print("vote_for=${vote_for},money_drop=${money_drop}");
              //revise the database
              
              Navigator.of(context).pop();
            },
          ),
           ElevatedButton(
            child: Text('取消', style: TextStyle(color: Colors.white)),
            onPressed: () {
              print("vote_for=${vote_for},money_drop=${money_drop}");
              Navigator.of(context).pop();
              print("last_money=${last_money}");
            },
          ),
          ElevatedButton(
            child: Text('確定'),
            onPressed: ()async{
              if(money_input.text.isEmpty||int.parse(money_input.text)<=0){
                Navigator.of(context).pop();
                input_empty_error(context);
              }else if(int.parse(money_input.text)>user_data[2]+last_money){
                print("You input too much money");
                Navigator.of(context).pop();
                input_money_error(context);
              }
              else{
                print("revise money, vote_for=${vote_for}");
                if(team==NBATeam.name[game.team1]){
                  vote_for=0;
                  DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Game_Users/").child(this.game_folder).child(game.team1).child(global_email);
                  int original_money=0;
                  final snap=await dbref.get();
                  if(snap.exists){
                    dynamic get=snap.value;
                    original_money=get["money"];
                    print("peep done,original_money=${original_money}");
                  }

                  DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                  await dbref2.update(
                    {
                      "user_money":user_data[2]+original_money
                    }
                  );
                  print("user add money");

                  DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Gambling/").child(game_folder);
                  await dbref3.update(
                    {
                     "dollar1":game.dollar1-original_money
                    }
                  );
                  print("game minus money");

                  DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_History/").child(global_email).child("G"+game_folder);
                  await dbref4.remove();

        
                  // DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Gambling_Game_Users/").child(this.game_folder).child(game.team1).child(global_email);
                  await dbref.set(
                    {
                      "money":int.parse(money_input.text)
                    }
                  );
                  print("hang on money");

                  //  DatabaseReference dbref5= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                    await dbref2.update(
                        {
                          "user_money":user_data[2]-int.parse(money_input.text)
                        }
                    );
                    print("user minus money");

                   // DatabaseReference dbref6= await FirebaseDatabase.instance.ref("Gambling/").child(game_folder);
                    await dbref3.update(
                        {
                          "dollar1":game.dollar1+int.parse(money_input.text),
                          "odd1": game.dollar2==0? 1.0 : double.parse((game.dollar2/(game.dollar1+int.parse(money_input.text))).toStringAsFixed(2)),
                          "odd2": game.dollar2==0?  double.parse((game.dollar1+int.parse(money_input.text)).toString()): double.parse(((game.dollar1+int.parse(money_input.text))/game.dollar2).toStringAsFixed(2)),
                        }
                    );
                    print("game add money");


                    DateTime now_time=DateTime.now().add(Duration(hours: 8));
                    String now_time_string=now_time.year.toString()+Change_to_2(now_time.month.toString())+Change_to_2(now_time.day.toString())+Change_to_2(now_time.hour.toString())+Change_to_2(now_time.minute.toString())+Change_to_2(now_time.second.toString());
                    await dbref4.set(
                      {
                        "time":now_time_string,
                        "money":int.parse(money_input.text),
                        "attribute":1, //0 for add
                        "why":"${NBATeam.name[game.team1]}(選擇) VS ${NBATeam.name[game.team2]}"
                      }
                    );

                }else{
                  vote_for=1;
                  DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Game_Users/").child(this.game_folder).child(game.team2).child(global_email);
                  int original_money=0;
                  final snap=await dbref.get();
                  if(snap.exists){
                    dynamic get=snap.value;
                    original_money=get["money"];
                    print("peek done, money=${original_money}");
                  }
                
                  DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                  await dbref2.update(
                    {
                      "user_money":user_data[2]+original_money
                    }
                  );
                  print("user add back money");

                  DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Gambling/").child(game_folder);
                  await dbref3.update(
                    {
                     "dollar2":game.dollar2-original_money
                    }
                  );
                  print("game minus money");

                  DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_History/").child(global_email).child("G"+game_folder);
                  await dbref4.remove();

                  //DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Gambling_Game_Users/").child(this.game_folder).child(game.team2).child(global_email);
                  await dbref.set(
                    {
                      "money":int.parse(money_input.text)
                    }
                  );
                  print("write to game user_list");

                    //DatabaseReference dbref5= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                    await dbref2.update(
                        {
                          "user_money":user_data[2]-int.parse(money_input.text)
                        }
                    );
                    print("user minus money");

                    //DatabaseReference dbref6= await FirebaseDatabase.instance.ref("Gambling/").child(game_folder);
                    await dbref3.update(
                        {
                          "dollar2":game.dollar2+int.parse(money_input.text),
                           "odd1": game.dollar1==0? double.parse((game.dollar2+int.parse(money_input.text)).toString()) : double.parse(((game.dollar2+int.parse(money_input.text))/game.dollar1).toStringAsFixed(2)),
                          "odd2": game.dollar1==0? 1.0 : double.parse(((game.dollar1)/(game.dollar2+int.parse(money_input.text))).toStringAsFixed(2)),
                        }
                    );
                    print("game add money");

                    //DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_History/").child(global_email).child("G"+game_folder);
                    DateTime now_time=DateTime.now().add(Duration(hours: 8));
                    String now_time_string=now_time.year.toString()+Change_to_2(now_time.month.toString())+Change_to_2(now_time.day.toString())+Change_to_2(now_time.hour.toString())+Change_to_2(now_time.minute.toString())+Change_to_2(now_time.second.toString());
                    await dbref4.set(
                      {
                        "time":now_time_string,
                        "money":int.parse(money_input.text),
                        "attribute":1, //0 for add
                        "why":"${NBATeam.name[game.team1]} VS ${NBATeam.name[game.team2]}(選擇)"
                      }
                    );
                    
                }
                //if money_input==null??
                money_drop=int.parse(money_input.text);
                print("vote_for=${vote_for},money_drop=${money_drop}");
                // money_input.dispose();
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    }, );
  }

  Future<void> check_for_quit(BuildContext context,String team) {
    return showDialog<void>(context:context,builder:(context) {

      return AlertDialog(
        title: Text("是否要取消下注${team}"),
        actions: [
          ElevatedButton(
            child: Text('否', style: TextStyle(color: Colors.white)),
            onPressed: () {
              print("vote_for=${vote_for},money_drop=${money_drop}");
              Navigator.of(context).pop("cancel");
            },
          ),
           ElevatedButton(
            child: Text('是', style: TextStyle(color: Colors.white)),
            onPressed: () async{
              money_drop=0;
              if(team==NBATeam.name[game.team1] ){
                vote_for=1;
                print("vote_for=${vote_for},money_drop=${money_drop}");
                //  Navigator.of(context).pop("cancel");     
                 //revise database,add money back
                 DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Game_Users/").child(this.game_folder).child(game.team1).child(global_email);
                  int original_money=0;
                  final snap=await dbref.get();
                  if(snap.exists){
                    dynamic get=snap.value;
                    original_money=get["money"];
                    await dbref.remove();
                  }
                
                  DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                  await dbref2.update(
                    {
                      "user_money":user_data[2]+original_money
                    }
                  );

                  DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Gambling/").child(game_folder);
                    
                if(game.dollar1-original_money==0){
                  await dbref3.update(
                        {
                          "dollar1":game.dollar1-original_money,
                          "people_num1":game.people_num1-1,
                          "odd1": game.dollar2==0? 1.0 : double.parse((game.dollar2/1).toStringAsFixed(2)),
                          "odd2": game.dollar2==0?  1.0: 1.0,
                        }
                    );
                }else{
                  await dbref3.update(
                        {
                          "dollar1":game.dollar1-original_money,
                          "people_num1":game.people_num1-1,
                          "odd1": game.dollar2==0? 1.0 : double.parse((game.dollar2/(game.dollar1-original_money)).toStringAsFixed(2)),
                          "odd2": game.dollar2==0?  double.parse((game.dollar1-original_money).toString()): double.parse(((game.dollar1-original_money)/game.dollar2).toStringAsFixed(2)),
                        }
                    );
                }

                  // DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_History/").child(global_email).child("G"+game_folder);
                  // await dbref4.remove();

                

              }else{
                vote_for=0;
                print("vote_for=${vote_for},money_drop=${money_drop}");
                //  Navigator.of(context).pop("cancel");
                DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Game_Users/").child(this.game_folder).child(game.team2).child(global_email);
                  int original_money=0;
                  final snap=await dbref.get();
                  if(snap.exists){
                    dynamic get=snap.value;
                    original_money=get["money"];
                    await dbref.remove();
                  }
                
                  DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                  await dbref2.update(
                    {
                      "user_money":user_data[2]+original_money
                    }
                  );

                  DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Gambling/").child(game_folder);
                if(game.dollar2-original_money==0){
                  await dbref3.update(
                    {
                      "dollar2":game.dollar2-original_money,
                      "people_num2":game.people_num2-1,
                      "odd1": game.dollar1==0?  1.0 : 1.0,
                      "odd2": game.dollar1==0? 1.0 : double.parse((game.dollar1/1).toStringAsFixed(2)),
                    }
                  );
                }else{
                  await dbref3.update(
                    {
                      "dollar2":game.dollar2-original_money,
                      "people_num2":game.people_num2-1,
                      "odd1": game.dollar1==0?  double.parse((game.dollar2-original_money).toString()) : double.parse(((game.dollar2-original_money)/game.dollar1).toStringAsFixed(2)),
                      "odd2": game.dollar1==0? 1.0 : double.parse(((game.dollar1)/(game.dollar2-original_money)).toStringAsFixed(2)),
                    }
                  );
                }
                // _choose_for_left(context, game.team1);
              }
              DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_History/").child(global_email).child("G"+game_folder);
              await  dbref4.remove();
              Navigator.of(context).pop("cancel");
            },
          ),
        ],
      );
    }, );
  }

  String math_display(dynamic i){
      if(i>=1000&&i<1000000){
        return (i/1000).toStringAsFixed(2)+" K";
      }else if(i>=1000000){
        return (i/1000000).toStringAsFixed(2)+" M";
      }else return i.toString();
  }

  void initState(){
    print("initializing");
    super.initState();
    peep_user_database();
  }

  peep_user_database()async{ // not safety
    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/");
    final snap=await dbref.get();
    if(snap.exists){
      dynamic get=snap.value;
      whole_app_user=get;
      print("peep user done,database=${whole_app_user}");
      ready_for_discussion=1;
    }
  }

  void initGame()async{
    final game_folder = await ModalRoute.of(context)!.settings.arguments as String; 
    this.game_folder=game_folder;
    // print("game folder="+game_folder);
    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling/").child(game_folder);
    await dbref.onValue.listen((event) {
          // print("read total game");
         dynamic get=event.snapshot.value;
         if(get==null){
          print("game was cancel now");
          Navigator.pop(context);
         }
        //  print("at database, get=");
        //  print(get);
         var temp_time=get["TTS"];
         DateTime TTS=DateTime.utc(int.parse(temp_time.substring(0, 4)),int.parse(temp_time.substring(4, 6)),int.parse(temp_time.substring(6, 8)),int.parse(temp_time.substring(8, 10)),int.parse(temp_time.substring(10, 12)),int.parse(temp_time.substring(12, 14)));
         game=Game(get["team1"], get["team2"], get["odd1"].toDouble(), get["odd2"].toDouble(), get["people_num1"], get["people_num2"], get["dollar1"], get["dollar2"], get["status"], get["ans"], get["folder"],TTS);
        //  print("game get");
        if(game.dollar1+game.dollar2==0){
          percent1=0;
        }else percent1=(game.dollar1/(game.dollar1+game.dollar2)*100).toInt();
        
        //  setState(() {
           
        //  });
    });
    if(ready_for_discussion==1){
      DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Gambling_Discussion").child(game_folder);
      await dbref2.onValue.listen((event) {
        // print("discussions");
        dynamic get=event.snapshot.value;
        comment_list=[];
        comment_total_number=0;
        // discussion_user_name=[];
        // discussion_comment=[];
        // print("reading the comment database");
        // print("get in comment=${get}");
        get.forEach(
          (key,value){  // each comment (by date)
            // print("key=${key}");
            if(key!="Number"){
              Map data=get[key];
              String target_email=data["user_name"];
              comment_total_number++;
              
              
              DateTime this_time=DateTime.utc(int.parse(data["comment_time"].substring(0, 4)),int.parse(data["comment_time"].substring(4, 6)),int.parse(data["comment_time"].substring(6, 8)),int.parse(data["comment_time"].substring(8, 10)),int.parse(data["comment_time"].substring(10, 12)),int.parse(data["comment_time"].substring(12, 14)));
              comment_list.add(Comment(user_name: whole_app_user[target_email]["user_name"],comment: data["comment"],pass_time: this_time,profile: whole_app_user[target_email]["profile"],title:whole_app_user[target_email]["user_title"]));
              // discussion_user_name.add();
              // discussion_comment.add(data["comment"]);    
            }
            
          }
        );
        // print("now we have ${comment_total_number} comment");
        // int comment_count=1;
        // comment_list.forEach((element) {
        //     print("show_comment_list");
        //     print(element.comment_time);
        //     // print("comment ${comment_count++}: ${comment_list[comment_count-1]}");
        // });
        if(comment_total_number!=0){
            comment_list.sort((a, b) => b.comment_time.compareTo(a.comment_time));
        }
        
        // print(discussion_user_name);
        // print(discussion_comment);
      });


    }
    

    if(check_team1==0||check_team2==0){
      int not_found=0;
      if(check_team1==0){
        DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Gambling_Game_Users").child(game_folder).child(game.team1);
        await dbref3.onValue.listen((event) {
        // print("read users");
        dynamic get=event.snapshot.value;
        if(get!=null){
          check_team1++;
          // print("check for team1");
          get.forEach(
            (key,value){
              if(key==global_email){
                  vote_for=0;
                  last_money=get[key]["money"];
                  print("last_money=${last_money}");
                  // print("vote for team1");
              }
            }
          );
        }   
      });
      }
      
      if(check_team2==0){
        DatabaseReference dbref5= await FirebaseDatabase.instance.ref("Gambling_Game_Users").child(game_folder).child(game.team2);
        await dbref5.onValue.listen((event) {
        // print("read users");
          dynamic get=event.snapshot.value;
          if(get!=null){
            // print("check team2 history");
            check_team2++;
            get.forEach(
              (key,value){
                if(key==global_email){
                  vote_for=1;
                  last_money=get[key]["money"];
                  print("last_money=${last_money}");
                  //  print("vote for team2");
                }
              }
            );
          }   
        });
      }
    }
    
    

    DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Gambling_Users").child(global_email);
    await dbref4.onValue.listen((event) {
        // print("read_user_data");
        dynamic get=event.snapshot.value;
        user_data=[];
        user_data.add(get["user_title"]);
        user_data.add(get["user_name"]);
        user_data.add(get["user_money"]);
        user_data.add(get["profile"]);
    });

    // if(init_state<=10){  // for the first run
    //   init_state++;
    //   print("set_state");
      setState(() {  // realtime
        
      });
    // }
    // setState(() {});
    // print("init game end");
  }

  String Change_to_2(String number){
    if(number.length==2){
      return number;
    }else return "0"+number;
  }

  @override
  Widget build(BuildContext context) {
    
    initGame();
    
    // print("still building");
    //print("game1=${game.team1},game2=${game.team2},");
    

    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Pallete.backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Game",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);  
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        )
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
                            child: Image.asset("photos/profile_"+user_data[3].toString()+".png",//change ， To people's photo(prize)
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                  Text(
                                    user_data[0],
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                
                                
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  child:  
                                    Text(
                                      "  "+user_data[1],
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15,
                                        color: Pallete.primaryColor,
                                      ),
                                    ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.money,color: Colors.white,),
                                  Text(
                                    user_data[2].toString(), //change!!
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],

                              
                            ),
                            // const Padding(
                            //   padding:
                            //       EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                            //   child: Row(
                            //     children: [
                            //       Icon(Icons.money),
                            //       Text(
                            //         "Remainning Money.", //change!!
                            //         textAlign: TextAlign.start,
                            //         overflow: TextOverflow.clip,
                            //         style: TextStyle(
                            //           fontWeight: FontWeight.w400,
                            //           fontStyle: FontStyle.normal,
                            //           fontSize: 14,
                            //           color: Colors.white,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 12, 0, 0),
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width * 0.44,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: Pallete.redSideColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 12, 0, 0),
                                      child: Container(
                                        height: 120,
                                        width: 120,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "NbaLogo/"+NBATeam.name[game.team1]+".png"),
                                              //change!!
                                              fit: BoxFit.fill),
                                          // shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      NBATeam.location[game.team1], //change!!
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      NBATeam.name[game.team1], //change!!
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 0),
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width * 0.44,
                                height: 280,
                                decoration: BoxDecoration(
                                  color: Pallete.cardColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          percent1.toString()+"%",//change!!
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 50,
                                            color: Pallete.redSideColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                  0,
                                                  0,
                                                  0),
                                          child: LinearPercentIndicator(
                                            percent: percent1/100,//change!!
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            lineHeight: 24,
                                            animation: true,
                                            progressColor: Pallete.redSideColor,
                                            backgroundColor:
                                                Pallete.backgroundColor,
                                            barRadius:
                                                const Radius.circular(20),
                                            padding: EdgeInsets.all(0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children:  [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 5, 0),
                                                child: Text(
                                                  math_display(game.dollar1),//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.attach_money,
                                                color: Pallete.redSideColor,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 5, 0),
                                                child: Text(
                                                  "1:"+game.odd1.toString(),//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.mood,
                                                color: Pallete.redSideColor,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 5, 0),
                                                child: Text(
                                                  math_display(game.people_num1),//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.people,
                                                color: Pallete.redSideColor,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsetsDirectional
                                        //       .fromSTEB(10, 0, 10, 0),
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.end,
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.center,
                                        //     mainAxisSize: MainAxisSize.max,
                                        //     children: [
                                        //       Padding(
                                        //         padding: EdgeInsetsDirectional
                                        //             .fromSTEB(0, 0, 5, 0),
                                        //         child: Text(
                                        //           math_display(game.dollar1),//change!!
                                        //           textAlign: TextAlign.start,
                                        //           overflow: TextOverflow.clip,
                                        //           style: TextStyle(
                                        //             fontWeight: FontWeight.w300,
                                        //             fontStyle: FontStyle.normal,
                                        //             fontSize: 15,
                                        //             color: Colors.white,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       Icon(
                                        //         Icons.money,
                                        //         color: Pallete.redSideColor,
                                        //         size: 24,
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(1, 0),
                                      child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Container(
                                            width: 120,
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: ElevatedButton.icon(
                                                label: Text(
                                                  "Bet Left",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 13,
                                                    color: vote_for!=0? Colors.white:Colors.yellow,
                                                  ),
                                                ),
                                                icon:  FaIcon(
                                                  size: 20,
                                                  FontAwesomeIcons.coins,
                                                  color:vote_for!=0? Colors.white:Colors.yellow
                                                ),
                                                
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                    game.status==0?  Pallete.redSideColor:Pallete.commentColor,
                                                ),
                                                onPressed: (()async {
                                                  if(game.status==0){
                                                      if(vote_for==-1){
                                                        _choose_for_left(context, NBATeam.name[game.team1]); //change
                                                      }else if(vote_for==0){
                                                        _revise_money_drop(context, NBATeam.name[game.team1],);
                                                      }else if(vote_for==1){
                                                        await  check_for_quit(context,NBATeam.name[game.team2]);
                                                        if(vote_for==1){
                                                          print("system: not changed");
                                                        }else if(vote_for==0){
                                                          print("system: changed");
                                                          _choose_for_left(context, NBATeam.name[game.team1]);
                                                        }
                                                    }else{
                                                      print("error");
                                                    }
                                                    print(this.vote_for);
                                                  }else{
                                                    print("Time Over, You can't vote");
                                                  }
                                                  
                                                }),
                                              ),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 12, 0, 0),
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width * 0.44,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: Pallete.blueSideColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 12, 0, 0),
                                      child: Container(
                                        height: 120,
                                        width: 120,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "NbaLogo/"+NBATeam.name[game.team2]+".png"),
                                              //change!!
                                              fit: BoxFit.fill),
                                          // shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      NBATeam.location[game.team2], //change!!
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      NBATeam.name[game.team2], //change!!
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 0),
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width * 0.44,
                                height: 280,
                                decoration: BoxDecoration(
                                  color: Pallete.cardColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          game.dollar1==0&&game.dollar2==0? "0%":(100-percent1).toString()+"%",//change!!
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 50,
                                            color: Pallete.blueSideColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                  0,
                                                  0,
                                                  0),
                                          child: LinearPercentIndicator(
                                            percent: game.dollar1==0&&game.dollar2==0? 0 : (100-percent1)/100,//change!!
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            lineHeight: 24,
                                            animation: true,
                                            progressColor:
                                                Pallete.blueSideColor,
                                            backgroundColor:
                                                Pallete.backgroundColor,
                                            barRadius:
                                                const Radius.circular(20),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children:  [
                                              Icon(
                                                Icons.attach_money,
                                                color: Pallete.blueSideColor,
                                                size: 24,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(5, 0, 0, 0),
                                                child: Text(
                                                  math_display(game.dollar2),//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children:  [
                                              Icon(
                                                Icons.mood,
                                                color: Pallete.blueSideColor,
                                                size: 24,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(5, 0, 0, 0),
                                                child: Text(
                                                  "1:"+game.odd2.toString(),//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children:  [
                                              Icon(
                                                Icons.people,
                                                color: Pallete.blueSideColor,
                                                size: 24,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(5, 0, 0, 0),
                                                child: Text(
                                                  math_display(game.people_num2),//change!! // still need modify
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsetsDirectional
                                        //       .fromSTEB(10, 0, 10, 0),
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.start,
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.center,
                                        //     mainAxisSize: MainAxisSize.max,
                                        //     children:[
                                        //       Icon(
                                        //         Icons.money,
                                        //         color: Pallete.blueSideColor,
                                        //         size: 24,
                                        //       ),
                                        //       Padding(
                                        //         padding: EdgeInsetsDirectional
                                        //             .fromSTEB(5, 0, 0, 0),
                                        //         child: Text(
                                        //           math_display(game.dollar2),//change!!
                                        //           textAlign: TextAlign.start,
                                        //           overflow: TextOverflow.clip,
                                        //           style: TextStyle(
                                        //             fontWeight: FontWeight.w300,
                                        //             fontStyle: FontStyle.normal,
                                        //             fontSize: 15,
                                        //             color: Colors.white,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1, 0),
                                      child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Container(
                                            width: 120,
                                            child: ElevatedButton.icon(
                                              icon: FaIcon(
                                                size: 20,
                                                FontAwesomeIcons.coins,
                                                color: vote_for!=1? Colors.white:Colors.yellow,
                                              ),
                                              label: Text(
                                                "Bet Right",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 13,
                                                  color: vote_for!=1? Colors.white:Colors.yellow,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                  game.status==0?  Pallete.blueSideColor:Pallete.commentColor,
                                              ),
                                              onPressed: (()async{
                                                if(game.status==0){
                                                  
                                                  if(vote_for==-1){
                                                    _choose_for_left(context, NBATeam.name[game.team2]); //change
                                                  }else if(vote_for==1){
                                                    _revise_money_drop(context, NBATeam.name[game.team2],);
                                                  }else if(vote_for==0){
                                                    await  check_for_quit(context,NBATeam.name[game.team1]);
                                                    if(vote_for==0){
                                                      print("system: not changed");
                                                    }else if(vote_for==1){
                                                      print("system: changed");
                                                      _choose_for_left(context, NBATeam.name[game.team2]); // no cancel
                                                    }
                                                  }else{
                                                    print("error");
                                                  }       
                                                  print(this.vote_for);                                                 
                                                }else{
                                                  print("Time Over, You can't vote");
                                                }
                                                
                                              }),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
              child: Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Pallete.cardColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [  // start comment
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 12),
                      child: 
                      Container(
                        height: comment_total_number==0? 0: comment_total_number==1? 70 : comment_total_number==2? 150 :comment_total_number==3? 200 : 270,
                        child: ListView.builder(
                          reverse: true,
                          itemCount: comment_list.length,
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            // if(index==discussion_user_name.length){
                            //   TextEditingController the_word=TextEditingController();
                            //   return  TextField(
                            //     style: TextStyle(color: Colors.white),
                            //     controller: the_word,
                            //     decoration: InputDecoration(
                            //       // hintText: "輸入評論 : ",
                            //       // hintStyle: TextStyle(color: Colors.white),
                            //       labelText: "輸入評論 : ",
                            //       labelStyle: TextStyle(color: Colors.white),
                            //       border: OutlineInputBorder(),
                            //       contentPadding: EdgeInsets.all(15),
                            //       suffixIcon: IconButton(
                            //         icon:Icon(Icons.arrow_right),
                            //         onPressed: () {
                            //           print("submit ==> ${the_word.text}");
                            //         },  
                            //       ),

                            //     ),

                            //   );
                            // }else{
                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 12),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ///***If you have exported images you must have to copy those images in assets/images directory.
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.asset(
                                        "photos/profile_"+comment_list[index].profile.toString()+".png",
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),//change!!
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12, 0, 10, 0),
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Pallete.commentBgColor,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(12, 8, 12, 8),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    comment_list[index].title+"  "+comment_list[index].user_name,//change!!
                                                    textAlign: TextAlign.start,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 14,
                                                      color: Pallete
                                                          .commentNameColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    comment_list[index].comment,//change!!
                                                    textAlign: TextAlign.start,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 14,
                                                      color: Pallete.commentColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        
                                      ],
                                    ),
                                  ]),
                            );
                          // }
                          },
                          
                          // children: [
                          //   Padding(
                          //     padding: const EdgeInsetsDirectional.fromSTEB(
                          //         0, 0, 0, 12),
                          //     child: Row(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         mainAxisSize: MainAxisSize.max,
                          //         children: [
                          //           ///***If you have exported images you must have to copy those images in assets/images directory.
                          //           ClipRRect(
                          //             borderRadius: BorderRadius.circular(40),
                          //             child: Image.network(
                          //               'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                          //               width: 40,
                          //               height: 40,
                          //               fit: BoxFit.cover,
                          //             ),//change!!
                          //           ),
                          //           Column(
                          //             mainAxisAlignment: MainAxisAlignment.start,
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             mainAxisSize: MainAxisSize.max,
                          //             children: [
                          //               Padding(
                          //                 padding: const EdgeInsetsDirectional
                          //                     .fromSTEB(12, 0, 10, 0),
                          //                 child: Container(
                          //                   constraints: BoxConstraints(
                          //                     maxWidth: MediaQuery.of(context)
                          //                             .size
                          //                             .width *
                          //                         0.65,
                          //                   ),
                          //                   decoration: BoxDecoration(
                          //                       color: Pallete.commentBgColor,
                          //                       shape: BoxShape.rectangle,
                          //                       borderRadius:
                          //                           BorderRadius.circular(12)),
                          //                   child: Padding(
                          //                     padding: const EdgeInsetsDirectional
                          //                         .fromSTEB(12, 8, 12, 8),
                          //                     child: Column(
                          //                       mainAxisSize: MainAxisSize.max,
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment.start,
                          //                       children: const [
                          //                         Text(
                          //                           "Sandra Smith",//change!!
                          //                           textAlign: TextAlign.start,
                          //                           overflow: TextOverflow.clip,
                          //                           style: TextStyle(
                          //                             fontWeight: FontWeight.w400,
                          //                             fontStyle: FontStyle.normal,
                          //                             fontSize: 14,
                          //                             color: Pallete
                          //                                 .commentNameColor,
                          //                           ),
                          //                         ),
                          //                         Text(
                          //                           "I'm not really sure about this...",//change!!
                          //                           textAlign: TextAlign.start,
                          //                           overflow: TextOverflow.clip,
                          //                           style: TextStyle(
                          //                             fontWeight: FontWeight.w400,
                          //                             fontStyle: FontStyle.normal,
                          //                             fontSize: 14,
                          //                             color: Pallete.commentColor,
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                                        
                          //             ],
                          //           ),
                          //         ]),
                          //   ),
                          //   Padding(
                          //     padding: const EdgeInsetsDirectional.fromSTEB(
                          //         0, 0, 0, 12),
                          //     child: Row(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         mainAxisSize: MainAxisSize.max,
                          //         children: [
                          //           ///***If you have exported images you must have to copy those images in assets/images directory.
                          //           ClipRRect(
                          //             borderRadius: BorderRadius.circular(40),
                          //             child: Image.network(
                          //               'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDJ8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                          //               width: 40,
                          //               height: 40,
                          //               fit: BoxFit.cover,
                          //             ),
                          //           ),
                          //           Column(
                          //             mainAxisAlignment: MainAxisAlignment.start,
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             mainAxisSize: MainAxisSize.max,
                          //             children: [
                          //               Padding(
                          //                 padding: const EdgeInsetsDirectional
                          //                     .fromSTEB(12, 0, 10, 0),
                          //                 child: Container(
                          //                   constraints: BoxConstraints(
                          //                     maxWidth: MediaQuery.of(context)
                          //                             .size
                          //                             .width *
                          //                         0.65,
                          //                   ),
                          //                   decoration: BoxDecoration(
                          //                       color: Pallete.commentBgColor,
                          //                       shape: BoxShape.rectangle,
                          //                       borderRadius:
                          //                           BorderRadius.circular(12)),
                          //                   child: Padding(
                          //                     padding: const EdgeInsetsDirectional
                          //                         .fromSTEB(12, 8, 12, 8),
                          //                     child: Column(
                          //                       mainAxisSize: MainAxisSize.max,
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment.start,
                          //                       children: const [
                          //                         Text(
                          //                           "Sandra Smith",
                          //                           textAlign: TextAlign.start,
                          //                           overflow: TextOverflow.clip,
                          //                           style: TextStyle(
                          //                             fontWeight: FontWeight.w400,
                          //                             fontStyle: FontStyle.normal,
                          //                             fontSize: 14,
                          //                             color: Pallete
                          //                                 .commentNameColor,
                          //                           ),
                          //                         ),
                          //                         Text(
                          //                           "I'm not really sure about this. I think GDSC sucks.",
                          //                           textAlign: TextAlign.start,
                          //                           overflow: TextOverflow.clip,
                          //                           style: TextStyle(
                          //                             fontWeight: FontWeight.w400,
                          //                             fontStyle: FontStyle.normal,
                          //                             fontSize: 14,
                          //                             color: Pallete.commentColor,
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                                        
                          //             ],
                          //           ),
                          //         ]),
                          //   ),
                          //   Padding(
                          //     padding: const EdgeInsetsDirectional.fromSTEB(
                          //         0, 0, 0, 12),
                          //     child: Row(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         mainAxisSize: MainAxisSize.max,
                          //         children: [
                          //           ///***If you have exported images you must have to copy those images in assets/images directory.
                          //           ClipRRect(
                          //             borderRadius: BorderRadius.circular(40),
                          //             child: Image.network(
                          //               'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDJ8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',//change!!
                          //               width: 40,
                          //               height: 40,
                          //               fit: BoxFit.cover,
                          //             ),
                          //           ),
                          //           Column(
                          //             mainAxisAlignment: MainAxisAlignment.start,
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             mainAxisSize: MainAxisSize.max,
                          //             children: [
                          //               Padding(
                          //                 padding: const EdgeInsetsDirectional
                          //                     .fromSTEB(12, 0, 10, 0),
                          //                 child: Container(
                          //                   constraints: BoxConstraints(
                          //                     maxWidth: MediaQuery.of(context)
                          //                             .size
                          //                             .width *
                          //                         0.65,
                          //                   ),
                          //                   decoration: BoxDecoration(
                          //                       color: Pallete.commentBgColor,
                          //                       shape: BoxShape.rectangle,
                          //                       borderRadius:
                          //                           BorderRadius.circular(12)),
                          //                   child: Padding(
                          //                     padding: const EdgeInsetsDirectional
                          //                         .fromSTEB(12, 8, 12, 8),
                          //                     child: Column(
                          //                       mainAxisSize: MainAxisSize.max,
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment.start,
                          //                       children: const [
                          //                         Text(
                          //                           "Sandra Smith",//change!!
                          //                           textAlign: TextAlign.start,
                          //                           overflow: TextOverflow.clip,
                          //                           style: TextStyle(
                          //                             fontWeight: FontWeight.w400,
                          //                             fontStyle: FontStyle.normal,
                          //                             fontSize: 14,
                          //                             color: Pallete
                          //                                 .commentNameColor,
                          //                           ),
                          //                         ),
                          //                         Text(
                          //                           "I'm not really sure about this. I think GDSC sucks.",//change!!
                          //                           textAlign: TextAlign.start,
                          //                           overflow: TextOverflow.clip,
                          //                           style: TextStyle(
                          //                             fontWeight: FontWeight.w400,
                          //                             fontStyle: FontStyle.normal,
                          //                             fontSize: 14,
                          //                             color: Pallete.commentColor,
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                        
                          //             ],
                          //           ),
                          //         ]),
                          //   )
                          // ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 12),
                      child: TextField(
                                style: TextStyle(color: Colors.white),
                                controller: the_word,
                                decoration: InputDecoration(
                                  // hintText: "輸入評論 : ",
                                  // hintStyle: TextStyle(color: Colors.white),
                                  labelText: "輸入評論 : ",
                                  labelStyle: TextStyle(color: Colors.white,fontSize: 14),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(15),
                                  suffixIcon: IconButton(
                                    icon:Icon(Icons.arrow_right),
                                    onPressed: () async{
                                      if(!the_word.text.isEmpty){
                                        // print("submit ==> ${the_word.text}");
                                        game_folder=await ModalRoute.of(context)!.settings.arguments as String; 
                                        // print("game_folder=${game_folder}");
                                        DateTime now_time=DateTime.now().add(Duration(hours: 8));
                                        // print("now_time=${now_time}");
                                        // print(now_time.year is int);
                                        String database_path=now_time.year.toString()+Change_to_2(now_time.month.toString())+Change_to_2(now_time.day.toString())+Change_to_2(now_time.hour.toString())+Change_to_2(now_time.minute.toString())+Change_to_2(now_time.second.toString());
                                        // print("datapath=${database_path+global_email}");
                                        DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Discussion/").child(game_folder).child(database_path+global_email);
                                      await dbref.set(
                                        {
                                          "user_name":global_email, //maybe remember the email (in case name changing)
                                          "comment":the_word.text,
                                          "comment_time":database_path,
                                          // "comment_number":comment_number
                                        }
                                      );
                                        the_word.text="";
                                        setState(() {
                                          print("write ok");
                                        });

                                      }else{
                                        print("please insert someting");
                                      }
                                      
                                      // DatabaseReference dbref2 = await FirebaseDatabase.instance.ref("Gambling_Sample_discussion/").child(game_folder).child("Number");
                                      // int comment_number=0;
                                      // final snap=await dbref2.get();
                                      // if(snap.exists){
                                      //   dynamic get=snap.value;
                                      //   comment_number=get["comment_number"];
                                      // }
                                     
                                      // await dbref2.update(
                                      //   {
                                      //     "comment_number":comment_number+1
                                      //   }
                                      // );
                                      
                                      //auto leaving
                                    },  
                                  ),

                                ),
                                onSubmitted: (value) {
                                  print("Submitting");
                                },
                              )
                          
                    )
                  ]
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            //   child: Container(
            //     margin: EdgeInsets.all(0),
            //     padding: EdgeInsets.all(0),
            //     width: MediaQuery.of(context).size.width * 0.9,
            //     decoration: BoxDecoration(
            //       color: Pallete.cardColor,
            //       shape: BoxShape.rectangle,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: Row(
            //       children: [
            //         Text("留言 : ",style:TextStyle(color: Colors.white)),
            //         TextField()
            //       ],
            //     )
            //   )
            // ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
              child: Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Pallete.cardColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container()
              )
            )
          ],
        ),
      ),
    );
  }
}
