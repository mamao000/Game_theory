import 'package:flutter/material.dart';
import 'Pallete.dart';
import 'team_nba.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'auth_server.dart';
import 'main.dart';
import 'dart:math';

class LoginScreen extends StatefulWidget{
  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {

  int accumulate=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
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
        title: const Text(
          "登入",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "歡迎來到  ",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                              child: Text(
                                "賽局理論",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 30,
                                  color: Pallete.primaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                        // Padding(
                        //     padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        //     child: Text(
                        //       "期待您玩得盡興",
                        //       textAlign: TextAlign.start,
                        //       overflow: TextOverflow.clip,
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.w400,
                        //         fontStyle: FontStyle.normal,
                        //         fontSize: 14,
                        //         color: Colors.white,
                        //       ),
                        //     )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'photos/monkey.png'),
                      //change!!
                      fit: BoxFit.fitHeight),
                  // shape: BoxShape.circle,
                ),
              ),
            ),
            Container(height: 30,),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                      int num1=Random().nextInt(1000);
                      int num2=Random().nextInt(1000);
                      

                      //random email
                      String fake_email=num1.toString()+num2.toString();
                      global_email=fake_email;
                      isfaker=1;

                      // global_email=999999999999.toString();

                      print("global_email in login page=${global_email}");
                      //account exist=1
                      account_exist=1;

                      //go to sign in
                      Navigator.pushNamed(context,"/Enroll_in");
                      

                  },
                  child: Text(
                    "訪客登入",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Pallete.blueSideColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {
                    print("accumulate=${accumulate}");
                  if(accumulate==0){
                    accumulate++;
                    AuthService().signInWithGoogle();
                  }else if(accumulate==2){
                    accumulate=0;
                  }else{
                    accumulate++;
                  }
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.googlePlusG,
                    color: Colors.black,
                  ),
                  label: Text(
                    "繼續使用Google",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
            //   child: SizedBox(
            //     width: MediaQuery.of(context).size.width * 0.8,
            //     height: 40,
            //     child: ElevatedButton.icon(
            //       onPressed: () {},
            //       icon: FaIcon(
            //         FontAwesomeIcons.facebook,
            //         color: Colors.black,
            //       ),
            //       label: Text(
            //         "繼續使用Facebook",
            //         style: TextStyle(
            //             fontSize: 16,
            //             color: Colors.black,
            //             fontWeight: FontWeight.w600),
            //       ),
            //       style: ButtonStyle(
            //         backgroundColor:
            //             MaterialStateProperty.all<Color>(Colors.white),
            //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //           RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(20),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
