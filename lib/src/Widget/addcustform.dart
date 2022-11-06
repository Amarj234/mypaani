import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../servise.dart';
import 'dashboard.dart';

class addcostform extends StatefulWidget {
  const addcostform({Key? key}) : super(key: key);

  @override
  State<addcostform> createState() => _addcostformState();
}
bool paymetvs=false;
bool paymetvs2=false;
bool paymetvs3=false;
bool paymetvs4=false;
int coloris=1;
bool addisnal=false;

enum SingingCharacter { monthly, daily,fixprice }

SingingCharacter? _character1 = SingingCharacter.daily;

class _addcostformState extends State<addcostform> {

final name=TextEditingController();
final mobile=TextEditingController();
final cjarprice=TextEditingController();
final capjarpri=TextEditingController();
final waterprice=TextEditingController();
final address=TextEditingController();
final pincode=TextEditingController();
final email=TextEditingController();
Serves serves=Serves();

Saveaddress() async{

  SharedPreferences prefs =await SharedPreferences.getInstance();
  var vid= prefs.getString('vid');

  var url4 = Uri.parse(serves.url+"addcustomer.php");
  var response = await http.post(url4, body: {
    'vid':vid,
    'name': name.text,
    'mobile':mobile.text,
    'address':address.text.toString(),
    'cjarprice':cjarprice.toString(),
    'capjarpri': capjarpri.text.toString(),
    'pincode':pincode.text.toString(),
    'waterprice':waterprice.toString(),
     'email':email.text.toString(),

    'paymode':_character1.toString(),
    'delivery':coloris.toString()
  });
  print(vid);
  if (response.statusCode == 200) {
    Navigator.push(
      context,MaterialPageRoute(builder: (context)=> dashboard()),
    );
    // prefs.setString('vid',response.body);
    // prefs.setString('name',name.text);
    // Navigator.push(
    //   context,MaterialPageRoute(builder: (context)=> autoOtp()),
    // );
  }

}






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            ''
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          Icon(Icons.manage_accounts_rounded,size: 30,color: Colors.blueAccent,),

                          SizedBox(width: 10,),
                          Text('Add Customer',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.blueAccent),),



                        ],
                      ),
                    ),
                  ),),
              ),

              Container(
                  height: 30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text('Customer Information',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.blueAccent)),
                  )),
SizedBox(height: 10,),
Padding(
  padding: const EdgeInsets.all(8.0),
  child:   TextFormField(
    controller: name,
    decoration: InputDecoration(

    border:  OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.blue)),
    labelText: 'Name',
    hoverColor: Colors.black12,
    hintText: 'Enter Nmae',
    prefixIcon: Icon(Icons.account_box),
  ),),
),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:   TextFormField(
                  controller: mobile,
                  decoration: InputDecoration(

                  border:  OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.blue)),
                  labelText: 'Phone Number (Not requeird)',
                  hoverColor: Colors.black12,
                  hintText: 'Enter Phone Number',
                  prefixIcon: Icon(Icons.phone_android_outlined),
                ),),
              ),
              InkWell(
                onTap: (){
                  if(paymetvs==true){
                    setState(() {
                      paymetvs=false;
                    });

                  }else{
                    setState(() {
                      paymetvs=true;
                    });

                  }
                },
                child:   Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white70,
                    height: 40,
                    width: MediaQuery.of(context).size.width,

                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text('Add More Details',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
                          SizedBox( width:MediaQuery.of(context).size.width/5),
                          paymetvs ?  Icon(Icons.arrow_drop_down,size: 30,):Icon(Icons.arrow_forward_ios,size: 25,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible:paymetvs ,
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Payment Mode',style: TextStyle(color: Colors.lightBlueAccent,fontSize: 20,fontWeight: FontWeight.w600),),
                          Row(
                            children: [
                              Radio<SingingCharacter>(
                                value: SingingCharacter.monthly,
                                groupValue: _character1,
                                onChanged: (SingingCharacter? value) {
                                  setState(() {
                                    _character1 = value;
                                    print(value);
                                  });
                                },
                              ),
SizedBox(width: 10,),
                              Text('Monthly Basis',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                            ],

                          ),

      Row(
        children: [
          Radio<SingingCharacter>(
                                  value: SingingCharacter.daily,
                                  groupValue: _character1,
                                  onChanged: ( value) {
                                    setState(() {
                                      _character1 = value;
                                      print(value);
                                    });
                                  },
                                ),
          SizedBox(width: 10,),
          Text('Daily Paying',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),

        ],
      ),
   Row(
                            children: [
                              Radio<SingingCharacter>(
                                  value: SingingCharacter.fixprice,
                                  groupValue: _character1,
                                  onChanged: ( value) {
                                    setState(() {
                                      _character1 = value;
                                      print(value);
                                    });
                                  },
                                ),
                              SizedBox(width: 10,),
                              Text('Fixed Monthly',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),

                            ],
                          ),

                        ],
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        if(paymetvs2==true){
                          setState(() {
                            paymetvs2=false;
                          });

                        }else{
                          setState(() {
                            paymetvs2=true;
                          });

                        }
                      },
                      child:   Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.white70,
                          height: 40,
                          width: MediaQuery.of(context).size.width,

                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Text('Jar Details (Optional)',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
                                SizedBox( width:MediaQuery.of(context).size.width/5),
                                paymetvs ?  Icon(Icons.arrow_drop_down,size: 30,):Icon(Icons.arrow_forward_ios,size: 25,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Visibility(
                        visible: paymetvs2,
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:   TextFormField(
                                controller: cjarprice,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(

                                  border:  OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: Colors.blue)),
                                  labelText: 'Chilled Jar Price',
                                  hoverColor: Colors.black12,
                                  hintText: 'Enter Chilled Jar Price',
                                  prefixIcon: Icon(Icons.monetization_on_sharp),
                                ),),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:   TextFormField(
                                controller: capjarpri,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(

                                  border:  OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: Colors.blue)),
                                  labelText: 'Capsule Jar Price',
                                  hoverColor: Colors.black12,
                                  hintText: 'Enter Capsule Jar Price',
                                  prefixIcon: Icon(Icons.monetization_on_sharp),
                                ),),
                            ),

                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:   TextFormField(
                                controller: waterprice,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(

                                  border:  OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: Colors.blue)),
                                  labelText: 'Water price',
                                  hoverColor: Colors.black12,
                                  hintText: 'water price',
                                  prefixIcon: Icon(Icons.car_rental),
                                ),),
                            ),


                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_outlined),
                                  SizedBox(width: 10,),
                                  Text('Delivery Frequency'),
                                  SizedBox(width: 10,),
                                  Icon(Icons.info_outline),

                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        coloris=1;
                                      });
                                    },
                                    child: Container(

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: coloris ==1? Colors.blue:Colors.black12,
                                      ),
                                      width: MediaQuery.of(context).size.width/4,
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child:   Center(child: Text(' Daily',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600))),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width/14,),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        coloris=2;
                                      });
                                    },
                                    child: Container(

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:  coloris ==2? Colors.blue:Colors.black12,
                                      ),
                                      width: MediaQuery.of(context).size.width/4,
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child:   Center(child: Text('Alternate',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600))),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: MediaQuery.of(context).size.width/14,),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        coloris=3;
                                      });
                                    },
                                    child: Container(

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:  coloris ==3? Colors.blue:Colors.black12,
                                      ),
                                      width: MediaQuery.of(context).size.width/4,
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child:   Text('Week Day',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            InkWell(
                              onTap: (){
                                if(addisnal==true){
                                  setState(() {
                                    addisnal=false;
                                  });

                                }else{
                                  setState(() {
                                    addisnal=true;
                                  });

                                }
                              },
                              child:   Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors.white70,
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,

                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      children: [
                                        Text('Additional Customer Information',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),

                                        paymetvs ?  Icon(Icons.arrow_drop_down,size: 30,):Icon(Icons.arrow_forward_ios,size: 25,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: addisnal,

                                child: Column(
                              children: [
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:   TextFormField(
                                    controller: email,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(

                                      border:  OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(color: Colors.blue)),
                                      labelText: 'Email',
                                      hoverColor: Colors.black12,
                                      hintText: 'Enter Email',
                                      prefixIcon: Icon(Icons.email),
                                    ),),
                                ),

                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:   TextFormField(
                                    controller: address,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(

                                      border:  OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(color: Colors.blue)),
                                      labelText: 'Address',
                                      hoverColor: Colors.black12,
                                      hintText: 'Enter Address',
                                      prefixIcon: Icon(Icons.add_location_alt_rounded),
                                    ),),
                                ),

                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:   TextFormField(
                                    controller: pincode,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(

                                      border:  OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(color: Colors.blue)),
                                      labelText: 'Pin Code',
                                      hoverColor: Colors.black12,
                                      hintText: 'Enter Pin Code',
                                      prefixIcon: Icon(Icons.location_city),
                                    ),),
                                ),

                              ],
                            )
                            )

                          ],

                        )),

                  ],

                ),
              )),

Padding(

  padding: const EdgeInsets.symmetric(horizontal: 20),

  child:   Row(
mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,


        children: [



          Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:Colors.black12,
            ),
            width: MediaQuery.of(context).size.width/3,
            height: 60,

            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child:   Center(child: Text('Cencel',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600))),
            ),
          ),



  SizedBox(width: 10,),



          InkWell(
            onTap: (){
              Saveaddress();
            },
            child: Container(

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:   Colors.blue,
              ),
              width: MediaQuery.of(context).size.width/3,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child:   Center(child: Text('Save',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600))),
              ),
            ),
          ),


        ],



      ),

)
            ],
          ),
        ),
      ),
    );
  }
}
