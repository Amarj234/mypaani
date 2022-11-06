import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../servise.dart';

class singleEmployee extends StatefulWidget {
  const singleEmployee({Key? key, required this.eid, required this.name}) : super(key: key);
final eid;
final name;
  @override
  _singleEmployeeState createState() => _singleEmployeeState();
}

class _singleEmployeeState extends State<singleEmployee> {
  String dropdownValue = DateFormat.yMMMM().format(DateTime
      .now());

  int monthourpro=0;
  int   monthourdel=0;
  int   monthourexp=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 1), () => getreport());
    getvender();
    jdate.text=DateFormat('dd-MM-yyyy').format(DateTime
        .now());

  }
  String? vender;
  getvender()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    setState(() {
      vender =prefs.getString('name');
    });

  }
  Serves serves=Serves();
int tpayment=0;
  List<Container> state2=[];
final jdate =TextEditingController();

  getreport() async
  {
    print('pdf create + ${jdate.text}');

    final uri = Uri.parse(serves.url+"empdelivery.php");

    var response = await http.post(uri,body: {
     'showdata':widget.eid,
      'date':jdate.text,


    });

    var state= json.decode(response.body);
    state2=[];
print(state);


    setState(() {

      state.forEach((item) {
        tpayment=int.parse(item['totalp'].toString());
state2.add(Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.blue),
  ),

  child: ListTile(
    onTap: (){

      // Navigator.push(
      //   context,MaterialPageRoute(builder: (context)=> Singlecustomer(name:item['name'],cid:item['cid'])),
      // );


    },
    title : Row(
      children: [
        SizedBox(
          width:90,
          child: Text(item['name'].toString(),style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.black87,fontWeight: FontWeight.w400,fontSize: 22,
              fontFamily:'RobotoMono'
          ),),
        ),

        SizedBox(width: 10,),
        Text('jarOut ',style: TextStyle(color: Colors.greenAccent),),
        SizedBox(width: 5,),
        Image.asset('assets/jar.png',height: 30,),


        SizedBox(width: 5,),
        Text(item['emptycapjar'].toString()),
        Text('||',style: TextStyle(fontSize: 20)),
        Image.asset('assets/cjar.png',height: 40,),


        SizedBox(width: 5,),
        Text(item['emptychilljar'].toString()),
      ],
    ),
    subtitle: Row(
      children: [
        SizedBox(
          width:110,
          child: Text(item['mobile'].toString(),

            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.black87,fontWeight: FontWeight.w200,fontSize: 18
            ),),
        ),
        SizedBox(width: 10,),
        Text('jarIn ',style: TextStyle(color: Colors.greenAccent),),
        SizedBox(width: 5,),
        Image.asset('assets/jar.png',height: 30,),


        SizedBox(width: 5,),
        Text(item['capjar'].toString()),
        Text('||',style: TextStyle(fontSize: 20)),
        Image.asset('assets/cjar.png',height: 40,),


        SizedBox(width: 5,),
        Text(item['chilldjar'].toString()),
      ],
    ),
    leading: CircleAvatar(
      child:  Image.asset('assets/cont.png',height: 200,),
    ),
    trailing:Text(item['totalp'].toString(),style: TextStyle(color: Colors.redAccent),),
  ),

),);



      }
      );
  });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Employee Report'),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     children: [
      //       Column(
      //         children: [
      //           Text('Our Product Month'),
      //     SizedBox(height: 5,),
      //           Text(monthourpro.toString())
      //         ],
      //       )
      //
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: Column(
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
                        Icon(Icons.attach_money,size: 30,color: Colors.blueAccent,),

                        SizedBox(width: 10,),
                        Text(widget.name.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.blueAccent),),
                        SizedBox(width: 10,),
                        Text('- $tpayment'),
                      ],
                    ),
                  ),
                )
              ),
            ),
      SizedBox(height: 10,),
      Center(
        child: Text(
          'Select Month', style: TextStyle(color: Colors.blue),),
      ),
      Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width/2,
          height: 35,
          child: TextField(
            onChanged: (v){
              // allcorce();
              print('fcgvhj');
            },
            controller: jdate, //editing controller of this TextField
            decoration: InputDecoration(

                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
                fillColor: Color(0xfff3f3f4),
                filled: true),
            readOnly: true,  //set it true, so that user will not able to edit text
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context, initialDate: DateTime.now(),
                  firstDate: DateTime(1950), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101)
              );

              if(pickedDate != null ){
              //  print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                //print(formattedDate); //formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement

                setState(() {
                  jdate.text = formattedDate; //set output date to TextField value.
                });
               getreport();

              }else{
                print("Date is not selected");
              }
            },
          ),
        ),
      ),
SizedBox(height: 10,),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: state2,
              ),
            ),




          ],
        ),
      ),
    );
  }
}
