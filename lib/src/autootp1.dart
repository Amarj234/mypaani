import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mypaani/src/pandingvander.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

import '../servise.dart';

class autoOtp1 extends StatefulWidget {

  const autoOtp1({Key? key,required this.name1  , required this.mobile1,required this.email1, required this.address1, required this.cname1, required this.piccode1, required this.dob1, required this.jdate1, required this.upino1, required this.gstno1, }) : super(key: key);
  final String mobile1;
  final String name1;
  final String email1;
  final String address1;
  final String cname1;
  final String piccode1;
  final String dob1;
  final String jdate1;
  final String gstno1;
  final String upino1;

  @override
  _autoOtp1State createState() => _autoOtp1State();
}

class _autoOtp1State extends State<autoOtp1> {

  Serves serves=Serves();


  Future checkOtp(String code) async{
    print(widget.mobile1);

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

print('vender');
    var url3 = Uri.parse(serves.url+"addvender.php");
    var response = await http.post(url3, body: {
      'name': widget.name1,
      'mobile': widget.mobile1,
      'email': widget.email1,
      'address': widget.address1,
      'pincode': widget.piccode1,
      'dob': widget.dob1,
      'jdate': widget.jdate1,
      'cname': widget.cname1,
      'upiid': widget.upino1,
      'gstno': widget.gstno1,

    });
    print('save data');
    if (response.statusCode == 200) {
      var check1 =jsonDecode(response.body);


        setsesiion(check1);

    }
  }

  setsesiion(vid) async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    prefs.setString('mobile', widget.mobile1);
    prefs.setString('name', widget.name1);
    prefs.setString('login', '2');
    prefs.setString('vid', vid);
    Navigator.push(
      context,MaterialPageRoute(builder: (context)=> paddingvender()),
    );
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    _listenotp();
    checklogin();
  }

  void checklogin() async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    String? token=    prefs.getString('token');
    if(token!=null){
      // Navigator.push(
      //   context,MaterialPageRoute(builder: (context)=> dashbord()),
      // );

    }
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
