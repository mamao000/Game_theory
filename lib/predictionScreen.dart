import 'package:flutter/material.dart';
import 'team_nba.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Pallete.dart';
import 'main.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class PredictionScreen extends StatefulWidget {
  
  DateTime now=DateTime(2002,07,08,00,00,00);
  DateTime tomorrow=DateTime(2002,07,08,00,00,00);
  _PredictionScreen this_page = new _PredictionScreen();

  PredictionScreen(this_time){
    // print("in main_page , now=${this_time}");
    now=DateTime(this_time.year,this_time.month,this_time.day,0,0,0);
    tomorrow=now.add(Duration(days: 1));
  //  print("in main_page , now=${now} , tomorrow=${tomorrow}");
  //  print(now.isBefore(tomorrow));
  }

  void trans_refresh(){
      this_page.refresh();
  }

  void listen(int value){
    // this.sort_way=value;
    // print("got value: "+this.sort_way.toString());
    this_page.lets_sorting(value);
  }
  
  @override
  State<PredictionScreen> createState() {
    // print("creating...");
    return this_page;
  } 
}

class _PredictionScreen extends State<PredictionScreen> {

  int doing_for_nba=1;
  int doing_for_mlb=1;
  int loading=0;
  int state_sorting_way=1;
  int refresh_or_not=1;
  int show_nothing=0;


  String game_select="NBA";

  List<Game> game_array=[];
  List<Game> MLB_array=[];
  
  Timer ?tic_tac;

double find_max(double a, double b){
      return a>=b?  a: b;
  }

  String math_display(dynamic i){
      if(i>=1000&&i<1000000){
        return (i/1000).toStringAsFixed(1)+" K";
      }else if(i>=1000000){
        return (i/1000000).toStringAsFixed(1)+" M";
      }else return i.toString();
  }

void initState(){
    refresh_or_not=1;
    print("state: initstate");
    super.initState();
    initial_array();
    Timer tic_tac=Timer.periodic(Duration(minutes: 10), (timer) { 
        refresh();
        // print("done refreshing");
    });
  }

void initial_array() async{ //not synchronic
    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling/");
    final snap=await dbref.get();
    loading=1;
    if(snap.exists){
      show_nothing=0;
      print("i got it");
      dynamic get=snap.value;
      get.forEach((key, value) {
      //  print("key,key[1]=${key[0]}");
        Map diction=get[key];
        String temp_time=diction["TTS"];
        DateTime TTS=DateTime.utc(int.parse(temp_time.substring(0, 4)),int.parse(temp_time.substring(4, 6)),int.parse(temp_time.substring(6, 8)),int.parse(temp_time.substring(8, 10)),int.parse(temp_time.substring(10, 12)),int.parse(temp_time.substring(12, 14)));
        
        // print(TTS);
        // if status==2 else
        //
        // print("now=${widget.now},after=${widget.tomorrow}");
        // print("TTS=${TTS}"); 
        if(TTS.isAfter(widget.now)&&TTS.isBefore(widget.tomorrow)){
          if(key[0]=="N"){
            // print(NBATeam.name[diction["team1"]]);
             game_array.add(Game(NBATeam.name[diction["team1"]],NBATeam.name[diction["team2"]],diction["odd1"].toDouble(),diction["odd2"].toDouble(),diction["people_num1"],diction["people_num2"],diction["dollar1"], diction["dollar2"], diction["status"],diction["ans"], diction["folder"],TTS));  // to here
          }else{
             MLB_array.add(Game(NBATeam.name[diction["team1"]],NBATeam.name[diction["team2"]],diction["odd1"],diction["odd2"],diction["people_num1"],diction["people_num2"],diction["dollar1"], diction["dollar2"], diction["status"],diction["ans"], diction["folder"],TTS));  // to here
          }
        }

        if(game_array.length!=0){
            doing_for_nba=0;
        }
        if(MLB_array.length!=0){
          doing_for_mlb=0;
        }
        
      });
      lets_sorting(state_sorting_way);
      // print("game+array=${game_array}");
      if(refresh_or_not==1){
          setState(() {});
        //for re-render
      }
      
    }else{
        show_nothing=1;
        print("I don't get it");
         if(refresh_or_not==1){
          setState(() {});
        //for re-render
      }
    }
    // await dbref.onValue.listen((event) {
    //   dynamic get=event.snapshot.value;
   
  }

  void lets_sorting(int sort_way){
    if(sort_way==0){ // ppl
        game_array.sort((a,b)=> (b.people_num1+b.people_num2).compareTo(a.people_num1+a.people_num2));
        game_array.sort((a, b) => a.status.compareTo(b.status));
      //   show_array1=[];
      //   show_array2=[];
      //   game_array.forEach((element) { 
      //     show_array1.add(element.people_num1);
      //     show_array2.add(element.people_num2);
      // });
    }else if(sort_way==1){ //money

      game_array.sort((a,b)=>(b.dollar1+b.dollar2).compareTo(a.dollar1+a.dollar2));
      game_array.sort((a, b) => a.status.compareTo(b.status));
      // show_array1=[];
      // show_array2=[];
      // game_array.forEach((element) { 
      //     show_array1.add(element.dollar1);
      //     show_array2.add(element.dollar2);
      // });
    }else if(sort_way==2 ){
        game_array.sort((a,b)=>find_max(b.odd1,b.odd2).compareTo(find_max(a.odd1,a.odd2)));
        game_array.sort((a, b) => a.status.compareTo(b.status));
        // show_array1=[];
        // show_array2=[];
        // game_array.forEach((element) { 
        //   show_array1.add(element.odd1);
        //   show_array2.add(element.odd2);
        // });
    }
    else{
      // game_array.forEach((element) {
      //   print("element=${element.TTL}");
      // });
      game_array.sort((a,b)=>(a.TTL).compareTo(b.TTL));
      game_array.sort((a, b) => a.status.compareTo(b.status));
      // show_array1=[];
      // show_array2=[];
      // game_array.forEach((element) { 
      //     show_array1.add(element.TTL.month.toString()+"/"+element.TTL.day.toString());
      //     show_array2.add(element.TTL.hour.toString()+":"+(element.TTL.minute.toString().length<2? "0"+element.TTL.minute.toString() : element.TTL.minute.toString()));
      //   });
      // game_array.forEach((element) { 
      //     show_array1.add(element.dollar1);
      //     show_array2.add(element.dollar2);
      // });
    }
    state_sorting_way=sort_way;
    if(refresh_or_not==1){
      
      setState(() {
      
      });
    }
   
  }

  void refresh(){
    print("refresh_or_not : ${refresh_or_not}");
    if(refresh_or_not==1){
       game_array=[];
      // show_array=[];
       initial_array();
    }
 
  }
  @override
  void dispose() {
    // TODO: implement dispose
    refresh_or_not=0;
    print("Deleting tic_tac");
    print(tic_tac);
    tic_tac?.cancel();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        bottom:     
          PreferredSize(
            preferredSize: Size.fromHeight(5),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: Pallete.cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 0, 0),
                            child: Container(
                              // color: Pallete.predictionColor,
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: MediaQuery.of(context).size.height * 0.04,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Pallete.predictionColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 0, 0, 0),
                                child: DropdownButton(
                                  items: const <String>[
                                    'NBA',
                                    'MLB'
                                  ] //change!!big one!!
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  value: game_select, //change!!
                                  onChanged:(value) {
                                    print(value);
                                    game_select=value.toString();
                                    setState(() {
                                      
                                    });
                                    // initial_array();
                                  }, //change!!  //if choose_for_one // else if choose_for_zero
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  underline: Container(),
                                  isExpanded: true,
                                  dropdownColor:  Pallete.predictionColor,
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                          child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 5, 0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.04,
                              child: ElevatedButton(
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Icon(
                                    Icons.attach_money,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    child: Text('點數',style: TextStyle(fontSize: 10, color: Colors.white),),
                                  ),
                                ]),
                                onPressed: () {
                                  lets_sorting(1);
                                }, //change!!
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 10),
                                  backgroundColor: state_sorting_way==1? Pallete.ugly_yellow: Pallete.predictionColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // minimumSize: Size(80, 25),
                                ),
                                // <-- Text
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 5, 0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.04,
                              child: ElevatedButton(
                                child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                  Icon(
                                    Icons.mood,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            2, 0, 0, 0),
                                    child: Text('賠率',style: TextStyle(fontSize: 10, color: Colors.white),),
                                  ),
                                ]),
                                onPressed: () {
                                  lets_sorting(2);
                                }, //change!!
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 10),
                                  backgroundColor: state_sorting_way==2? Pallete.ugly_yellow: Pallete.predictionColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // minimumSize: Size(80, 25),
                                ),
                                // <-- Text
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 5, 0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.04,
                              child: ElevatedButton(
                                child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                  Icon(
                                    Icons.people,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            2, 0, 0, 0),
                                    child: Text('人數',style: TextStyle(fontSize: 10, color: Colors.white),),
                                  ),
                                ]),
                                onPressed: () {
                                  lets_sorting(0);
                                }, //change!!
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 10),
                                  backgroundColor:state_sorting_way==0? Pallete.ugly_yellow: Pallete.predictionColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // minimumSize: Size(80, 25),
                                ),
                                // <-- Text
                              ),
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ),
          )
      ),

      body: SafeArea(
        child:
        (game_select=="NBA"&&doing_for_nba==1)||(game_select=="MLB"&&doing_for_mlb==1)? 
        Center(child:
          Container(child: Center(child: Text(loading==0? "Loading..." : "今天沒有比賽喔",style: TextStyle(fontSize: 15,color: Colors.white),)),),
        ):
        ListView.builder(itemCount: game_select=="NBA"? 1+game_array.length:1+MLB_array.length,itemBuilder: (context, index) {
          if(index==0){
            return  Container();
            // Padding(
            //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height * 0.06,
            //     decoration: BoxDecoration(
            //       color: Pallete.cardColor,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Align(
            //       alignment: AlignmentDirectional(0, 0),
            //       child: Row(
            //         mainAxisSize: MainAxisSize.max,
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Padding(
            //               padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
            //               child: Padding(
            //                 padding: const EdgeInsetsDirectional.fromSTEB(
            //                     10, 0, 0, 0),
            //                 child: Container(
            //                   // color: Pallete.predictionColor,
            //                   width: MediaQuery.of(context).size.width * 0.25,
            //                   height: MediaQuery.of(context).size.height * 0.04,
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(10),
            //                     color: Pallete.predictionColor,
            //                   ),
            //                   child: Padding(
            //                     padding: const EdgeInsetsDirectional.fromSTEB(
            //                         15, 0, 0, 0),
            //                     child: DropdownButton(
            //                       items: const <String>[
            //                         'NBA',
            //                         'MLB'
            //                       ] //change!!big one!!
            //                           .map((String value) {
            //                         return DropdownMenuItem<String>(
            //                           value: value,
            //                           child: Text(value),
            //                         );
            //                       }).toList(),
            //                       value: game_select, //change!!
            //                       onChanged:(value) {
            //                         print(value);
            //                         game_select=value.toString();
            //                         setState(() {
                                      
            //                         });
            //                         // initial_array();
            //                       }, //change!!  //if choose_for_one // else if choose_for_zero
            //                       style: TextStyle(
            //                           color: Colors.white, fontSize: 15),
            //                       underline: Container(),
            //                       isExpanded: true,
            //                       dropdownColor:  Pallete.predictionColor,
            //                     ),
            //                   ),
            //                 ),
            //               )),
            //           Expanded(
            //               child: Row(
            //             mainAxisSize: MainAxisSize.max,
            //             mainAxisAlignment: MainAxisAlignment.end,
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsetsDirectional.fromSTEB(
            //                     0, 0, 5, 0),
            //                 child: SizedBox(
            //                   width: MediaQuery.of(context).size.width * 0.2,
            //                   height: MediaQuery.of(context).size.height * 0.04,
            //                   child: ElevatedButton(
            //                     child: Wrap(children: [
            //                       Icon(
            //                         Icons.attach_money,
            //                         size: 15,
            //                       ),
            //                       Padding(
            //                         padding:
            //                             const EdgeInsetsDirectional.fromSTEB(
            //                                 2, 0, 0, 0),
            //                         child: Text('點數'),
            //                       ),
            //                     ]),
            //                     onPressed: () {
            //                       lets_sorting(1);
            //                     }, //change!!
            //                     style: ElevatedButton.styleFrom(
            //                       textStyle: TextStyle(fontSize: 10),
            //                       backgroundColor: state_sorting_way==1? Colors.yellow: Pallete.predictionColor,
            //                       shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(8),
            //                       ),
            //                       // minimumSize: Size(80, 25),
            //                     ),
            //                     // <-- Text
            //                   ),
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsetsDirectional.fromSTEB(
            //                     0, 0, 5, 0),
            //                 child: SizedBox(
            //                   width: MediaQuery.of(context).size.width * 0.2,
            //                   height: MediaQuery.of(context).size.height * 0.04,
            //                   child: ElevatedButton(
            //                     child: Wrap(children: [
            //                       Icon(
            //                         Icons.mood,
            //                         size: 15,
            //                       ),
            //                       Padding(
            //                         padding:
            //                             const EdgeInsetsDirectional.fromSTEB(
            //                                 2, 0, 0, 0),
            //                         child: Text('賠率'),
            //                       ),
            //                     ]),
            //                     onPressed: () {
            //                       lets_sorting(2);
            //                     }, //change!!
            //                     style: ElevatedButton.styleFrom(
            //                       textStyle: TextStyle(fontSize: 10),
            //                       backgroundColor: state_sorting_way==2? Colors.yellow: Pallete.predictionColor,
            //                       shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(8),
            //                       ),
            //                       // minimumSize: Size(80, 25),
            //                     ),
            //                     // <-- Text
            //                   ),
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsetsDirectional.fromSTEB(
            //                     0, 0, 5, 0),
            //                 child: SizedBox(
            //                   width: MediaQuery.of(context).size.width * 0.2,
            //                   height: MediaQuery.of(context).size.height * 0.04,
            //                   child: ElevatedButton(
            //                     child: Wrap(children: [
            //                       Icon(
            //                         Icons.people,
            //                         size: 15,
            //                       ),
            //                       Padding(
            //                         padding:
            //                             const EdgeInsetsDirectional.fromSTEB(
            //                                 2, 0, 0, 0),
            //                         child: Text('人數'),
            //                       ),
            //                     ]),
            //                     onPressed: () {
            //                       lets_sorting(0);
            //                     }, //change!!
            //                     style: ElevatedButton.styleFrom(
            //                       textStyle: TextStyle(fontSize: 10),
            //                       backgroundColor:state_sorting_way==0? Colors.yellow: Pallete.predictionColor,
            //                       shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(8),
            //                       ),
            //                       // minimumSize: Size(80, 25),
            //                     ),
            //                     // <-- Text
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ))
            //         ],
            //       ),
            //     ),
            //   ),
            // ) ;
          }else{
            if(doing_for_nba==0){
              return Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
              child: Material(
                color: Pallete.cardColor,  // here to change already color
                child: InkWell(
                  onTap: () {

                    

                    Navigator.pushNamed(context,"/Game",arguments:game_array[index-1].folder);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.19,
                    // decoration: BoxDecoration(
                    //   color: Pallete.cardColor,
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(5, 5, 0, 0),
                                child: Container(
                                  width: 70,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  decoration: BoxDecoration(),
                                  child: Image.asset(
                                    index-1<game_array.length? "NbaLogo/"+game_array[index-1].team1+".png":"photos/Default.png",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ), //change!!
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 0, 0),
                                  child: SizedBox(
                                    width: index-1<game_array.length? (game_array[index-1].team1.length<=3? 45: 30) :30,
                                    child: Text(
                                      index-1<game_array.length?game_array[index-1].team1:"", //cghange!!
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  )),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 5, 0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          decoration: BoxDecoration(
                                            color: Pallete.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            index-1<game_array.length? math_display(game_array[index-1].dollar1) : "", //change!!
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        )),
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 5, 0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          decoration: BoxDecoration(
                                            color: Pallete.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            index-1<game_array.length? "1:"+math_display(game_array[index-1].odd1):"", //change!!
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        )),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 5, 0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        decoration: BoxDecoration(
                                          color: Pallete.backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Text(
                                          index-1<game_array.length?math_display(game_array[index-1].people_num1):"", //change!!
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(5, 5, 0, 0),
                                child: Container(
                                  width: 70,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  decoration: BoxDecoration(),
                                  child: Image.asset(
                                    index-1<game_array.length? "NbaLogo/"+game_array[index-1].team2+".png":"photos/Default.png",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ), //change!!
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 0, 0),
                                  child: Text(
                                    index-1<game_array.length? game_array[index-1].team2:"", //change!!
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 5, 0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          decoration: BoxDecoration(
                                            color: Pallete.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            index-1<game_array.length?math_display(game_array[index-1].dollar2):"", //change!!
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        )),
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 5, 0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          decoration: BoxDecoration(
                                            color: Pallete.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            index-1<game_array.length? "1:"+math_display(game_array[index-1].odd2):"", //change!!
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        )),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 5, 0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        decoration: BoxDecoration(
                                          color: Pallete.backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Text(
                                          index-1<game_array.length?math_display(game_array[index-1].people_num2):"", //change!!
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            }else{
              return Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
              child: Material(
                color: Pallete.cardColor,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.19,
                    // decoration: BoxDecoration(
                    //   color: Pallete.cardColor,
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(5, 5, 0, 0),
                                child: Container(
                                  width: 70,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  decoration: BoxDecoration(),
                                  child: Image.network(
                                    'https://loodibee.com/wp-content/uploads/nba-atlanta-hawks-logo.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ), //change!!
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 0, 0),
                                  child: Text(
                                    "老鷹", //change!!
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 5, 0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          decoration: BoxDecoration(
                                            color: Pallete.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            "20k", //change!!
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        )),
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 5, 0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          decoration: BoxDecoration(
                                            color: Pallete.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            "1:1.02", //change!!
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        )),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 5, 0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        decoration: BoxDecoration(
                                          color: Pallete.backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Text(
                                          "45", //change!!
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(5, 5, 0, 0),
                                child: Container(
                                  width: 70,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  decoration: BoxDecoration(),
                                  child: Image.network(
                                    'https://loodibee.com/wp-content/uploads/nba-boston-celtics-logo.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ), //change!!
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 0, 0),
                                  child: Text(
                                    "賽爾提克", //change!!
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 5, 0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          decoration: BoxDecoration(
                                            color: Pallete.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            "280k", //change!!
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        )),
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 5, 0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          decoration: BoxDecoration(
                                            color: Pallete.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            "1:5.78", //change!!
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        )),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 5, 0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        decoration: BoxDecoration(
                                          color: Pallete.backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          shape: BoxShape.rectangle,
                                        ),
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Text(
                                          "39", //change!!
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ); 
            }

          }

        },)
      ),
    );
  }
}
