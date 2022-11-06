import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mypaani/maindashboard.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;
import '../servise.dart';
import 'Widget/dashboard.dart';
import 'Widget/showveder.dart';


class autoOtp extends StatefulWidget {

  const autoOtp({Key? key,required this.mobile1,}) : super(key: key);
  final String mobile1;


  @override
  _autoOtpState createState() => _autoOtpState();
}

class _autoOtpState extends State<autoOtp> {

  Serves serves=Serves();



  Future checkOtp(String code) async{

print('8382946376');
    var url2 = Uri.parse(serves.url+"checkotp.php");
    var response = await http.post(url2, body: {
      'mobile': widget.mobile1,
      'otp':code,
    });
print(response.body);
    if (response.statusCode == 200) {

      var check =jsonDecode(response.body);

      if(check==1){

        checknew();

      }else{

      }
      // Navigator.push(
      //   context,MaterialPageRoute(builder: (context)=> autoOtp()),
      // );
    }
  }

  checknew() async{

    var url2 = Uri.parse(serves.url+"login.php");
    var response = await http.post(url2, body: {
      'mobile': widget.mobile1,
    });
print(response.body+"hgfj");
    if (response.statusCode == 200) {

      var data =jsonDecode(response.body);
      print(data);

      if(data['login']=='1'){
        setsesiion2(data['cid'],data['user'],data['login']);


      }else  if(data['login']=='2'){
        setsesiion(data['vid'],data['user'],data['login'],data['eid']);

      }else{
        getvender(data['vid'],data['user'],data['login'],data['eid']);

      }
      // Navigator.push(
      //   context,MaterialPageRoute(builder: (context)=> autoOtp()),
      // );
    }
  }

  getvender(vid,user,login,eid) async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    prefs.setString('mobile', widget.mobile1);
    prefs.setString('vid', vid);
    prefs.setString('name', user);
    prefs.setString('login', login);
    prefs.setString('eid', eid);
    Navigator.push(
      context,MaterialPageRoute(builder: (context)=> dashboard()),
    );

    }




  setsesiion2(cid,user,login)async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    prefs.setString('cid', cid);
    prefs.setString('name', user);
    prefs.setString('login', login);
    Navigator.push(
      context,MaterialPageRoute(builder: (context)=> showvender()),
    );
  }

  setsesiion(vid,user,login,eid)async{
    print(login);
    SharedPreferences prefs =await SharedPreferences.getInstance();
    prefs.setString('mobile', widget.mobile1);
    prefs.setString('vid', vid);
    prefs.setString('name', user);
    prefs.setString('login', login);
    prefs.setString('eid', eid.toString());
    Navigator.push(
      context,MaterialPageRoute(builder: (context)=> maindashboard()),
    );
  }

@override
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
    SharedPreferences prefs =await SharedPreferences.getInstance();
    final  gencode= await SmsAutoFill().getAppSignature;
    if(widget.mobile1.length==10) {
      var url4 = Uri.parse(serves.url+"sendotp.php");
      var response = await http.post(url4, body: {
        'mobile': widget.mobile1,
        'gencode':gencode,
      });
      if (response.statusCode == 200) {
        prefs.setString('mobile', widget.mobile1);
        print('OTP Sent on Your Mobile');
        // Navigator.push(
        //   context,MaterialPageRoute(builder: (context)=> autoOtp()),
        // );
      }
    }
  }
  final codea  = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
SizedBox(height: MediaQuery.of(context).size.height/12,),
Image.asset('assets/otpsms.png',width:250),
              SizedBox(height: MediaQuery.of(context).size.height/16,),
              Center(child: Text("OTP Verification",style: TextStyle(fontSize: 30),)),
              SizedBox(
                height: 10,
              ),
              Center(child: Text('We Will Send Your One time Password ')),
              Center(child: Text(' On Your Mobile Number')),
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
    );
  }
}
