import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../servise.dart';
import 'Widget/dashboard.dart';


class paddingvender extends StatefulWidget {
  const paddingvender({Key? key}) : super(key: key);

  @override
  State<paddingvender> createState() => _paddingvenderState();
}

class _paddingvenderState extends State<paddingvender> {
  @override



  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () => chechlogin());

  }
  bool load=true;
  Serves serves=Serves();
  String? cname;
  chechlogin() async{

    final uri = Uri.parse(serves.url+"singlevender.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var vid =prefs.getString('vid');

    var response = await http.post(uri,body: {
      'showdata':vid,

    });
    var state= json.decode(response.body);

    setState(() {
      cname=state[0]['name'].toString();    });
if(state[0]['status']=='1'){

  Navigator.push(
    context,MaterialPageRoute(builder: (context)=> dashboard()),
  );

}



  }




  Widget build(BuildContext context) {

    return SafeArea(child: Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height/5,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome ',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w400,fontSize: 25), ),
              Text('  $cname',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 20), )
            ],
          ),
          SizedBox(height: 10,),
          Text('Your Membership is Pending For Approval . . . . . .'),

          SizedBox(height: 20,),

          ElevatedButton(onPressed: (){chechlogin();}, child: Text('Refrash')),
        ],
      ),
    ));
  }
}
