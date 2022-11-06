import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mypaani/src/signup.dart';
import 'Widget/bezierContainer.dart';
import 'autotp.dart';
import 'costregister.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


final mobile= TextEditingController();


  void _sendDataToSecondScreen(BuildContext context) {
    var mobile1 = mobile.text;
    if (mobile.text.length == 10) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => autoOtp(mobile1: mobile1,),
          ));
    }else{
      EasyLoading.showError('Please Enter correct Mobile No.');

    }
  }





  Widget _submitButton() {
    return InkWell(
      onTap: (){
        // Navigator.push(
        //   context,MaterialPageRoute(builder: (context)=> searchplace()),
        // );


        _sendDataToSecondScreen(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Submit',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }





  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'My',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)
          ),
          children: [
            TextSpan(
              text: 'paa',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'ni',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Card(

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
           Center(
             child: Text('Enter your Phone Number',style: TextStyle(
               fontSize: 22,
               fontWeight:FontWeight.w800
                 ,
               color:  Color(0xfffbb448),

             ),
             ),
           ),
           SizedBox(
             height: 60,
             child: TextFormField(
               controller: mobile,
               maxLength: 10,
               decoration: new InputDecoration(
                   hintText: "Enter your number",
                 icon: Icon(Icons.phone_android)

               ),
               keyboardType: TextInputType.number,
               // Only numbers can be entered
             ),
           ),
            SizedBox(
              height: 20,
            ),
            _submitButton(),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

DateTime? currentBackPressTime;
Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    SystemNavigator.pop();
    exit(0);

  }
  return Future.value(true);
}


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: WillPopScope(
          onWillPop: onWillPop ,
          child: Container(
      height: height,
      child: Stack(
          children: <Widget>[
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(height: 50),
                    _emailPasswordWidget(),





                    SizedBox(height: height * .025),

Text('Are You New here'),

                    SizedBox(height: height * .025),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(bottomLeft:Radius.circular(40.0) ,topLeft: Radius.circular(40.0)),
                                          side: BorderSide(color: Color(0xfffbb448))
                                      )
                                  )
                              ),
                            onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => costregister(),
                                ));

                          },child: SizedBox(
                              width: 100,
                              child: Text('   Register  ')),),
SizedBox(width: 5,),
                          ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(bottomRight:Radius.circular(40.0) ,topRight: Radius.circular(40.0)),
                                        side: BorderSide(color:  Color(0xfffbb448))
                                    )
                                )
                            ),
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpPage(),
                                  ));

                            },child: SizedBox(
                              width: 100,child: Text('Work with us')),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),



          ],
      ),
    ),
        ));
  }
}
