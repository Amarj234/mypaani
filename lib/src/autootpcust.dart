import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mypaani/src/pandingvander.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

import '../servise.dart';
import 'Widget/showveder.dart';

class autoOtp2 extends StatefulWidget {

  const autoOtp2({Key? key,required this.name1  , required this.mobile1,required this.email1, required this.address1,  required this.piccode1,  }) : super(key: key);
  final String mobile1;
  final String name1;
  final String email1;
  final String address1;

  final String piccode1;


  @override
  _autoOtp2State createState() => _autoOtp2State();
}

class _autoOtp2State extends State<autoOtp2> {

  Serves serves=Serves();


  Future checkOtp(String code) async{
    print(code);

    var url2 = Uri.parse(serves.url+"checkotp.php");

    var response = await http.post(url2, body: {
      'mobile': widget.mobile1,
      'otp':code,
    });


    if (response.statusCode == 200) {

      var check =jsonDecode(response.body);
      print(check);
      if(check==1){
        Savedata();
      }else{
        setState(() {
          SnackBar(content: Text('Wrrong Otp'));
        });


      }
      // Navigator.push(
      //   context,MaterialPageRoute(builder: (context)=> autoOtp()),
      // );
    }
  }



  Future Savedata() async{


    var url3 = Uri.parse(serves.url+"addselfcost.php");
    var response = await http.post(url3, body: {
      'name': widget.name1,
      'mobile': widget.mobile1,
      'email': widget.email1,
      'address': widget.address1,
      'pincode': widget.piccode1,


    });
    print('save data');
    if (response.statusCode == 200) {
      var check1 =jsonDecode(response.body);
// print(check1);

      setsesiion(check1);

    }
  }

  setsesiion(cid)async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    prefs.setString('mobile', widget.mobile1);
    prefs.setString('name', widget.name1);
    prefs.setString('login', '1');
    prefs.setString('cid', cid);
    Navigator.push(
      context,MaterialPageRoute(builder: (context)=> showvender()),
    );
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    _listenotp();

  }





  _listenotp() async{
    await SmsAutoFill().listenForCode;
    await sendotpf();
  }


  Future sendotpf() async{

    final  gencode= await SmsAutoFill().getAppSignature;
    if(widget.mobile1.length==10) {
      var url4 = Uri.parse(serves.url+"sendotp.php");
      print(url4);

      var response = await http.post(url4, body: {
        'mobile': widget.mobile1,
        'gencode':gencode,
      });
      print('otpsend');
      print(response.statusCode);
      if (response.statusCode == 200) {

        SnackBar(content: Text('OTP Sent on Your Mobile'));
        // Navigator.push(
        //   context,MaterialPageRoute(builder: (context)=> autoOtp()),
        // );
      }
    }
  }
  final codea  = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("OTP Verification",style: TextStyle(fontSize: 30),),
                SizedBox(
                  height: 10,
                ),
                Text('We Will Send Your One time Password '),
                Text(' On Your Mobile Number'),
                SizedBox(
                  height: 20,
                ),
                PinFieldAutoFill(
                  controller: codea,
                  decoration: UnderlineDecoration(
                    textStyle: TextStyle(fontSize: 20, color: Colors.black),
                    colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
                  ),

                  onCodeSubmitted: (code) {
                    checkOtp(code);
                  },
                  onCodeChanged: (code) {
                    if (code!.length == 6) {
                      checkOtp(code);

                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(onPressed: (){

                  checkOtp(codea.text);


                },
                    child: Text('VERIFY')
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
