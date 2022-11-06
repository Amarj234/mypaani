import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mypaani/servise.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icicon=false;
  bool isbill=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setname();
  }
  Serves serves=Serves();
  String? cid;
  String? name;


  setname()async {
    final uri = Uri.parse(serves.url+"singlecust.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
    cid =prefs.getString('cid');
    print('amar $cid');
    var response = await http.post(uri,body: {
      'cid':cid,

    });
    var state= json.decode(response.body);
    setState((){
      name=state[0]['name'];
    });


  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [




              Container(
                color: Color(0xff74eedc),
                // height: MediaQuery
                //     .of(context)
                //     .size
                //     .height ,
                child: Column(

                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(

                      children: [
                        IconButton(
                          onPressed: () {},

                          icon: Icon(
                            Icons.arrow_back_ios, size: 30, color: Colors.white,),

                        ),

                        Expanded(child: Center(
                          child: Text(name.toString(), style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 25,
                              fontFamily: 'RobotoMono'
                          ),),
                        )),

                        IconButton(
                          onPressed: () {},

                          icon: Icon(Icons.arrow_forward_ios, size: 30,
                            color: Colors.white,),

                        ),
                      ],

                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Center(
                            child: Row(
                              children: [
                                SizedBox( width:MediaQuery.of(context).size.width/6),
                                Icon(Icons.file_copy_rounded,size: 30,color: Colors.blueAccent,),

                                SizedBox(width: 10,),
                                Text('Customer Bills',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.blueAccent),),



                              ],
                            ),
                          ),
                        ),),
                    ),


                    InkWell(
                      onTap: (){

                          if(isbill==false){
                            setState(() {
                              icicon=true;
                              isbill=true;
                              print(icicon);
                            });

                          }else{
                            print(icicon);
                            setState(() {
                              icicon=false;
                              isbill=false;
                            });
                          }

                      },
                      child: Card(
                        color:  Color(0xff0840c4),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  8.2, 12, 0, 12),
                              child: Icon(
                                Icons.calendar_today_outlined, size: 25,
                                color: Colors.blue,),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('5 May 2022', style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  fontFamily: 'RobotoMono'
                              ),),
                            ),
                            SizedBox(width: MediaQuery
                                .of(context)
                                .size
                                .width / 10),
                         Visibility(
                           visible: icicon,
                           child:  IconButton(onPressed: (){}, icon: Icon(Icons.edit_rounded,size: 30,color: Colors.white,)),
                         ),
                            Visibility(
                              visible: icicon,
                              child:  IconButton(onPressed: (){}, icon: Icon(Icons.flip_camera_android_rounded,size: 30,color: Colors.white,)),
                            ),
                            SizedBox(width: MediaQuery
                                .of(context)
                                .size
                                .width / 10),
                            Container(
                              height: 20,

                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue)
                              ),
                            ),
                            SizedBox(width: 15,),
                        Icon(Icons.keyboard_arrow_down_sharp,size: 30,color: Colors.white,),

                          ],
                        ),
                      ),
                    ),

Visibility(
    visible:isbill ,
    child: Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Text('Billing Period', style: TextStyle(
color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 20,
      fontFamily: 'RobotoMono'
),),
          SizedBox(width: 60,),
          Expanded(
            child: Text('May 2022', style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 20,
                fontFamily: 'RobotoMono'
            ),),
          ),
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Text('Billing Date', style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 20,
              fontFamily: 'RobotoMono'
          ),),
          SizedBox(width: 60,),
          Expanded(
            child: Text('April 2022', style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 20,
                fontFamily: 'RobotoMono'
            ),),
          ),
        ],
      ),
    ),
    
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(width: 50,),
                Center(child: Icon(Icons.home_filled, size: 30,
                  color: Colors.blue,)),
                SizedBox(width: 20,),
                Expanded(
                  child: Text('Balance Jar', style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                      fontSize: 23,
                      fontFamily: 'RobotoMono'
                  ),),
                ),
                SizedBox(width: 20,),
                Icon(Icons.edit, size: 30, color: Colors.blue,)
              ],
            ),


            Row(
              children: [
                SizedBox(width: 20,),
                Text('3 ×', style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                    fontFamily: 'RobotoMono'
                ),),
                Image.asset('assets/cjar.png', height: 60,),
                Text('+ 1 × ', style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                    fontFamily: 'RobotoMono'
                ),),
                Image.asset('assets/jar.png', height: 40,),
                SizedBox(width: 5,),
                Text('+ 1 × ', style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                    fontFamily: 'RobotoMono'
                ),),
                Image.asset('assets/water.png', height: 40,),

                SizedBox(width: 10,),
                Text('=  5 ', style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                    fontFamily: 'RobotoMono'
                ),),
              ],
            )
          ],
        ),
      ),
    ),
    
    Card(

      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                      width:70,
                      child: Text('Per Chilled jar Price')),
                  Text('X'),
                  SizedBox(width: 10,),
                  SizedBox(
                      width:70,
                      child: Text('Total Chilled jar')),

                  SizedBox(width: 10,),
                  SizedBox(
                      width:60,
                      child: Text('(50 X 0)')),
                  Image.asset('assets/rup.png',width: 20,height: 20,),
                  SizedBox(width: 10,),
                  SizedBox(
                      width:70,
                      child: Text('0')),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                border: Border(
                  // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
                  bottom: BorderSide(width: 1.0, color: Colors.lightBlue.shade900),
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                      width:70,
                      child: Text('Per Capsule jar Price')),
                  Text('X'),
                  SizedBox(width: 10,),
                  SizedBox(
                      width:70,
                      child: Text('Total Capsule jar')),

                  SizedBox(width: 10,),
                  SizedBox(
                      width:60,
                      child: Text('(50 X 0)')),
                  Image.asset('assets/rup.png',width: 20,height: 20,),
                SizedBox(width: 10,),
                  SizedBox(
                      width:70,
                      child: Text('0')),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
                  bottom: BorderSide(width: 1.0, color: Colors.lightBlue.shade900),
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                      width:70,
                      child: Text('Only Water Price')),
                  Text('X'),
                  SizedBox(width: 10,),
                  SizedBox(
                      width:70,
                      child: Text('Total water')),

                  SizedBox(width: 10,),
                  SizedBox(
                      width:60,
                      child: Text('(50 X 0)')),
                  Image.asset('assets/rup.png',width: 20,height: 20,),
                  SizedBox(width: 10,),
                  SizedBox(
                      width:70,
                      child: Text('0')),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
                  bottom: BorderSide(width: 2.0, color: Colors.lightBlue.shade900),
                ),

              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                      width:70,
                      child: Text('Month Amount')),

                  SizedBox(width: 160,),

                  Image.asset('assets/rup.png',width: 20,height: 20,),
                  SizedBox(width: 10,),
                  SizedBox(
                      width:70,
                      child: Text('0')),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
                  bottom: BorderSide(width: 2.0, color: Colors.lightBlue.shade900),
                ),

              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                      width:70,
                      child: Text('Last Month Amount')),

                  SizedBox(width: 160,),

                  Image.asset('assets/rup.png',width: 20,height: 20,),
                  SizedBox(width: 10,),
                  SizedBox(
                      width:70,
                      child: Text('0')),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
                  bottom: BorderSide(width: 2.0, color: Colors.lightBlue.shade900),
                ),

              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                      width:70,
                      child: Text('April 2022 Payments')),

                  SizedBox(width: 160,),

                  Image.asset('assets/rup.png',width: 20,height: 20,),
                  SizedBox(width: 10,),
                  SizedBox(
                      width:70,
                      child: Text('0')),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
                  bottom: BorderSide(width: 2.0, color: Colors.lightBlue.shade900),
                ),

              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                      width:70,
                      child: Text('Total')),

                  SizedBox(width: 160,),

                  Image.asset('assets/rup.png',width: 20,height: 20,),
                  SizedBox(width: 10,),
                  SizedBox(
                      width:70,
                      child: Text('500')),
                ],
              ),
            ),


          ],
        ),
      ),
    ),

    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('Download Previous Month Bills'),
        ),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),

        ),
      ),
    ),
    
  ],
))




                  ],
                ),

              ),

  ]
        ),
      )
      )
    );
  }
}
