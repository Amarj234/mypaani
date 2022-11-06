import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../maindashboard.dart';
import '../../servise.dart';
import '../adddrower.dart';
import 'addcustomer.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'singlecustomer.dart';


class dashboard extends StatefulWidget {
  const dashboard({Key? key,}) : super(key: key);


  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allcorce();
    setname();

  }

  String? capjarin;
  String? childjar;
  String? total;
  String? totalmonth;

  setname() async {
    final uri = Uri.parse(serves.url+"addmainpage.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var vid =prefs.getString('vid');
    print('fechdata+$uri');
    var response = await http.post(uri,body: {
      'vid':vid,
    });
    var state= json.decode(response.body);
print(state);
    setState((){
      capjarin=state[0]['childjar'];
      childjar=state[0]['jcapjarin'];
      total=state[0]['total'];
      totalmonth=state[0]['totalmonth'];

    });
    //  print(delivery);
  }


  final search = TextEditingController();
int count=0;
List<Container> costmer=[];
Serves serves=Serves();

  Future allcorce() async {

    final uri = Uri.parse(serves.url+"showcustomer.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var vid =prefs.getString('vid');

    var response = await http.post(uri,body: {
      'showdata':vid,
      'search':search.text,

    });

    var state= json.decode(response.body);
    costmer=[];
    if(state.length==0){
      costmer.add(Container(
        child :Center(child: Text('Customer Not Found')),)
      );
    }
    count=0;
    setState(() {

      state.forEach((item)async {
        count++;
        costmer.add(            Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue)
          ),
          child: ListTile(
            onTap: (){
              prefs.setString('cid', item['cid']);
              Navigator.push(
                context,MaterialPageRoute(builder: (context)=> Singlecustomer(name:item['name'],cid:item['cid'])),
              );


            },
            title : Text(item['name'].toString(),style: TextStyle(
                color: Colors.black87,fontWeight: FontWeight.w400,fontSize: 22,
                fontFamily:'RobotoMono'
            ),),
            subtitle: Text(item['mobile'].toString(),style: TextStyle(
                color: Colors.black87,fontWeight: FontWeight.w200,fontSize: 18
            ),),
            leading: CircleAvatar(
              child:  Image.asset('assets/cont.png',height: 200,),
            ),
            trailing: Icon(Icons.fiber_manual_record_outlined,color: Colors.green,),
          ),
        ),);

      }

      );
    });
  }





  DateTime? currentBackPressTime;
  Future<bool> onWillPop() async{
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      SharedPreferences prefs =await SharedPreferences.getInstance();
      var login= prefs.getString('login');
      print(login);
      if(login=='2'){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => maindashboard(),
            ));

      }else {
         SystemNavigator.pop();
      }

    }
    return Future.value(true);
  }



bool paymentshow=false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      drawer: Adddroewr(),
      body: WillPopScope(
        onWillPop: onWillPop ,
        child: costmer.length==0? CircularProgressIndicator() :SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
child: Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Row(
    children: [
        Text('All Customer ',style: TextStyle(
              fontWeight: FontWeight.w800,fontSize: 20,
            fontFamily:'RobotoMono'
        )),
        Text(' ($count Customer)',style: TextStyle(
              fontSize: 15,
              fontFamily:'RobotoMono'
        )),
    ],
  ),


),
                  ),
                ),
                Container(
                  color: Colors.lime,
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: TextField(
                        controller: search,
                        onChanged: (value) {

                          allcorce();
                          setState(() {
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search By Name or Phone",
                            prefixIcon: Icon(Icons.search),
                          suffixIcon:IconButton(
                            onPressed: (){},
                            icon:  Icon(Icons.filter_list_alt)
                          ),
                        ),
                      ),
                    ),

                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                 // height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue)
                    ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      InkWell(
                      onTap: (){
                        setState((){
if(paymentshow==true){
  paymentshow=false;
}else{
  paymentshow=true;
}

                        });

                      },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                            children: [
                               Text("Today's Payment",style: TextStyle(
                                color: Colors.black38,fontWeight: FontWeight.w800,fontSize: 16
                              ),

                               ),

                              Expanded(child:  Icon(Icons.keyboard_arrow_down_outlined))
                            ],
                          ),
                    ),
                      ),

Container(

  decoration: BoxDecoration(
      border: Border.all(color: Colors.blue)
  ),
),
                      Visibility(
                        visible: paymentshow,
                        child:   Column(
                          children: [
                            Row(
                            children: [
                               Icon(Icons.alarm),
                              TextButton(onPressed: (){}, child: Text("Daily Paying Costomer Collection     ",style: TextStyle(
                                  color: Colors.black38,fontWeight: FontWeight.w400,fontSize: 16
                              ),
                              ),
                              ),

                              Image.asset('assets/rup.png',height: 20,),
                        SizedBox(width: 10,),
                        Expanded(
                          child: total==null ? Text('0'): Text(total.toString(),style: TextStyle(
                              color: Colors.black,fontWeight: FontWeight.w800,fontSize: 15
                          ),
                          ),
                        )
                            ],
                      ),

                            Container(

                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue)
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_today_outlined),
                                TextButton(onPressed: (){}, child: Text("Monthly Paying Costomer Collection",style: TextStyle(
                                    color: Colors.black38,fontWeight: FontWeight.w400,fontSize: 16
                                ),
                                ),
                                ),

                                Image.asset('assets/rup.png',height: 20,),
                                SizedBox(width: 10,),
                                totalmonth==null ? Text('0'):  Text(totalmonth.toString(),style: TextStyle(
                                    color: Colors.black,fontWeight: FontWeight.w800,fontSize: 15
                                ),
                                )
                              ],
                            ),
                          ],
                        ),),

                      Container(
                        decoration: BoxDecoration(

                            border: Border.all(color: Colors.blue)
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("jar Delivered",style: TextStyle(
                                  color: Colors.black38,fontWeight: FontWeight.w800,fontSize: 16
                              ),),
                            ),

                            Image.asset('assets/cjar.png',width: 22,),

                              Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:childjar==null ? Text('0'):  Text(childjar.toString(),style: TextStyle(
                                  color: Colors.black87,fontWeight: FontWeight.w800,fontSize: 25
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:   Container(width: 2,
                                height: 30,
                                color: Colors.black87,
                              ),
                            ),



Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Container(width: 2,
  height: 30,
  color: Colors.black87,
  ),
),
                            SizedBox(width: 5,),
                            Image.asset('assets/jar.png',width: 18,),
                            SizedBox(width: 5,),
                              Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:capjarin==null ? Text('0'):  Text(capjarin.toString(),style: TextStyle(
                                  color: Colors.black87,fontWeight: FontWeight.w800,fontSize: 25
                              ),),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: costmer,
                        ),
                      ),

                    ],
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           Navigator.push(
            context,MaterialPageRoute(builder: (context)=> addcustomer()),
            );

        },
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add),
        label: Text('Add Customer'),

      ),
    );
  }

}
