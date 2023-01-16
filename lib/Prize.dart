import 'package:firebase/Pallete.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'main.dart';


class Nickname extends StatefulWidget{
  @override
  State<Nickname> createState() => _Nickname();
}

class _Nickname extends State<Nickname>{

  int still=0;
  int show_prize=0;
  Set user_have_title=Set();
  Set user_have_profile=Set();
  int user_money=0;

  List shopping_list_title=[];
  List shopping_list_profile=[];

  //透過資料產生器，產生資料
  final List<Price> listItems = List<Price>.generate(500, (i) {
    return Price(
      name: '測試資料 $i',
      title: i,
    );
  });
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read_user_data(0);
    get_user_money();
  }

  String Change_to_2(String number){
    if(number.length==2){
      return number;
    }else return "0"+number;
  }

  String math_display(dynamic i){
      if(i>=1000&&i<1000000){
        return (i/1000).toInt().toString()+" K";
      }else if(i>=1000000){
        return (i/1000000).toInt().toString()+" M";
      }else return i.toString();
  }


  read_user_data(int state)async{
    DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_Own").child(global_email).child("profile");
    final snap=await dbref4.get();
    if(snap.exists){
      user_have_profile=Set();
      dynamic get=snap.value;
      // print("In Prize Page no profile,get=${get}");
      // print("get_length=${get.length}");
      get.forEach(
        (key,value){
          if(key!="Default"){
            // print("key=${key}");
            user_have_profile.add(key);
          }
            // DateTime this_time=DateTime.utc(int.parse(value["time"].substring(0, 4)),int.parse(value["time"].substring(4, 6)),int.parse(value["time"].substring(6, 8)),int.parse(value["time"].substring(8, 10)),int.parse(value["time"].substring(10, 12)),int.parse(value["time"].substring(12, 14)));
            // show_array.add(History(why: value["why"],money: value["money"],time: this_time,attribute: value["attribute"]));        
        }
      );
    }
    DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Users_Own").child(global_email).child("title");
    final snap2=await dbref3.get();
    if(snap2.exists){
      user_have_title=Set();
      dynamic get=snap2.value;
      // print("In Prize Page no title,get=${get}");
      // print("get_length=${get.length}");
      get.forEach(
        (key,value){
          if(key!="Default"){
            // print("key=${key}");
            user_have_title.add(key);
          }
            // DateTime this_time=DateTime.utc(int.parse(value["time"].substring(0, 4)),int.parse(value["time"].substring(4, 6)),int.parse(value["time"].substring(6, 8)),int.parse(value["time"].substring(8, 10)),int.parse(value["time"].substring(10, 12)),int.parse(value["time"].substring(12, 14)));
            // show_array.add(History(why: value["why"],money: value["money"],time: this_time,attribute: value["attribute"]));        
        }
      );
    }
    
    // print("user_have_title: ${user_have_title}");
    // print("user_have_profile: ${user_have_profile}");
    if(state==0){
      await read_market();
    }
     if(still==0){
      setState(() {
        
      });
    }
  }

  read_market()async{
    DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Market").child("profile");
    final snap=await dbref4.get();
    if(snap.exists){
      shopping_list_profile=[];
      dynamic get=snap.value;
      //print("In Prize Page no market no profile,get=${get}");
      // print("get_length=${get.length}");
      get.forEach(
        (key,value){
          if(key!="Default"){
            shopping_list_profile.add(Price(name: value["title"],title: value["prize"],number: value["No"]));
          }
            // DateTime this_time=DateTime.utc(int.parse(value["time"].substring(0, 4)),int.parse(value["time"].substring(4, 6)),int.parse(value["time"].substring(6, 8)),int.parse(value["time"].substring(8, 10)),int.parse(value["time"].substring(10, 12)),int.parse(value["time"].substring(12, 14)));
            // show_array.add(History(why: value["why"],money: value["money"],time: this_time,attribute: value["attribute"]));        
        }
      );
      shopping_list_profile.sort((a, b) => a.title.compareTo(b.title));
    }
    DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Market").child("title");
    final snap2=await dbref3.get();
    if(snap2.exists){
      shopping_list_title=[];
      dynamic get=snap2.value;
     // print("In Prize Page no market no title,get=${get}");
      // print("get_length=${get.length}");
      get.forEach(
        (key,value){
          if(key!="Default"){
            shopping_list_title.add(Price(name: value["title"],title: value["prize"],number: value["No"]));
          }
            // DateTime this_time=DateTime.utc(int.parse(value["time"].substring(0, 4)),int.parse(value["time"].substring(4, 6)),int.parse(value["time"].substring(6, 8)),int.parse(value["time"].substring(8, 10)),int.parse(value["time"].substring(10, 12)),int.parse(value["time"].substring(12, 14)));
            // show_array.add(History(why: value["why"],money: value["money"],time: this_time,attribute: value["attribute"]));        
        }
      );
      shopping_list_title.sort((a, b) => a.title.compareTo(b.title));
    }
    if(still==0){
      setState(() {
        
      });
    }
    // print("shopping_list_title: ${shopping_list_title}");
    // shopping_list_title.forEach((element) {
    //   print(element);
    // },);
    // print("shopping_list_profile: ${shopping_list_profile}");
    // shopping_list_profile.forEach((element) {
    //   print(element.name);
    //   print(element.title);
    //   print(element.number);
    // },);
  }

  get_user_money()async{
    DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Gambling_Users").child(global_email);
    // await dbref4.onValue.listen((event) {
    //     // print("read_user_data");
    //     dynamic get=event.snapshot.value;
    //     user_money =get["user_money"];
        
    //     setState(() {
          
    //     });
    //     // print("user has ${user_money}");
    // });
    final snap=await dbref4.get();
    if(snap.exists){
      dynamic get=snap.value;
      //print("get=${get}");
      user_money=get["user_money"];
    }
    if(still==0){
      setState(() {
      
    });
    }
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    still=1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get_user_money();
    return Center(
        child: ListView.builder(
      itemCount: show_prize==0? 1+shopping_list_profile.length:1+shopping_list_title.length,
      itemBuilder: (context, index) {
        if(index==0){
          return Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
              ElevatedButton(
                child: SizedBox(width: 0.3* MediaQuery.of(context).size.width, 
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0,8,0,8),
                    child: Text("顯示頭貼",textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
                  )
                )
                ,style: ElevatedButton.styleFrom(backgroundColor: show_prize==0? Colors.green:Pallete.commentColor )
                ,onPressed: (){
                  show_prize=0;
                  //print("show_prize=${show_prize}");
                  setState(() {
                    
                  });
                }, 
              ),
              ElevatedButton(
                child: SizedBox(width: 0.3* MediaQuery.of(context).size.width, 
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0,8,0,8),
                    child: Text("顯示稱號",textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
                  )
                )
                ,style: ElevatedButton.styleFrom(backgroundColor: show_prize==1? Colors.green:Pallete.commentColor )
                ,onPressed: (){
                  show_prize=1;
                  //print("show_prize=${show_prize}");
                  setState(() {
                  
                 });
              
                
                }, )
            ]),
          );
        }else{
          if(show_prize==1){ //for title

            return Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey,width: 1))),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      Container(width: 90,child: Text(shopping_list_title[index-1].name,style: TextStyle(color: Colors.blueAccent),)),
                      Container(width: 100,child: Row(
                        children: [
                          Icon(Icons.paid,color: Color.fromARGB(255, 238, 216, 16),),
                          Text(" : ${ math_display(shopping_list_title[index-1].title)}"),
                        ],
                      ) )
                  ],),
                ) ,
                trailing: Column(
                  children: <Widget>[
                    ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: user_have_title.contains(shopping_list_title[index-1].number.toString())? Pallete.commentColor: user_money>=shopping_list_title[index-1].title? Colors.green :Colors.red),
                    onPressed: ()async{
                       if(user_have_title.contains(shopping_list_title[index-1].number.toString())){
                        print("You have already had");
                      }else{
                        if(user_money<shopping_list_title[index-1].title){
                          print("You Don't have money");
                        }else{
                           // print("start processing");
                            await get_user_money();
                            DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                            await dbref.update(
                              {
                                "user_money": user_money-shopping_list_title[index-1].title
                              }
                            );
                            //print("money ok");
                        
                            DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Users_Own/").child(global_email).child("title").child(shopping_list_title[index-1].number.toString());
                            await dbref2.set(
                              {
                                "No":shopping_list_title[index-1].number,
                                "name":shopping_list_title[index-1].name
                              }
                            );
                            //print("hang on ok");

                             setState(() {
                              
                            });
                            read_user_data(99);

                            DateTime now_time=DateTime.now().add(Duration(hours: 8));
                            String now_time_string=now_time.year.toString()+Change_to_2(now_time.month.toString())+Change_to_2(now_time.day.toString())+Change_to_2(now_time.hour.toString())+Change_to_2(now_time.minute.toString())+Change_to_2(now_time.second.toString());
    
                            DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Users_History/").child(global_email).child("B"+now_time_string);
                            await dbref3.set(
                              {
                                "time":now_time_string,
                                "money":shopping_list_title[index-1].title,
                                "attribute":1, //0 for add
                                "why":"購買稱號 : ${shopping_list_title[index-1].name}"
                              }
                            );
                            //print("log ok");  
                            get_user_money();
                            print("user_money=${user_money}");
                            setState(() {
                              
                            });
                        }
                      }
                    },
                    child: const Text('購買'),
                  )
                  ],
                )
           ),
            );
          }
          else{
              return Padding(
          padding: const EdgeInsets.all(8.0),
          child: 
          ListTile(
            leading: ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset("photos/profile_"+shopping_list_profile[index-1].number.toString()+".png",width: 70,height: 70,)),
            title: Text(shopping_list_profile[index-1].name.toString()), //prize
            subtitle: Row(
                        children: [
                          Icon(Icons.paid,color: Color.fromARGB(255, 238, 216, 16),),
                          Text(" "+math_display(shopping_list_profile[index-1].title)),
                        ],
                      ) ,
            
            
            trailing: Column(
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: user_have_profile.contains(shopping_list_profile[index-1].number.toString())? Pallete.commentColor: user_money>=shopping_list_profile[index-1].title? Colors.green :Colors.red),
                    onPressed: ()async{
                       if(user_have_profile.contains(shopping_list_profile[index-1].number.toString())){
                        print("You have already had");
                      }else{
                        if(user_money<shopping_list_profile[index-1].title){
                          print("You Don't have money");
                        }else{
                          //  print("start processing");
                            await get_user_money();
                            DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                            await dbref.update(
                              {
                                "user_money": user_money-shopping_list_profile[index-1].title
                              }
                            );
                            //print("money ok");
                        
                            DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Users_Own/").child(global_email).child("profile").child(shopping_list_profile[index-1].number.toString());
                            await dbref2.set(
                              {
                                "No":shopping_list_profile[index-1].number,
                                "name":shopping_list_profile[index-1].name
                              }
                            );
                            // print("hang on ok");

                             setState(() {
                              
                            });
                            read_user_data(99);

                            DateTime now_time=DateTime.now().add(Duration(hours: 8));
                            String now_time_string=now_time.year.toString()+Change_to_2(now_time.month.toString())+Change_to_2(now_time.day.toString())+Change_to_2(now_time.hour.toString())+Change_to_2(now_time.minute.toString())+Change_to_2(now_time.second.toString());
    
                            DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Users_History/").child(global_email).child("B"+now_time_string);
                            await dbref3.set(
                              {
                                "time":now_time_string,
                                "money":shopping_list_profile[index-1].title,
                                "attribute":1, //0 for add
                                "why":"購買頭貼 : ${shopping_list_profile[index-1].name}"
                              }
                            );
                            // print("log ok");

                             get_user_money();
                            print("user_money=${user_money}");
                            setState(() {
                              
                            });
                           
                        }
                      }
                    },
                    child: const Text('購買'),
                  )
                ],
              )
          ),
        );
          }
          
        }
        
      },
    ));
  }


}

//產品資料
class Price{
  final String name ;
  final int title ;
  int number;
  Price({this.name='default', this.title=0,this.number=0});
}

class Title {
  final String name ;
  final int title ;
  int number;

  Title({this.name='default', this.title=0,this.number=0});
}
class Profiles {
  final String name ;
  final int title ;
  int number;

  Profiles({this.name='default', this.title=0,this.number=0});
}

// class Profile extends StatelessWidget {
//   //透過資料產生器，產生資料
//   final List<PicturePrice> listItems = List<PicturePrice>.generate(500, (i) {
//     return PicturePrice(
//       price: '價錢：$i',
//     );
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: ListView.builder(
//       itemCount: listItems.length,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListTile(
//             leading: const Icon(Icons.event_seat),
//             title: Text(listItems[index].price),
//             trailing: Column(
//                 children: <Widget>[
//                   ElevatedButton(
//                     style: raisedButtonStyle,
//                     onPressed: () {},
//                     child: const Text('購買'),
//                   )
//                 ],
//               )
//           ),
//         );
//       },
//     ));
//   }
// }
// final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
//   backgroundColor: Colors.black87,
//   foregroundColor: Colors.grey[300],
//   minimumSize: const Size(88, 36),
//   padding: const EdgeInsets.symmetric(horizontal: 16),
//   shape: const RoundedRectangleBorder(
//     borderRadius: BorderRadius.all(Radius.circular(2)),
//   ),
// );
// //產品資料
// class  PicturePrice{
//   final String price;

//   PicturePrice({this.price = 'default'});
// }


// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
// // class HomePage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold();
// //   }
// // }
