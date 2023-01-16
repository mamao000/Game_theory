
import 'package:firebase/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase/Pallete.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'common_data.dart';
// import 'main.dart';

class Enroll_in extends StatefulWidget{
  @override
  State<Enroll_in> createState() => _Enroll_in();
}

class _Enroll_in extends State<Enroll_in>{
  @override
  int choose_for_profile=-1;
  int choose_for_title=-1;
  int input_ok=-1;
  TextEditingController input_name=TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    print("Deleting Enroll in");
    super.dispose();
  }


  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Pallete.backgroundColor,
        // appBar: AppBar(title: Text("創建新帳戶")),
        body: 
        
        Center(
          child: ListView(
            children: [
                Container(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("歡迎，新使用者 ",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,),
                              Text("${global_email}",style: TextStyle(fontSize: 20,color: Pallete.primaryColor),textAlign: TextAlign.center,),
                            ],
                          ),
                          
                         // Text("${global_email}",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("請完成以下步驟建立帳戶",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Text("Step 1: 輸入用戶名稱",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,),
                          TextField(
                            style: TextStyle(fontSize: 16, color: Colors.white),//文字大小、顏色
                            controller: input_name,
                            decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder( //<-- SEE HERE
                              borderSide: BorderSide(
                              width: 3, color: input_ok==0? Colors.white:Colors.red), 
                            ),
                            focusedBorder: UnderlineInputBorder( //<-- SEE HERE
                              borderSide: BorderSide(
                              width: 3, color:input_ok==0? Colors.white:Colors.red), 
                            ),
                            helperText: input_ok==0? null: "輸入長度請介於1~7個字",
                            helperStyle: TextStyle(color: Colors.red,)
                            
                          ),onChanged: (value) {
                            // print("valur=${value.length}");
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
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Material(
                     color: Colors.transparent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Column(
                        children: [
                          Container(margin: EdgeInsets.only(bottom: 10),child: Text("Step 2: 選擇用戶頭貼",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Material(
                                color: choose_for_profile==0? Pallete.commentColor:Colors.transparent,
                                child: SizedBox(
                                  width: 150,
                                  height: 200,
                                  child:  TextButton(child: ClipRRect(borderRadius: BorderRadius.circular(150),child: Image.asset("photos/profile_0.png",width: 120,height: 120,),)
                                  ,onPressed: (){
                                      choose_for_profile=0;
                                      print("choose_for_profile=${choose_for_profile}");
                                      setState(() {});
                                  },) ,
                                ),
                              )
                
                              ,Material(
                                color: choose_for_profile==1? Pallete.commentColor:Colors.transparent,
                                child: SizedBox(
                                  width: 150,
                                  height: 200,
                                  child:  TextButton(child: ClipRRect(borderRadius: BorderRadius.circular(150),child: Image.asset("photos/profile_1.png",width: 120,height: 120,))
                                  ,onPressed: (){
                                      choose_for_profile=1;
                                       print("choose_for_profile=${choose_for_profile}");
                                      setState(() {});
                                  },) ,
                                ),
                              ),
                            ]
                            
                  
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Material(
                    color: Colors.transparent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Column(
                        children: [
                          Text("Step 3: 選擇稱號",style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,),
                          SizedBox(
                            height: 10,
                          ),
                         Column(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Material(
                                    color: choose_for_title==0? Pallete.commentColor:Colors.transparent,
                                    child: TextButton(
                                      child: Text("NBA支持者",style: TextStyle(fontSize: 15,color: Colors.white),textAlign: TextAlign.center,),
                                      onPressed: (){
                                          choose_for_title=0;
                                          print("Choose_for_title=${choose_for_title}");
                                          setState(() {
                                            
                                          });
                                      },
                                    ),
                                  ),
                              ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Material(
                                color: choose_for_title==1? Pallete.commentColor:Colors.transparent,
                                child: TextButton(
                                  child: Text("MLB支持者",style: TextStyle(fontSize: 15,color: Colors.white),textAlign: TextAlign.center,),
                                  onPressed: (){
                                      choose_for_title=1;
                                      print("Choose_for_title=${choose_for_title}");
                                      setState(() {
                                        
                                      });
                                  },
                                ),
                              ),
                            )
                           ],
                         ),
                        
                          
                      
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(30),
                  child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: input_ok==-1||choose_for_profile==-1||choose_for_title==-1?  Pallete.commentColor:Colors.green), child: Text("點我提交")
                  ,onPressed: ()async{
                      print("choose_for_profile=${choose_for_profile}");
                       print("choose_for_title=${choose_for_title}");
                       print("input_name.text=${input_name.text}");
                      if(choose_for_profile==-1||choose_for_title==-1||input_ok==-1){
                        print("submit not valid");
                        //maybe popup
                      }else{
                          DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                          await dbref.set(
                          {
                            "last_check_in":"20020708000000",
                            "profile":choose_for_profile,
                            "user_money":5000,
                            "user_name":input_name.text,
                            "user_title":common_data.title_table[choose_for_title],
                          });
                          DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Users_History").child(global_email).child("Default");
                          await dbref2.set(
                            {
                              "non":"sense"
                            }
                          );
                          DatabaseReference dbref3= await FirebaseDatabase.instance.ref("Users_Own").child(global_email).child("profile").child("0");
                          await dbref3.set(
                            {
                                "No":0,
                                "name":"男士"
                            }
                          );
                          DatabaseReference dbref3_2= await FirebaseDatabase.instance.ref("Users_Own").child(global_email).child("profile").child("1");
                          await dbref3_2.set(
                            {
                                "No":1,
                                "name":"女士"
                            }
                          );
                           DatabaseReference dbref3_3= await FirebaseDatabase.instance.ref("Users_Own").child(global_email).child("profile").child("Default");
                          await dbref3_3.set(
                            {
                                "No":-1,
                                "name":"Default"
                            }
                          );
                          DatabaseReference dbref4= await FirebaseDatabase.instance.ref("Users_Own").child(global_email).child("title").child("0");
                          await dbref4.set(
                            {
                                "No":0,
                                "name":"NBA支持者"
                            }
                          );
                          DatabaseReference dbref4_2= await FirebaseDatabase.instance.ref("Users_Own").child(global_email).child("title").child("1");
                          await dbref4_2.set(
                            {
                                "No":1,
                                "name":"MLB支持者"
                            }
                          );
                          DatabaseReference dbref4_3= await FirebaseDatabase.instance.ref("Users_Own").child(global_email).child("title").child("Default");
                          await dbref4_3.set(
                            {
                               "No":-1,
                               "name":"Default"
                            }
                          );
                          Navigator.pushNamed(context, "/Home_Page");
                          String ?resultData = await Navigator.push(context,
                           MaterialPageRoute(builder:(BuildContext context) {
                            return DefaultTabController(initialIndex: 2,length: 7, child: MyHomePage(title: 'My Casino',email:global_email));
                          }) 
                        );
                if(resultData!=null){
                    print("when i was being delete in enroll page ${resultData}");
                    account_exist=0;
                    // Navigator.pushNamed(context, "/Login_page");
                    // Navigator.pop(context);
                }
      }
                      
                  },),
                ),

            ],
          ),
        ),
    );
  }
}
