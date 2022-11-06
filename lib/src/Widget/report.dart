import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../servise.dart';

class myreport extends StatefulWidget {
  const myreport({Key? key}) : super(key: key);

  @override
  _myreportState createState() => _myreportState();
}

class _myreportState extends State<myreport> {
  String dropdownValue = DateFormat.yMMMM().format(DateTime
      .now());
  String? billmonthf =DateFormat.yMMMM().format(DateTime
      .now());

  List<String> allmonth =[];
  int monthourpro=0;
  int   monthourdel=0;
  int   monthourexp=0;
  getmonth(){


    for(int i=0;i<12;i++) {
      DateTime firstDayCurrentMonth = DateTime.utc(DateTime
          .now()
          .year, DateTime
          .now()
          .month - i,);
      var hosre = DateFormat.yMMMM().format(firstDayCurrentMonth);
      allmonth.add(hosre);
    }
   //000 print(allmonth);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getmonth();
    getvender();

    Timer(Duration(seconds: 1), () => getreport());
  }
String? vender;
  getvender()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    setState(() {
      vender =prefs.getString('name');
    });

  }
  Serves serves=Serves();

  List<DataRow> state2=[];
  getreport() async
  {
    print(billmonthf);
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var vid =prefs.getString('vid');

    final uri = Uri.parse(serves.url+"report.php");

    var response = await http.post(uri,body: {
      'report':"",

      'vid':vid,
      'billmonthf':billmonthf.toString(),


    });
    print('pdf create $vid+$billmonthf');
    var state= json.decode(response.body);
    state2=[];
    int ttl1=0;
    setState(() {
      state.forEach((item) {
        int mypro1=0;
        int del1=0;
        int exp1=0;
        var mypro= item['myproduct'];
        var del=  item['delivery'];
        var exp = item['expense'];

        if(mypro!=null){
           mypro1= int.parse(mypro);

        }
        if(del!=null){
       del1 =int.parse(del);
        }
        if(exp!=null){
         exp1 =int.parse(exp);
        }

  var ttl = (mypro1) + (del1) - (exp1);
         ttl1+= (mypro1) + (del1) - (exp1);
 //monthourpro+=mypro1;
 //        monthourdel+=del1;
 //        monthourexp+=exp1;

        state2.add( DataRow(

            cells: [

              DataCell(Text(item['date2'].toString())),
              DataCell(item['myproduct']==null? Text('0'): Text(item['myproduct'].toString())),
              DataCell(item['delivery']==null? Text('0'): Text( item['delivery'].toString())),
              DataCell(item['expense']==null? Text('0'):   Text(item['expense'].toString())),
              DataCell(Text((ttl).toString())),
            ]
        ),
        );
      }
      );


      state2.add( DataRow(

          cells: [

            DataCell(Text('Total',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w900),)),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text(ttl1.toString(),style: TextStyle(color: Colors.green,fontWeight: FontWeight.w900),)),
          ]
      ),
      );



    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Report'),
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
                        Text(vender.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.blueAccent),),
                      ],
                    ),
                  ),
                ),),
            ),
            Center(
              child: Container(
                child: DropdownButton<String>(
                  underline: SizedBox(),
                  value: dropdownValue,
                  icon: const Icon(
                    Icons.arrow_drop_down, size: 30,
                    color: Colors.blue,),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),

                  onChanged: (String? newValue) {
                    // dropdownValue=newValue;
                    print(newValue);
                    setState(() {
                      dropdownValue = newValue.toString();
                      billmonthf = newValue;
                    });
                    Timer(Duration(seconds: 1), () => getreport());
                  },
                  items: allmonth
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),

                ),
              ),
            ),
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:state2==null? Center(child: CircularProgressIndicator()): DataTable(

                  decoration: BoxDecoration(
                    border:Border(

                        right: Divider.createBorderSide(context, width: 5.0),
                        left: Divider.createBorderSide(context, width: 5.0)
                    ),

                  ),
                  columns: [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Our product')),
                    DataColumn(label: Text('Daliy Product')),

                    DataColumn(label: Text('Expense ')),
                    DataColumn(label: Text('Profit')),
                  ],
                  rows: state2,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
