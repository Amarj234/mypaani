import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'servise.dart';
import 'src/Widget/addproduct.dart';
import 'src/Widget/addstock.dart';
import 'src/Widget/chatscreen.dart';
import 'src/Widget/createemp.dart';
import 'src/Widget/dashboard.dart';
import 'src/Widget/deliverypin.dart';
import 'src/Widget/empprofit.dart';
import 'src/Widget/expense.dart';
import 'src/Widget/report.dart';
import 'src/Widget/screens/productlist.dart';
import 'src/Widget/singlecustomer.dart';
import 'src/stockreport.dart';

class maindashboard extends StatefulWidget {
  const maindashboard({Key? key}) : super(key: key);

  @override
  _maindashboardState createState() => _maindashboardState();
}

class _maindashboardState extends State<maindashboard> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(new Duration(seconds: 5), (timer) {
      setname();
    });
  }

  Serves serves=Serves();

  Future allcorce() async {

    final uri = Uri.parse(serves.url+"dailyreport.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var vid =prefs.getString('vid');

    var response = await http.post(uri,body: {
      'showdata':vid,


    });
    print('fechdata'+vid!);
    var state= json.decode(response.body);


  }
  String? delivery;
  String? total;

  setname() async {
    final uri = Uri.parse(serves.url+"dailyfech.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
   var vid =prefs.getString('vid');

    var response = await http.post(uri,body: {
      'vid':vid,
    });
    var state= json.decode(response.body);

    setState((){
      delivery=state[0]['delevery'];
      total=state[0]['total'];

    });
  //  print(delivery);
  }




  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

DateTime? currentBackPressTime;
Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
    currentBackPressTime = now;
      SystemNavigator.pop();
  }
  return Future.value(true);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff8674ee),
        centerTitle: true,
        actions: [
          SizedBox(width: 30,),
          Expanded(child:  Icon(Icons.notification_important_rounded,size: 40,color: Colors.cyanAccent,), ),


          InkWell(
              onTap: ()async{
                SharedPreferences prefs =await SharedPreferences.getInstance();
                if (await Permission.camera.request().isGranted) {
                  var status = await Permission.camera.status;
                  if (status.isGranted) {
                    String? cameraScanResult = await scanner.scan();
                    print(cameraScanResult);
                    prefs.setString('cid', cameraScanResult.toString());
                    Navigator.push(
                      context,MaterialPageRoute(builder: (context)=> Singlecustomer(name:'',cid:cameraScanResult.toString())),
                    );

                  }
                }


                // Navigator.push(
                //   context,MaterialPageRoute(builder: (context)=> qrcoder()),
                // );
              },
              child: Card(child: Image.asset('assets/qrcode.png',width: 60,))),

          Expanded(child: Image.asset('assets/wtsapp.png',width: 60,)),

          Expanded(child: Image.asset('assets/youtube.png',width: 60,)),

        ],

      ),
      body:WillPopScope(
        onWillPop: onWillPop ,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE9F1A0),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      height:  MediaQuery.of(context).size.height/8,
                      width:   MediaQuery.of(context).size.width/2.2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [


                            Text('Daily Payment',style: TextStyle(fontSize: 20,color: Colors.black),),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:total==null ? Text('0',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.w800)):  Text(total.toString(),style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.w800),),
                            ),
                          ],

                        ),
                      ),

                    ),
                    SizedBox(width: 10,),

                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE9F1A0),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      height:  MediaQuery.of(context).size.height/8,
                      width:   MediaQuery.of(context).size.width/2.2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [

                            Text('Daily Delivery',style: TextStyle(fontSize: 20,color: Colors.black),),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:delivery==null ? Text('0',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.w800)): Text(delivery.toString(),style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.w800),),
                            ),
                          ],

                        ),
                      ),

                    ),

                  ],
                ),
              ),




              Expanded(
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children:[
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => productlist()),
                        );

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height:  MediaQuery.of(context).size.height/5,
                        width:   MediaQuery.of(context).size.width/2.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.production_quantity_limits,size: 60,color: Colors.blue,),

                              Text('Product',style: TextStyle(fontSize: 15,color: Colors.black),),

                            ],

                          ),
                        ),

                      ),
                    ),

                    InkWell(
                      onTap: (){

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => chatscreen(),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height:  MediaQuery.of(context).size.height/5,
                        width:   MediaQuery.of(context).size.width/2.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.group,size: 60,color: Colors.blue,),

                              Text('Group',style: TextStyle(fontSize: 15,color: Colors.black),),

                            ],

                          ),
                        ),

                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => dashboard()),
                        );

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height:  MediaQuery.of(context).size.height/5,
                        width:   MediaQuery.of(context).size.width/2.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.man_rounded,size: 60,color: Colors.blue,),

                              Text('Customer',style: TextStyle(fontSize: 15,color: Colors.black),),

                            ],

                          ),
                        ),

                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => expense()),
                        );

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height:  MediaQuery.of(context).size.height/5,
                        width:   MediaQuery.of(context).size.width/2.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.money_off,size: 60,color: Colors.blue,),

                              Text('Expense',style: TextStyle(fontSize: 15,color: Colors.black),),

                            ],

                          ),
                        ),

                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => Addstock()),
                        );

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height:  MediaQuery.of(context).size.height/5,
                        width:   MediaQuery.of(context).size.width/2.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.backpack_outlined,size: 60,color: Colors.blue,),

                              Text('Add Stock',style: TextStyle(fontSize: 15,color: Colors.black),),

                            ],

                          ),
                        ),

                      ),
                    ),

                    InkWell(
                      onTap: (){
                        // Navigator.push(
                        //   context, MaterialPageRoute(
                        //     builder: (context) => productlist(vid:state[i]['vid'])),
                        // );

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height:  MediaQuery.of(context).size.height/5,
                        width:   MediaQuery.of(context).size.width/2.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.payment_outlined,size: 60,color: Colors.blue,),

                              Text('Payments',style: TextStyle(fontSize: 15,color: Colors.black),),

                            ],

                          ),
                        ),

                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => empprofit()),
                        );

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height:  MediaQuery.of(context).size.height/5,
                        width:   MediaQuery.of(context).size.width/2.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.monetization_on_outlined,size: 60,color: Colors.blue,),

                              Text('Emp. profit',style: TextStyle(fontSize: 15,color: Colors.black),),

                            ],

                          ),
                        ),

                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => createemp()),
                        );

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height:  MediaQuery.of(context).size.height/5,
                        width:   MediaQuery.of(context).size.width/2.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.group_add_sharp,size: 60,color: Colors.blue,),

                              Text('Employee',style: TextStyle(fontSize: 15,color: Colors.black),),

                            ],

                          ),
                        ),

                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => stockreport()),
                        );

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height:  MediaQuery.of(context).size.height/5,
                        width:   MediaQuery.of(context).size.width/2.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.bug_report_outlined,size: 60,color: Colors.blue,),

                              Text('Stock Report',style: TextStyle(fontSize: 15,color: Colors.black),),

                            ],

                          ),
                        ),

                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => addpin()),
                        );

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height:  MediaQuery.of(context).size.height/5,
                        width:   MediaQuery.of(context).size.width/2.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.location_on_outlined,size: 60,color: Colors.blue,),

                              Text('Add pin',style: TextStyle(fontSize: 15,color: Colors.black),),

                            ],

                          ),
                        ),

                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => addproduct()),
                        );

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height:  MediaQuery.of(context).size.height/5,
                        width:   MediaQuery.of(context).size.width/2.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.add_to_photos_outlined,size: 60,color: Colors.blue,),

                              Text('product',style: TextStyle(fontSize: 15,color: Colors.black),),

                            ],

                          ),
                        ),

                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => myreport()),
                        );

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height:  MediaQuery.of(context).size.height/5,
                        width:   MediaQuery.of(context).size.width/2.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.report,size: 60,color: Colors.blue,),

                              Text('Report',style: TextStyle(fontSize: 15,color: Colors.black),),

                            ],

                          ),
                        ),

                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'report',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
