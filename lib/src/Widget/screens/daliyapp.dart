import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../servise.dart';
import '../dashboard.dart';

class dailyapp extends StatefulWidget {
  const dailyapp({Key? key, }) : super(key: key);


  @override
  State<dailyapp> createState() => _dailyappState();
}

class _dailyappState extends State<dailyapp> {

  Serves serves=Serves();

  Saveaddress() async{
print(jdate.text);
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var vid= prefs.getString('vid');
    var cid= prefs.getString('cid');
var eid= prefs.getString('eid');
    var url4 = Uri.parse(serves.url+"delivery.php");
    var response = await http.post(url4, body: {
                'fullchilldjarin':   controller1.text,
                'empychilldjarout':   controller2.text,
                'fullcapjarin':   controller3.text,
                'empycapjarout':   controller4.text,
                'water':   controller5.text,
                 'paymentdone':paymentdone.text,
      'mobile':cmobile,
      'cid':cid,
      'vid':vid,
      'eid':eid,
      'date':jdate.text,

    });
    print(response.body);
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

  Future allcorce() async {

    final uri = Uri.parse(serves.url+"fechdelivery.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var cid =prefs.getString('cid');

    var response = await http.post(uri,body: {
      'showdata':cid,
      'search':jdate.text,

    });
    print('fechdata'+cid!);
    var state= json.decode(response.body);

    if(state.length!=0){

      controller1.text = state[0]['chilldjar'];
      controller2.text = state[0]['emptychilljar'];
      controller3.text = state[0]['capjar'];
      controller4.text = state[0]['emptycapjar'];
      controller5.text = state[0]['water'];
      paymentdone.text=state[0]['paymentdone'];

    }else{
      controller1.text = "0";
      controller2.text = "0";
      controller3.text = "0";
      controller4.text = "0";
      controller5.text = "0";
      paymentdone.text="0";
    }


  }






  List<String> allmonth =[];

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
print(allmonth);
}






  String? value;
  bool paymetvs = false;
  bool disableddropdown = true;
  bool disabledseen = true;

  String dropdownValue = DateFormat.yMMMM().format(DateTime
      .now());
  final jdate = TextEditingController();
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();
  final controller4 = TextEditingController();
  final controller5 = TextEditingController();
  final paymentdone = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller1.text = "0";
    controller2.text = "0";
    controller3.text = "0";
    controller4.text = "0";
    controller5.text = "0";
    setname();
    getmonth();
    jdate.text=DateFormat('dd-MM-yyyy').format(DateTime
        .now());

    allcorce();

  }


  String? billmonthf;
int? check;
String? cid;
  String? cname;
  String? cmobile;
  String? caddress;

  String? gstno;
  String? upino;



  setname() async {
  final uri = Uri.parse(serves.url+"singlecust.php");
  SharedPreferences prefs =await SharedPreferences.getInstance();
  cid =prefs.getString('cid');

  var response = await http.post(uri,body: {
  'cid':cid,
  });
  var state= json.decode(response.body);
  setState((){
    cname=state[0]['cname'];
    cmobile=state[0]['mobile'];
    caddress=state[0]['address'];
    gstno=state[0]['gstno'];
    upino=state[0]['upino'];

  });
  }
  int? total=0;
  void totalfun(){
    setState((){
      total= int.parse( controller1.text)+int.parse( controller3.text)+int.parse( controller5.text);

    });
  }


  DateTime currentDate = DateTime.now();

  // DateTime?
  // eventDate =
  // new DateFormat("yyyy-MM-dd hh:mm:ss").parse(currentDate);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: cname==null? CircularProgressIndicator(): SafeArea(

      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              color: Color(0xff74eedc),
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 2.8,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Row(

                            children: [
                              SizedBox(width: 50,),
                              Center(child: Icon(Icons.home_filled, size: 30,
                                color: Colors.blue,)),
                              SizedBox(width: 20,),
                              Expanded(
                                child: Text('Balance jar', style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 23,
                                    fontFamily: 'RobotoMono'
                                ),),
                              ),
                              SizedBox(width: 20,),
                              Icon(Icons.edit, size: 30, color: Colors.blue,)
                            ],
                          ),


                          Row(
                            children: [
                              SizedBox(width: 20,),
                              Text('${controller1.text} ×', style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25,
                                  fontFamily: 'RobotoMono'
                              ),),
                              Image.asset('assets/cjar.png', height: 60,),
                              Text('+ ${controller5.text} × ', style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25,
                                  fontFamily: 'RobotoMono'
                              ),),
                              Image.asset('assets/water.png', height: 40,),
                              Text('+ ${controller3.text} × ', style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25,
                                  fontFamily: 'RobotoMono'
                              ),),
                              Image.asset('assets/jar.png', height: 40,),
                              SizedBox(width: 20,),
                              Text('=  $total ', style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25,
                                  fontFamily: 'RobotoMono'
                              ),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(

                            children: [
                              SizedBox(height: 50,
                                width: 40,),
                              Icon(Icons.copy_outlined, size: 25,
                                color: Colors.lightBlueAccent,),
                              SizedBox(width: 0,),
                              Text('Daily Sheet', style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25,
                                  fontFamily: 'RobotoMono'
                              ),),
                              SizedBox(width: 30,),
                              IconButton(
                                onPressed: (){

                                //  getmonth();




                                  _showMyDialog();

                                  },
                                icon: Icon(Icons.backup_sharp, size: 25,
                                  color: Colors.lightBlueAccent,),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),

            ),
            Column(
              children: [
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
                          print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                          print(formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            jdate.text = formattedDate; //set output date to TextField value.
                          });
                          Timer(Duration(seconds: 1), () => allcorce());

                        }else{
                          print("Date is not selected");
                        }
                      },
                    ),
                  ),

                ),
                Card(
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,

                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xffc6dae7),
                            Colors.white,
                          ],
                        )
                    ),
                    child: SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (disabledseen == true) {
                                setState(() {
                                  disabledseen = false;
                                });
                              } else {
                                setState(() {
                                  disabledseen = true;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.2, 6, 0, 6),
                                  child: Icon(
                                    Icons.calendar_today_outlined, size: 25,
                                    color: Colors.blue,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(jdate.text, style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      fontFamily: 'RobotoMono'
                                  ),),
                                ),
                                SizedBox(width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 6),
                                Text('In -${controller1.text}', style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    fontFamily: 'RobotoMono'
                                ),),
                                SizedBox(width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 10),
                                Container(
                                  height: 20,

                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue)
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Text('Out -0', style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    fontFamily: 'RobotoMono'
                                ),),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: disabledseen,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                Container(

                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue)
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      .0, 0, 250, 0),
                                  child: Text('Chilled jar', style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      fontFamily: 'RobotoMono'
                                  ),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/cjar.png', height: 50,),
                                      Icon(Icons.arrow_forward, size: 25,),
                                      Text(
                                        'Full jar (Jar In) ', style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                          fontFamily: 'RobotoMono'
                                      ),),
                                      SizedBox(width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 8.5),
                                      InkWell(
                                        onTap: () {
                                          setState((){
                                            if (controller1.text != "0") {
                                              int amae = int.parse(
                                                  controller1.text);
                                              controller1.text =
                                                  (amae - 1).toString();
                                            }
                                          });
                                          totalfun();
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff5abbad),
                                              borderRadius: BorderRadius.only(

                                                  topLeft: Radius.circular(
                                                      10.0),
                                                  bottomLeft: Radius.circular(
                                                      10.0)),

                                            ),
                                            height: 40,
                                            width: 30,

                                            child: Icon(
                                              Icons.remove, color: Colors.white,
                                              size: 22,)),
                                      ),
                                      SizedBox(
                                        width: 70,
                                        height: 40,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xff5abbad))
                                          ),
                                          child: TextFormField(
                                            controller: controller1,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,),
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              hintText: '0',

                                            ),

                                          ),
                                        )
                                        ,),

                                      InkWell(
                                        onTap: () {
                                          setState((){
                                            controller1.text =
                                                (int.parse(controller1.text) + 1)
                                                    .toString();
                                          });
                                          totalfun();

                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff5abbad),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                bottomRight: Radius.circular(
                                                    10.0),
                                              ),
                                            ),
                                            height: 40,
                                            width: 30,

                                            child: Icon(
                                              Icons.add, color: Colors.white,
                                              size: 22,)),
                                      ),
                                    ],
                                  ),
                                ),


                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/cjar.png', height: 50,),
                                      Icon(Icons.arrow_forward, size: 25,),
                                      Text(
                                        'Empty jar(Jar Out)', style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          fontFamily: 'RobotoMono'
                                      ),),
                                      SizedBox(width: 2,),
                                      InkWell(
                                        onTap: () {
                                          setState((){
                                            if (controller2.text != "0") {
                                              int amae1 = int.parse(
                                                  controller2.text);
                                              controller2.text =
                                                  (amae1 - 1).toString();
                                            }
                                          });

                                          totalfun();
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff5abbad),
                                              borderRadius: BorderRadius.only(

                                                  topLeft: Radius.circular(
                                                      10.0),
                                                  bottomLeft: Radius.circular(
                                                      10.0)),

                                            ),
                                            height: 40,
                                            width: 30,

                                            child: Icon(
                                              Icons.remove, color: Colors.white,
                                              size: 22,)),
                                      ),
                                      SizedBox(
                                        width: 70,
                                        height: 40,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xff5abbad))
                                          ),
                                          child: TextFormField(
                                            // controller: controller2,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,),
                                            controller: controller2,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              hintText: '0',

                                            ),

                                          ),
                                        )
                                        ,),

                                      InkWell(
                                        onTap: () {
                                          setState((){
                                            controller2.text =
                                                (int.parse(controller2.text) + 1)
                                                    .toString();
                                          });
                                          totalfun();
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff5abbad),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                bottomRight: Radius.circular(
                                                    10.0),
                                              ),
                                            ),
                                            height: 40,
                                            width: 30,

                                            child: Icon(
                                              Icons.add, color: Colors.white,
                                              size: 22,)),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      .0, 0, 250, 0),
                                  child: Text('Capsule jar', style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      fontFamily: 'RobotoMono'
                                  ),),
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/jar.png', height: 40,),
                                      Icon(Icons.arrow_forward, size: 25,),
                                      Text('Full jar (Jar In)   ',
                                        style: TextStyle(
                                            color: Colors.black38,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                            fontFamily: 'RobotoMono'
                                        ),),
                                      SizedBox(width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 15),
                                      InkWell(
                                        onTap: () {
                                          setState((){
                                            if (controller3.text != "0") {
                                              controller3.text =
                                                  (int.parse(controller3.text) -
                                                      1).toString();
                                            }
                                          });

                                          totalfun();
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff5abbad),
                                              borderRadius: BorderRadius.only(

                                                  topLeft: Radius.circular(
                                                      10.0),
                                                  bottomLeft: Radius.circular(
                                                      10.0)),

                                            ),
                                            height: 40,
                                            width: 30,

                                            child: Icon(
                                              Icons.remove, color: Colors.white,
                                              size: 22,)),
                                      ),
                                      SizedBox(
                                        width: 70,
                                        height: 40,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xff5abbad))
                                          ),
                                          child: TextField(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,),
                                            textAlign: TextAlign.center,
                                            controller: controller3,
                                            decoration: InputDecoration(
                                              hintText: '0',

                                            ),
                                          ),
                                        )
                                        ,),

                                      InkWell(
                                        onTap: () {
                                          setState((){
                                            controller3.text =
                                                (int.parse(controller3.text) + 1)
                                                    .toString();
                                          });

                                          totalfun();
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff5abbad),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                bottomRight: Radius.circular(
                                                    10.0),
                                              ),
                                            ),
                                            height: 40,
                                            width: 30,

                                            child: Icon(
                                              Icons.add, color: Colors.white,
                                              size: 22,)),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 10,),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/jar.png', height: 40,),
                                      Icon(Icons.arrow_forward, size: 25,),
                                      Text(
                                        'Empty jar(Jar Out)', style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          fontFamily: 'RobotoMono'
                                      ),),
                                      SizedBox(width: 7,),
                                      InkWell(
                                        onTap: () {
                                          setState((){
                                            if (controller4.text != "0") {
                                              controller4.text =
                                                  (int.parse(controller4.text) -
                                                      1)
                                                      .toString();
                                            }
                                        });

                                          totalfun();

                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff5abbad),
                                              borderRadius: BorderRadius.only(

                                                  topLeft: Radius.circular(
                                                      10.0),
                                                  bottomLeft: Radius.circular(
                                                      10.0)),

                                            ),
                                            height: 40,
                                            width: 30,

                                            child: Icon(
                                              Icons.remove, color: Colors.white,
                                              size: 22,)),
                                      ),
                                      SizedBox(
                                        width: 70,
                                        height: 40,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xff5abbad))
                                          ),
                                          child: TextField(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,),
                                            textAlign: TextAlign.center,
                                            controller: controller4,
                                            decoration: InputDecoration(
                                              hintText: '0',

                                            ),
                                          ),
                                        )
                                        ,),

                                      InkWell(
                                        onTap: () {
                                          setState((){
                                            controller4.text =
                                                (int.parse(controller4.text) + 1)
                                                    .toString();
                                          });
                                          totalfun();
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff5abbad),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                bottomRight: Radius.circular(
                                                    10.0),
                                              ),
                                            ),
                                            height: 40,
                                            width: 30,

                                            child: Icon(
                                              Icons.add, color: Colors.white,
                                              size: 22,)),
                                      ),
                                    ],
                                  ),
                                ), Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      .0, 0, 250, 0),
                                  child: Text('Water Only', style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      fontFamily: 'RobotoMono'
                                  ),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/water.png', height: 40,),
                                      Icon(Icons.arrow_forward, size: 25,),
                                      Text(
                                        'Water (20 li) ', style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                          fontFamily: 'RobotoMono'
                                      ),),
                                      SizedBox(width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 9),
                                      InkWell(
                                        onTap: () {
                                          setState((){
                                            if (controller5.text != "0") {
                                              int amae = int.parse(
                                                  controller5.text);
                                              controller5.text =
                                                  (amae - 1).toString();
                                            }
                                          });
                                          totalfun();
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff5abbad),
                                              borderRadius: BorderRadius.only(

                                                  topLeft: Radius.circular(
                                                      10.0),
                                                  bottomLeft: Radius.circular(
                                                      10.0)),

                                            ),
                                            height: 40,
                                            width: 30,

                                            child: Icon(
                                              Icons.remove, color: Colors.white,
                                              size: 22,)),
                                      ),
                                      SizedBox(
                                        width: 70,
                                        height: 40,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xff5abbad))
                                          ),
                                          child: TextFormField(
                                            controller: controller5,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,),
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              hintText: '0',

                                            ),

                                          ),
                                        )
                                        ,),

                                      InkWell(
                                        onTap: () {
                                          setState((){
                                            controller5.text =
                                                (int.parse(controller5.text) + 1)
                                                    .toString();
                                          });

                                          totalfun();
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff5abbad),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                bottomRight: Radius.circular(
                                                    10.0),
                                              ),
                                            ),
                                            height: 40,
                                            width: 30,

                                            child: Icon(
                                              Icons.add, color: Colors.white,
                                              size: 22,)),
                                      ),
                                    ],
                                  ),
                                ),





                                SizedBox(height: 10,),
                                InkWell(
                                  onTap: () {
                                    if (paymetvs == true) {
                                      setState(() {
                                        paymetvs = false;
                                      });
                                    } else {
                                      setState(() {
                                        paymetvs = true;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 1.2,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xff5abbad))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          Text('Enter Payment Also',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),),
                                          SizedBox(width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 5),
                                          paymetvs
                                              ? Icon(
                                            Icons.arrow_drop_down, size: 30,)
                                              : Icon(
                                            Icons.arrow_forward_ios, size: 25,)

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Visibility(
                                  visible: paymetvs,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Card(
                                      child: TextFormField(
                                        controller: paymentdone,
                                        decoration: InputDecoration(
                                          hintText: 'Enter Payment ',


                                        ),
                                        style: TextStyle(color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),

                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),

                                InkWell(
                                  onTap: (){
                                    Saveaddress();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
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
                                              colors: [
                                                Color(0xff74eedc),
                                                Color(0xfff7892b)
                                              ])),
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 100,)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),





          ],
        ),
      ),
    ));

  }







  Future<void> main() async {
    final pdf = pw.Document();
    SharedPreferences prefs =await SharedPreferences.getInstance();



    var assetImage = pw.MemoryImage(
      (await rootBundle.load('assets/logofi1.png'))
          .buffer
          .asUint8List(),
    );


    var vname=prefs.getString('name');
    var mobile=prefs.getString('mobile');
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(

            ),
            borderRadius: pw.BorderRadius.circular(10),

          ),

          height: 150,
          child: pw.Padding(
            padding: pw.EdgeInsets.all(10),
            child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                      children: [
                        pw.Text(vname.toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 5),
                        pw.Text(mobile.toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 5),
                        pw.Text('Name-  $cname',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 5),
                        pw.Text('Mobile-  $cmobile',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 5),
                        pw.Text('Address-  $caddress',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

                      ]
                  ),
                  pw.SizedBox(width: 50),
                  pw.SizedBox(width: 100,
                    child: pw.Image(assetImage),

                  ),
                  pw.Expanded(
                      child: pw.BarcodeWidget(
                        width: 100,
                        height: 100,
                        color: PdfColor.fromHex("#000000"),
                        data: cid.toString(),
                        barcode: pw.Barcode.qrCode(),
                      )
                  ),



                ]
            ),
          )
        )
      ),
    );

    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/amar.pdf');
    await file.writeAsBytes(bytes);


      final url = file.path;

      await OpenFile.open(url);

    await file.writeAsBytes(await pdf.save());
  }


  List<pw.TableRow> pdfdata2=[];
  List<pw.TableRow> pdfdata=[];

  Future<void> billmonth() async {
    final pdf = pw.Document();
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var vid =prefs.getString('vid');

    final uri = Uri.parse(serves.url+"billing.php");

    var response = await http.post(uri,body: {
      'report':"",
      'cid':cid,
      'vid':vid.toString(),
      'billmonthf':billmonthf.toString(),
      'check':check.toString(),

    });
    print('pdf create $cid+$vid');
    var state= json.decode(response.body);

    //print(state);
    pdfdata2=[];
    pdfdata=[];
    pdfdata.add(

      pw.TableRow( children: [

        // color: PdfColor.fromHex('0xFFf1b0ea'),

        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Date'),], ),
        ),


        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('child in'),], ),
        ),
        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('child out'),], ),
        ),

        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Cap in'),], ),
        ),


        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Cap out'),], ),
        ),
        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Water'),], ),
        ),
        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Bal'),], ),
        ),

        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Paid A.'),], ),
        ),
        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Bal. due'),], ),
        ),



      ]),



    );


    // pdfdata2.add(
    //
    //   pw.TableRow( children: [
    //
    //     // color: PdfColor.fromHex('0xFFf1b0ea'),
    //
    //     pw.Container(
    //       color: PdfColor.fromHex('#6cffff'),
    //       child: pw.Column(children:[pw.Text('Date'),], ),
    //     ),
    //
    //
    //     pw.Container(
    //       color: PdfColor.fromHex('#6cffff'),
    //       child: pw.Column(children:[pw.Text('iin'),], ),
    //     ),
    //
    //     pw.Container(
    //       color: PdfColor.fromHex('#6cffff'),
    //       child: pw.Column(children:[pw.Text('oout'),], ),
    //     ),
    //
    //     pw.Container(
    //       color: PdfColor.fromHex('#6cffff'),
    //       child: pw.Column(children:[pw.Text('Bal'),], ),
    //     ),
    //
    //     pw.Container(
    //       color: PdfColor.fromHex('#6cffff'),
    //       child: pw.Column(children:[pw.Text('Paid A.'),], ),
    //     ),
    //
    //
    //
    //
    //   ]),
    //
    //
    //
    // );



    int  totalpaid=0;
    int  totalamount=0;
    int  totaljarin=0;
    int  tchjarin=0;
    int  tcapjarin=0;
    int  echjar=0;
    int  ecapjar=0;
    int  water=0;

    //print(state);
    for (int i = 0; i < state.length; i++) {

   //   print( DateFormat.d().format(DateFormat("dd").parse(state[i]['Date2'])));

//      var a2= state[i]['totalp'];

//totalpaid=state[i]['paymentdone']+totalpaid;
//       print("state[i]");
// print(state);
      if( state[i]['paymentdone'] !='' && state[i]['paymentdone']!=null) {
        totalpaid=int.parse(state[i]['paymentdone'])+totalpaid;
      }
      if(state[i]['capjar'] !='' && state[i]['capjar']!=null) {
        tcapjarin=int.parse(state[i]['capjar'])+tcapjarin;
      }
     if( state[i]['chilldjar'] !='' && state[i]['chilldjar']!=null) {
       tchjarin=int.parse(state[i]['chilldjar'])+tchjarin;
     }
     if(state[i]['capjar'] !='' && state[i]['capjar']!=null) {
       tcapjarin=int.parse(state[i]['capjar'])+tcapjarin;
     }
     if(state[i]['water']!='' && state[i]['water']!=null ) {
       water=int.parse(state[i]['water'])+water;

     }

     if( state[i]['emptychilljar'] !='' && state[i]['emptychilljar']!=null) {
       echjar=int.parse(state[i]['emptychilljar'])+echjar;
     }
     if(state[i]['emptycapjar'] !='' && state[i]['emptycapjar']!=null) {
       ecapjar=int.parse(state[i]['emptycapjar'])+ecapjar;
     }
     if(state[i]['totalp']!='' && state[i]['totalp']!=null ) {
       totalamount=int.parse(state[i]['totalp'])+totalamount;

     }


      setState((){



       // if(i<15) {
          pdfdata.add(

            pw.TableRow(children: [

              // color: PdfColor.fromHex('0xFFf1b0ea'),

              pw.Container(
                // color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children: [state[i]['Date2']== null? pw.Text(''):
                  pw.Text(DateFormat.d().format(DateFormat("dd").parse(state[i]['Date2'].toString())).toString(),),
                ],),
              ),


              pw.Container(
                // color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(
                  children: [ state[i]['chilldjar']==null ?pw.Text('') : pw.Text(state[i]['chilldjar'].toString()),],),
              ),

              pw.Container(
                //  color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(
                  children: [state[i]['emptychilljar']==null ?pw.Text('') : pw.Text(state[i]['emptychilljar'].toString()),],),
              ),

              pw.Container(
                //color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children: [state[i]['capjar']==null ?pw.Text('') :
                  pw.Text(state[i]['capjar'].toString()),
                ],),
              ),

              pw.Container(
                // color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children: [state[i]['emptycapjar']==null ?pw.Text('') : pw.Text(state[i]['emptycapjar'].toString()),],),
              ),
              pw.Container(
                //color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children: [state[i]['water']==null ?pw.Text('') :
                pw.Text(state[i]['water'].toString()),
                ],),
              ),


              pw.Container(
                //color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children: [state[i]['totalp']==null ?pw.Text('') :
                pw.Text(state[i]['totalp'].toString()),
                ],),
              ),

              pw.Container(
                // color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children: [state[i]['paymentdone']==null ?pw.Text('') : pw.Text(state[i]['paymentdone'].toString()),],),
              ),
              pw.Container(
                // color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children: [state[i]['daliydue']==null ?pw.Text('') : pw.Text(state[i]['daliydue'].toString()),],),
              ),

            ]),


          );
        // }else{
        //
        //   pdfdata2.add(
        //
        //     pw.TableRow( children: [
        //
        //       // color: PdfColor.fromHex('0xFFf1b0ea'),
        //
        //       pw.Container(
        //         // color: PdfColor.fromHex('#6cffff'),
        //         child: pw.Column(children: [
        //           pw.Text(DateFormat.d().format(DateFormat("dd").parse(state[i]['Date2'])).toString(),),
        //         ],),
        //       ),
        //
        //
        //       pw.Container(
        //         // color: PdfColor.fromHex('#6cffff'),
        //         child: pw.Column(
        //           children: [ state[i]['iin']==null ?pw.Text('') : pw.Text(state[i]['iin'].toString()),],),
        //       ),
        //
        //       pw.Container(
        //         //  color: PdfColor.fromHex('#6cffff'),
        //         child: pw.Column(
        //           children: [state[i]['oout']==null ?pw.Text('') : pw.Text(state[i]['oout'].toString()),],),
        //       ),
        //
        //       pw.Container(
        //         //color: PdfColor.fromHex('#6cffff'),
        //         child: pw.Column(children: [state[i]['totalp']==null ?pw.Text('') :
        //         pw.Text(state[i]['totalp'].toString()),
        //         ],),
        //       ),
        //
        //       pw.Container(
        //         // color: PdfColor.fromHex('#6cffff'),
        //         child: pw.Column(children: [state[i]['paymentdone']==null ?pw.Text('') : pw.Text(state[i]['paymentdone'].toString()),],),
        //       ),
        //
        //
        //
        //
        //     ]),
        //
        //
        //
        //   );
        //
        //
        //
        // }



      });


    }




    var response1 = await http.post(uri,body: {
      'oldreport':"",
      'cid':cid,
      'vid':vid.toString(),
      'billmonthf':billmonthf.toString(),
      'check':check.toString(),

    });

    var state1= json.decode(response1.body);

    int oidchil =int.parse(state1[0]['sumchild']);
    int oidcap =int.parse(state1[0]['sumcap']);
    int sumtotal =int.parse(state1[0]['sumtotal']);
    var coldjarprice =state1[0]['coldjarprice'];
    var capsulejarprice =state1[0]['capsulejarprice'];
    var whaterprice =state1[0]['whaterprice'];

    pdfdata.add(

      pw.TableRow(children: [

        // color: PdfColor.fromHex('0xFFf1b0ea'),

        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children: [
            pw.Text('Total'),
          ],),
        ),




        pw.Container(
          //  color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(
            children: [tchjarin==null ?pw.Text('') : pw.Text(tchjarin.toString()),],),
        ),

        pw.Container(
          //color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children: [echjar==null ?pw.Text('') :
          pw.Text(echjar.toString()),
          ],),
        ),

        pw.Container(
          // color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children: [tcapjarin==null ?pw.Text('') : pw.Text(tcapjarin.toString()),],),
        ),

    pw.Container(
    // color: PdfColor.fromHex('#6cffff'),
    child: pw.Column(
    children: [ ecapjar==null ?pw.Text('') : pw.Text(ecapjar.toString()),],),
    ),

        pw.Container(
          //color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children: [water==null ?pw.Text('') :
          pw.Text(water.toString()),
          ],),
        ),


        pw.Container(
          //color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children: [totalamount==null ?pw.Text('') :
          pw.Text(totalamount.toString()),
          ],),
        ),

        pw.Container(
          // color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children: [totalpaid==null ?pw.Text('') : pw.Text(totalpaid.toString()),],),
        ),


      ]),


    );








    var assetImage = pw.MemoryImage(
      (await rootBundle.load('assets/logofi1.png'))
          .buffer
          .asUint8List(),
    );


    var vname=prefs.getString('name');
    var mobile=prefs.getString('mobile');
    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
          build: (pw.Context context) => [ pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(

                ),
                borderRadius: pw.BorderRadius.circular(10),

              ),

              height: 130,
              child:
                  pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Gst NO - $gstno",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 2),
                                pw.Text(vname.toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 2),
                                pw.Text(mobile.toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
    pw.SizedBox(height: 2),
    pw.Text("Cooljarprice- $coldjarprice "),
                                pw.SizedBox(height: 2),
                                pw.Text("capsulejarprice- $capsulejarprice"),
                                pw.SizedBox(height: 2),
                                pw.Text("whaterprice- $whaterprice"),
                              ]
                          ),
                          pw.SizedBox(width: 50),
                          pw.SizedBox(width: 100,
                            child: pw.Image(assetImage),

                          ),
                          pw.Expanded(
                              child: pw.BarcodeWidget(
                                width: 100,
                                height: 100,
                                color: PdfColor.fromHex("#000000"),
                                data: "upi://pay?pa=$upino&pn=$vname&tr=&am=${((totalamount-totalpaid)+sumtotal)}.0&cu=INR&mode=01&purpose=10&orgid=-&sign=-&tn=Mypaani",
                                barcode: pw.Barcode.qrCode(),
                              )
                          ),



                        ]
                    ),
                  ),



          ),
pw.SizedBox(height: 20),
               pw.Container(
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(15.0),
                      child: pw.Column(children: [
pw.Row(
  mainAxisAlignment: pw.MainAxisAlignment.start,
  crossAxisAlignment: pw.CrossAxisAlignment.start,
  children: [
    pw.Text('Name- ',style: pw.TextStyle(fontSize: 18,)),
    pw.Text(cname.toString(),style: pw.TextStyle(fontSize: 16,)),
    pw.SizedBox(width: 100),
    pw.Text('Mobile- ',style: pw.TextStyle(fontSize: 18,)),
    pw.Text(cmobile.toString(),style: pw.TextStyle(fontSize: 16,)),
  ]
),
                        pw.Row(
                            children: [
                              pw.Text('Month- ',style: pw.TextStyle(fontSize: 18,)),
                              pw.Text(billmonthf.toString(),style: pw.TextStyle(fontSize: 16,)),

                            ]
                        ),
                        pw.Row(
                            children: [
                              pw.Text('Address- ',style: pw.TextStyle(fontSize: 18,)),
                              caddress ==null ?pw.Text('')   : pw.Text(caddress.toString(),style: pw.TextStyle(fontSize: 16,)),

                            ]
                        ),

                      ]),
                    ),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                      borderRadius: pw.BorderRadius.circular(10),

                    ),
                  ),



pw.SizedBox(height: 20,),
                pw.SizedBox(

                  child:       pw.Container(
                    // color:  PdfColor.fromHex('#00cfcf'),
                    child:       pw.Table(
                      defaultColumnWidth: pw.FixedColumnWidth(60.0),
                      border: pw.TableBorder.all(
                          color: PdfColor.fromHex('#f6d056'),
                          style: pw.BorderStyle.solid,
                          width: 1),


                      children: pdfdata,








                    ),
                  ),
                ),


                pw.SizedBox(
                    height: 20
                ),

                pw.Container(
                  //color:  PdfColor.fromHex('#00cfcf'),
                  child:   pw.Table(
                    defaultColumnWidth: pw.FixedColumnWidth(45.0),
                    border: pw.TableBorder.all(
                        color: PdfColor.fromHex('#f6d056'),
                        style: pw.BorderStyle.solid,
                        width: 1),


                    children: [

                      pw.TableRow( children: [

                      // color: PdfColor.fromHex('0xFFf1b0ea'),

                        pw.Container(
                          color: PdfColor.fromHex('#6cffff'),
                          child: pw.Column(children:[pw.Text('Past Month Chil.'),], ),
                        ),



                        pw.Container(
                          color: PdfColor.fromHex('#6cffff'),
                          child: pw.Column(children:[pw.Text('Past Month Cap'),], ),
                        ),


                      pw.Container(
                        color: PdfColor.fromHex('#6cffff'),
                        child: pw.Column(children:[ sumtotal >0 ? pw.Text('Past Month Due'):   pw.Text('Past Month adv.'),], ),
                      ),



                      pw.Container(
                        color: PdfColor.fromHex('#6cffff'),
                        child: pw.Column(children:[pw.Text('Amount'),], ),
                      ),

                        pw.Container(
                          color: PdfColor.fromHex('#6cffff'),
                          child: pw.Column(children:[pw.Text('Received '),], ),
                        ),
                        pw.Container(
                          color: PdfColor.fromHex('#6cffff'),
                          child: pw.Column(children:[ (totalamount-totalpaid) > 0 ? pw.Text('Advance') :   pw.Text('Balance'),], ),
                        ),
                    ]),


                      pw.TableRow( children: [

                        // color: PdfColor.fromHex('0xFFf1b0ea'),
                        pw.Container(

                          child: pw.Column(children:[pw.Text(oidchil.toString()),], ),
                        ),


                        pw.Container(

                          child: pw.Column(children:[pw.Text(oidcap.toString()),], ),
                        ),

                        pw.Container(

                          child: pw.Column(children:[pw.Text(sumtotal.toString().replaceAll(new RegExp(r'[^\w\s]+'),'')),], ),
                        ),


                        pw.Container(

                          child: pw.Column(children:[pw.Text(totalamount.toString()),], ),
                        ),

                        pw.Container(

                          child: pw.Column(children:[pw.Text(totalpaid.toString()),], ),
                        ),

                        pw.Container(

                          child: pw.Column(children:[pw.Text(((totalamount-totalpaid)+sumtotal).toString().replaceAll(new RegExp(r'[^\w\s]+'),'')),], ),
                        ),

                      ]),




                    ],
                  ),
                )


        ]
    ),
  ]
      ),
    );

    final bytes = await pdf.save();

    String filename="amarjeet+${Random().nextInt(100)}";

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename.pdf');
    await file.writeAsBytes(bytes);


    final url = file.path;

    await OpenFile.open(url);

    await file.writeAsBytes(await pdf.save());
  }












  Future<void> _showMyDialog() async {
    return showDialog<void>(

        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Card(
                child: AlertDialog(
                  title: const Text('Download Empty Sheet',
                    style: TextStyle(fontWeight: FontWeight.w800),),
                  // content: SingleChildScrollView(
                  // //   child: ListBody(
                  // //     children: const <Widget>[
                  // //
                  // //     ],
                  // //   ),
                  // // ),
                  actions: <Widget>[


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        InkWell(
                          onTap: () {
                            main();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text('Qr Code'),
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),

                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            billmonth();
                            check = 1;
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text('Full Dailt Sheet'),
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),

                              ),
                            ),
                          ),
                        ),


                      ],
                    ),

                    Container(
                      // height: 100,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue)
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Download Filled Sheet', style: TextStyle(
                              fontWeight: FontWeight.w800),),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Container(
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
                        InkWell(
                          onTap: () {
                            billmonth();
                            check = 2;
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SizedBox(width: 100,
                                    child: Text(            
                                      'Filled Entry Sheet', maxLines: 2,)),
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),

                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                    SizedBox(height: 50,),

                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text('Cencel'),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),

                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),


                  ],
                ),
              );
            },
          );
        }
    );
  }
}
