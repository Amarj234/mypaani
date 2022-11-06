import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mypaani/src/Widget/showveder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'maindashboard.dart';
import 'src/Widget/dashboard.dart';
import 'src/loginPage.dart';


class loaddata extends StatefulWidget {
  const loaddata({Key? key}) : super(key: key);

  @override
  State<loaddata> createState() => _loaddataState();
}

class _loaddataState extends State<loaddata> {


  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () => chechlogin());

  }
  chechlogin()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var login= prefs.getString('login');
    print(login);
    if(login=='2'){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => maindashboard(),
          ));

    }else if(login=='1') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => showvender(),
          ));

    }else if(login=='3') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => dashboard(),
          ));

    }else{
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));

    }

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/water.png"),
          fit: BoxFit.cover,
        ),
        color: Colors.pinkAccent
      ),
    );
  }
}
