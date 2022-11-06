
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../servise.dart';
class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  DateTime? notifydate ;
final dateinput =TextEditingController();
bool isdetail=false;
bool? isChecked=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setname();
    showreport();
  }
  String? name;
  String? vid;

  Serves serves=Serves();
  String? cid;



  setname()async {
    final uri = Uri.parse(serves.url+"singlecust1.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
    cid =prefs.getString('cid');
    print('amar $cid');
    var response = await http.post(uri,body: {
      'cid':cid,

    });
    var state= json.decode(response.body);
    setState((){
      name=state[0]['name'];
    });


  }


  List<DataRow> state2=[];

  showreport() async {
    final uri = Uri.parse(serves.url+"paymentreport.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
    cid =prefs.getString('cid');
    vid =prefs.getString('vid');
    print('amar $cid+$vid');
    var response = await http.post(uri,body: {
      'cid':cid,
      'vid':vid,
      'billmonthf':dateinput.text,
    });
    var state= json.decode(response.body);
    print(state);
    setState((){
      state.forEach((item) {
        var totalp=int.parse(item['chilldjarprice'])+int.parse(item['capprice'])+int.parse(item['whaterprice']);

        state2.add( DataRow(




            cells: [

              DataCell(


                  Text(item['date1'])),
              DataCell(item['chilldjar']==null ? Text('') :  Text("chilld jar - ${item['chilldjar']}")),
              DataCell( item['chilldjarprice']==null ? Text('') :  Text("chilld jar price - ${item['chilldjarprice']}")),
              DataCell(item['capjar']==null ? Text('') :  Text("Capsul jar - ${item['capjar']}")),
              DataCell(item['capjar']==null ? Text('') :  Text("Capsul jar price - ${item['capprice']}")),
              DataCell(item['whater']==null ? Text('') :  Text("Only Water - ${item['whater']}")),
              DataCell(item['whaterprice']==null ? Text('') :  Text("Water Price - ${item['whaterprice']}")),
              DataCell(totalp==null ? Text('') :  Text("Daly Total - $totalp")),
              DataCell(item['paymentdone']==null ? Text('') :  Text("Paid Amount - ${item['paymentdone']}")),


            ]
        ),
        );
      }
      );
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:name==null?Center(child: CircularProgressIndicator()): SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                children: [




                  Container(
                    color: Color(0xff74eedc),
                    // height: MediaQuery
                    //     .of(context)
                    //     .size
                    //     .height ,
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
                              child: Text(name.toString(), style: TextStyle(
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
                                    Text('Past Payment',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.blueAccent),),
                                  ],
                                ),
                              ),
                            ),),
                        ),

                      ],
                    ),

                  ),
SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),

                        ),
                        padding: EdgeInsets.all(5),
                        height:55,
                        child:Center(
                            child:TextField(
                              controller: dateinput, //editing controller of this TextField
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.calendar_today), //icon of text field

                              ),
                              readOnly: true,  //set it true, so that user will not able to edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context, initialDate: DateTime.now(),
                                    firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101)
                                );

                                if(pickedDate != null ){
                                  print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                  //you can implement different kind of Date Format here according to your requirement

                                  setState(() {
                                    dateinput.text = formattedDate; //set output date to TextField value.
                                  });
                                }else{
                                  print("Date is not selected");
                                }
                              },
                              onChanged: (v){
                                Timer.periodic(Duration(seconds: 1), (timer) { showreport(); print('date'); });

                              },
                            )
                        )
                    ),
                  ),
                  SizedBox(height: 10,),




                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18),
                    child: Card(
                      shadowColor: Colors.black,
                      child: TextFormField(

                        decoration: InputDecoration(
                          hintText: 'Enter Payment ',
                          border: InputBorder.none,


                        ),
                        style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),

                      ),
                    ),
                  ),
SizedBox(height: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width/1.05,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlueAccent),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){
                            if(isdetail==true){
                              setState(() {
                                isdetail=false;
                              });
                            }else{
                              setState(() {
                                isdetail=true;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Text('Details (Optional)',style: TextStyle(color: Colors.lightBlueAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),),
                                Expanded(child:isdetail?  Icon(Icons.arrow_drop_down,color: Colors.blueAccent,):  Icon(Icons.arrow_forward_ios,color: Colors.blueAccent,))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Visibility(
                          visible: isdetail,
                          child: Column(
                            children: [
                              Container(
                                child:  TextFormField(

                                  decoration: InputDecoration(
                                    hintText: 'Enter Comment ',
                                    border: InputBorder.none,


                                  ),
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),

                                ),
                                width: MediaQuery.of(context).size.width/1.1,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.lightBlueAccent),
                                  borderRadius: BorderRadius.circular(10),

                                )

                              ),

                              SizedBox(height: 20,),

                              Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                      value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                  ),
                                  Text('Diposit Payment',style: TextStyle(color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),)
                                ],
                              ),
                            ],
                          ),

                        ),


                        SizedBox(height: 20,),
          InkWell(
          onTap: (){

    },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                  colors: [Color(0xff2b67e0), Color(0xff322bf7)])),
          child: Text(
            'Submit',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    ),
                      ],
                    ),
                  ),
SizedBox(height: 20,),
Container(
    width: MediaQuery.of(context).size.width/1.05,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.lightBlueAccent),
      borderRadius: BorderRadius.circular(10),

    ),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Text('Payment And Bill Ladger',style: TextStyle(color: Colors.lightBlueAccent,
            fontSize: 20,
            fontWeight: FontWeight.w600),),
        Expanded(child:isdetail?  Icon(Icons.arrow_drop_down_circle_outlined,color: Colors.blueAccent,):  Icon(Icons.arrow_forward_ios,color: Colors.blueAccent,))
      ],
    ),
  ),
),

                  SizedBox(height: 10,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(

                      decoration: BoxDecoration(
                        border:Border(

                            right: Divider.createBorderSide(context, width: 0.0),
                            left: Divider.createBorderSide(context, width: 0.0)
                        ),

                      ),
                      columns: [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Chilld Jar')),
                        DataColumn(label: Text('Chilld Jar Price')),
                        DataColumn(label: Text('Capsule Jar')),
                        DataColumn(label: Text('Capsule Jar price')),
                        DataColumn(label: Text('Water')),
                        DataColumn(label: Text('Water price')),
                        DataColumn(label: Text('Daily Total')),
                        DataColumn(label: Text('Pad Amount')),
                      ],
                      rows: state2
                    ),
                  ),

                ]
            ),
          )
      )
    );
  }
}
