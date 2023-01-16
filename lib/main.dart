
import 'package:firebase/Change_Title.dart';
import 'package:firebase/Change_profile.dart';
import 'package:firebase/Enroll_in.dart';
import 'package:firebase/History_Page.dart';
import 'package:firebase/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'mainpage.dart';
import 'HomeScreen.dart';
import 'Video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth_server.dart';
import 'dart:async';
import 'mainpage_mlb_ver.dart';
import 'dart:io';
import 'SetScreen.dart';
import 'Prize.dart';
import 'Pallete.dart';
import 'predictionScreen.dart';
import 'Change_Title.dart';

import 'package:flutter/services.dart';

class Game{
  String team1;
  String team2;
  double odd1;
  double odd2;
  int people_num1;
  int people_num2;
  int dollar1;
  int dollar2;
  int status;
  int ans;
  String folder;
  DateTime TTL;
  // int TTL;
  Game(this.team1,this.team2,this.odd1,this.odd2,this.people_num1,this.people_num2,this.dollar1,this.dollar2,this.status,this.ans,this.folder,this.TTL);
}

String global_email="abcdefg";
Map user_list={};
int user_list_check=0;
int time=0;
int account_exist=0;
int isfaker=0;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();  // dreamly cooperate
  await Firebase.initializeApp();
   SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
  runApp(
    
    MyApp()
  );
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  fill_the_user_list()async{
    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/");
    final snap=await dbref.get();
    if(snap.exists){
       dynamic get=snap.value;
       user_list=get;
       print("User_this=${get}");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("in MYAPP");
    fill_the_user_list();
    return MaterialApp(
      title: 'My Casino',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AuthService().handleAuthState(),
      routes: {
        "/Home_Page":(context) => DefaultTabController(initialIndex: 2,length: 7, child: MyHomePage(title: 'My Casino',email: global_email,)) , //mainpage
        "/Game":(context) => HomeScreen(),
        "/Video_Page":(context) =>AdverVedioPayer(),
        "/Sign_in_Page":(context) => AuthService().handleAuthState(),
        "/Personal_Page":(context) =>  SetScreen(),
        "/History_Page":(context) => HistoryPage(),
        "/Change_title":(context) => Change_Title(),
        "/Change_profile":(context) => Change_Profile(),
        "/Login_page":(context) => LoginPage(),
        "/Enroll_in":(context) => Enroll_in()
      },
      // home: const MyHomePage(title: 'My Casino'),
      // ChangeNotifierProvider(create:(context)=> Information_center()
      // ,child: const MyHomePage(title: 'My Casino'),),
      debugShowCheckedModeBanner: false,
      // initialRoute: "/Sign_in_Page",
    );
  }
}

class Information_center extends ChangeNotifier{
    int user_money=1000000;
    String user_name="茅場晶彥";
    String user_title="封閉者";
    String email="default";
    // String special_key="bbb";

    // async_for_data()async{
    //   DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users").child("Pannacoda Fugo");
    //   await dbref.onValue.listen((event) {
    //     dynamic get=event.snapshot.value;
    //     print("get in information_center");
    //     print(get);
    //   });
    // }

    Information_center(String input_key){
      email=input_key;
      global_email=input_key;
    }

    void Change_user_money(int gap){
        if(user_money+gap>=0){
          // revise money from database(cause database will revise that too)
          user_money+=gap;
          //revise user_money in user database、user_money in game database
          notifyListeners();
        }else print("money can't be negative");
    }

    void Change_user_name(String new_name){
        if(new_name.length>8){
          print("The new name is too long");
        }else if(new_name==null){
            print("name can't be null");
        }else{
          user_name=new_name;
          notifyListeners();
        }
    }
    void Change_user_title(String new_title){
        if(new_title==null){
            print("title can't be null");
        }else{
          user_title=new_title;
          notifyListeners();
        }
    }
}




class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title,this.email="aaa"});
  final String title;
  final String email;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int sort_way=0;
  int page=1;

  DateTime now=DateTime.now().add(Duration(hours: 8));
  // List pages=[Container(color: Colors.red,),MainPage(),Container(color: Colors.blue,)];
  List icons=[Icons.burst_mode,Icons.money,Icons.percent,Icons.calendar_month]; // using Listtile?
  dynamic body_content=PredictionScreen(DateTime.now());
  // dynamic mlb_body_content=MainPage_MLB();
  
  List appbar_title=["看廣告","當前賭局","換獎品"];
  List personal_information=["default","default",99];
  Timer ?update_information;

  Map weekly={
    "1":"Mon",
    "2":"Tue",
    "3":"Wed",
    "4":"Thu",
    "5":"Fri",
    "6":"Sat",
    "7":"Sun",
  };

  

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // print("now=${now}");
  //   // print("now=${now.weekday}");
  //   // print("now=${weekly[now.weekday.toString()]}");

  // }


  print_email(){
    print("I know email= ${widget.email}");
  }

  String Change_to_2(String number){
    if(number.length==2){
      return number;
    }else return "0"+number;
  }

  read_the_database(email)async{
    // print("user_list in read_the_database is :${user_list}" );
    // if(user_list!=null && user_list_check==0){
    //   print("in read_the_database, user+list=${user_list}");
    //   user_list_check=1;
    //   if(!user_list.containsKey(global_email)){
    //     print("account is not exist");
    //   }else{
    //     print("account exist");
    //     // Navigator.pushNamed(context, "/Enroll_in");
    //   }
    // }
    // print("before read the database in HOMEPAGE, the global_email=${global_email}");
    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users").child(email);
    await dbref.onValue.listen((event) {
         dynamic get=event.snapshot.value;
        //  print("what i got in Homepage ==> ${get}");
        //  print("after read the database in HOMEPAGE, the global_email=${global_email}");
         personal_information=[];
         personal_information.add(get["user_title"]);
         personal_information.add(get["user_name"]);
         personal_information.add(get["user_money"]);
         //print("I have personal_information now,it=${personal_information}");
        //  print("user_money_now: ${get["user_money"]}");
         setState(() {  // for realtime
           
         });
      }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("Dispose in main _ home _page");
  }

  @override
  Widget build(BuildContext context) {
    // print_email();
    // print("In the HomePage");
    // print("global_email=${global_email}");
    read_the_database(widget.email);
    return Scaffold(
      // backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: Pallete.backgroundColor,
        automaticallyImplyLeading: false,  // not to automatically generate back arrow
        title: Text(appbar_title[page],style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),),
        actions: [
          //  IconButton(onPressed: (){
          //   if(page==1){
          //     setState(() {
                
          //     });
          //   }
          // }, icon: page==1? Icon(Icons.refresh):Container()),
          IconButton(onPressed: ()async{
            print("Go to Personal Page");
            // Navigator.pushNamed(context, "/Personal_Page");
            String ?resultData = await Navigator.push(context,
                 MaterialPageRoute(builder:(BuildContext context) {
                    return SetScreen() ; 
                  }) 
                );
                if(resultData!=null){
                    print("show you what i got(in home page: ${resultData})");
                    Navigator.pop(context,"SYNACK");
                }
          }, icon: Icon(Icons.person)),
         
        ],
        bottom:  page==1? 
        TabBar(isScrollable: true,tabs: [
          Tab(child: Column(children: [Text("${now.add(Duration(days: -2)).month}/${now.add(Duration(days: -2)).day}"),Text("${weekly[now.add(Duration(days: -2)).weekday.toString()]}")],)),
          Tab(child: Column(children: [Text("${now.add(Duration(days: -1)).month}/${now.add(Duration(days: -1)).day}"),Text("${weekly[now.add(Duration(days: -1)).weekday.toString()]}")],)),
          Tab(child: Column(children: [Text("${now.month}/${now.day}"),Text("${weekly[now.weekday.toString()]}")],)),
          Tab(child: Column(children: [Text("${now.add(Duration(days: 1)).month}/${now.add(Duration(days: 1)).day}"),Text("${weekly[now.add(Duration(days: 1)).weekday.toString()]}")],)),
          Tab(child: Column(children: [Text("${now.add(Duration(days: 2)).month}/${now.add(Duration(days: 2)).day}"),Text("${weekly[now.add(Duration(days: 2)).weekday.toString()]}")],)),
          Tab(child: Column(children: [Text("${now.add(Duration(days: 3)).month}/${now.add(Duration(days: 3)).day}"),Text("${weekly[now.add(Duration(days: 3)).weekday.toString()]}")],)),
          Tab(child: Column(children: [Text("${now.add(Duration(days: 4)).month}/${now.add(Duration(days: 4)).day}"),Text("${weekly[now.add(Duration(days: 4)).weekday.toString()]}")],)),
        ])
        // PreferredSize(child: Container(), preferredSize: Size.fromHeight(0))
        
        :    
          PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child:  
              Container(
              // color: Colors.lightGreen,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text("稱號",style: TextStyle(color: Colors.white),),
                            Text(personal_information[0]==null? " ":personal_information[0],style: TextStyle(color: Colors.white)),
                            //Text(1>0? " ":personal_information[0]),
                          ],
                        ),
                         Column(
                          children: [
                            Text("名字",style: TextStyle(color: Colors.white),),
                            Text(personal_information[1].isEmpty? " ":personal_information[1],style: TextStyle(color: Colors.white)),
                            //Text(1>0? " ":personal_information[1]),
                          ],
                        ),
                         Column(
                          children: [
                            Text("遊戲幣數",style: TextStyle(color: Colors.white),),
                            Text(personal_information[2].toString().isEmpty? " ":personal_information[2].toString(),style: TextStyle(color: Colors.white),),
                            //Text(1>0? " ":personal_information[2].toString()),
                          ],
                         ),  
                      ],
                    ),
                    Container(height: 10,) // under space
                ],
              ),
            ),
            
        ),
      ),
      
      body: 
      page==1? 
      TabBarView(children: [
        PredictionScreen(now.add(Duration(days: -2))),
        PredictionScreen(now.add(Duration(days: -1))),
        PredictionScreen(now),
        PredictionScreen(now.add(Duration(days: 1))),
        PredictionScreen(now.add(Duration(days: 2))),
        PredictionScreen(now.add(Duration(days: 3))),
        PredictionScreen(now.add(Duration(days: 4))),
      ])
      :  body_content//pages[page]
      ,bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.local_atm),label: "賺金幣"),
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "主頁"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events),label: "獎品")
        ],
        currentIndex: page,
        onTap:(value){
          // body_content.dispose();
          sort_way=0;
          if(value==0){
            body_content=jumpadverPage();
          }else if(value==1){
            body_content=PredictionScreen(now);
          }else if(value==2){
            body_content=Nickname();  
          }
          setState(() {
            page=value;
            // // print("page="+page.toString());
            // sort_way=0;
          });
        },
      ),
      // floatingActionButton: page==1? FloatingActionButton(
      //   onPressed: () {
      //       sort_way=(sort_way+1)%4;
      //       body_content.listen(sort_way);
      //       // pages[1].listen(sort_way);
      //       setState(() {
              
      //       });
      //   },
      //   child: Icon(icons[sort_way])
      // ):Container(),
    );
  }
}
