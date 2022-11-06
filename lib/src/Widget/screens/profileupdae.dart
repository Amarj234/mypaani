import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../servise.dart';


class profileupdate extends StatefulWidget {
  const profileupdate({Key? key}) : super(key: key);

  @override
  State<profileupdate> createState() => _profileupdateState();
}

class _profileupdateState extends State<profileupdate> {


  String? value;
  bool paymetvs = false;
  bool disableddropdown = true;
  bool disabledseen = true;

  Future updatepro() async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var cid =prefs.getString('cid');
    var vid =prefs.getString('vid');
    var url2 = Uri.parse(serves.url+"updatecostomer.php");
    var response = await http.post(url2, body: {
      'name':name.text,
      'mobile':mobile.text,
      'email':email.text,
      'address':address.text,
      'pincode':piccode.text,
      'cjarprice':coldjarprice.text,
      'capjarpri':capjarprice.text,
      'waterprice':waterprice.text,
      'cid':cid.toString(),
      'vid':vid.toString(),

    });

    if (response.statusCode == 200) {
      EasyLoading.showSuccess('Update Success!');


    }

  }






  String dropdownValue = 'Feburuary 2022';
  final name =      TextEditingController();
  final mobile =     TextEditingController();
  final email =     TextEditingController();
  final address =    TextEditingController();
  final piccode =    TextEditingController();
  final coldjarprice  = TextEditingController();
  final capjarprice   = TextEditingController();
  final waterprice    = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text ="";
        mobile.text ="";
        email.text ="";
        address.text ="";
        piccode.text ="";
        coldjarprice.text ="";
    capjarprice.text ="";
    waterprice.text ="";


    setname();
  }

bool load=true;
  Serves serves=Serves();
String? cname;


  setname()async {
    final uri = Uri.parse(serves.url+"singlecust1.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
   var cid =prefs.getString('cid');

    var response = await http.post(uri,body: {
      'cid':cid,

    });
    var state= json.decode(response.body);
print(state);
    setState(() {
      cname=state[0]['name'].toString();    });

     name.text=state[0]['name'];
     if(state[0]['mobile']!=null){
       mobile.text =state[0]['mobile'];
     }
    if(state[0]['email']!=null){
      email.text =state[0]['email'];
    }
    if(state[0]['address']!=null){
      address.text =state[0]['address'];
    }

    if(state[0]['pincode']!=null){
      piccode.text =state[0]['pincode'];
    }
    if(state[0]['coldjarprice']!=null){
      coldjarprice.text =state[0]['coldjarprice'];
    }
    if(state[0]['capsulejarprice']!=null){
      capjarprice.text =state[0]['capsulejarprice'];
    }
    if(state[0]['whaterprice']!=null){
      waterprice.text =state[0]['whaterprice'];
    }


    load=false;

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load? Center(child: CircularProgressIndicator()):  SafeArea(

        child:Container(
          color: Color(0xffffffff),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  color: Color(0xff74eedc),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 10,
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
                            child: Text(cname.toString(), style: TextStyle(
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
                    


                    ],
                  ),

                ),

SizedBox(height: 20,),



                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18),
                  child: TextFormField(
controller: name,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      hintText: 'Enter Name ',
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)
                      ),
                      label: Text('Enter Name'),

                    ),
                    style: TextStyle(color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),

                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18),
                  child: TextFormField(
controller: mobile,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      hintText: 'Enter mobile ',
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)
                      ),
                      label: Text('Enter mobile'),

                    ),
                    style: TextStyle(color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),

                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18),
                  child: TextFormField(
controller: email,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      hintText: 'Enter Email ',
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)
                      ),
                      label: Text('Enter Email'),

                    ),
                    style: TextStyle(color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),

                  ),
                ),
SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18),
                  child: TextFormField(
controller: address,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      hintText: 'Enter Address ',
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)
                      ),
                      label: Text('Enter Address'),

                    ),
                    style: TextStyle(color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),

                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18),
                  child: TextFormField(
controller: piccode,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      hintText: 'Enter PinCode ',
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)
                      ),
                      label: Text('Enter PinCode'),

                    ),
                    style: TextStyle(color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),

                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18),
                  child: TextFormField(
controller: coldjarprice,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      hintText: 'Enter coldjar price ',
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)
                      ),
                      label: Text('Enter coldjar price'),

                    ),
                    style: TextStyle(color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),

                  ),
                ),
                SizedBox(height: 10,),
            Padding(
      padding: const EdgeInsets.symmetric(
            horizontal: 18),
      child: TextFormField(
controller: capjarprice,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 4.0),
          hintText: 'Enter capsulejar price',
          border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.blue)
          ),
          label: Text('Enter capsulejar price'),

        ),
        style: TextStyle(color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400),

      ),
    ),

                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18),
                  child: TextFormField(
controller: waterprice,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      hintText: 'Enter whater price',
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)
                      ),
                      label: Text('Enter whater price'),

                    ),
                    style: TextStyle(color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),

                  ),
                ),
                SizedBox(height: 10,),
                InkWell(
               onTap: (){
                 updatepro();
               },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('Update'),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),

                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      )
    );
  }
}
