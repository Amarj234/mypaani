import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../maindashboard.dart';
import 'Widget/addproduct.dart';
import 'Widget/addstock.dart';
import 'Widget/chatscreen.dart';
import 'Widget/custreport.dart';
import 'Widget/deliverypin.dart';
import 'Widget/screens/productlist.dart';

import 'loginPage.dart';



class Adddroewr extends StatefulWidget {
  const Adddroewr({Key? key}) : super(key: key);

  @override
  _AdddroewrState createState() => _AdddroewrState();
}

class _AdddroewrState extends State<Adddroewr> {

  int select=0;

  void focosicon(int index){
    setState(() {
      select=index;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chechnane();
  }

  String? mobile;
  String? name;

chechnane()async{
  SharedPreferences prefs =await SharedPreferences.getInstance();
  setState(() {
    name = prefs.getString('name');
    mobile=prefs.getString('mobile');
  });
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child:ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 200,
              child: DrawerHeader(
                decoration: BoxDecoration(

                  // image: new DecorationImage(
                  //   image: new ExactAssetImage('assets/jar.png'),
                  //   fit: BoxFit.cover,
                  // ),

                ),

                child: Container(

                  child: ListView(
                    children: [
                      CircleAvatar(radius: (52),
                          backgroundColor: Colors.white,
                          child: ClipRRect(
                            borderRadius:BorderRadius.circular(50),
                            child: Image.asset('assets/jar.png'),
                          )
                      ),
                      Container(

                        child:  Text(name.toString() ,style: TextStyle(fontSize: 30,color: Colors.black45),),
                      ),
                      Container(

                        child:  Text(mobile.toString() ,style: TextStyle(fontSize: 15,color: Colors.black45,),),

                      ),

                    ],
                  ),
                ),

              ),
            ),
            ListTile(
              selected: select==0,
              leading: Icon(Icons.home),
              title: Text("Home",style: TextStyle(fontSize: 20,color: Colors.black),),
              onTap: (){
                focosicon(0);

              },
            ),
            ListTile(
              selected: select==1,
              leading: Icon(Icons.messenger_rounded),
              title: Text("Message",style:  TextStyle(fontSize: 20,color: Colors.black),),
              onTap: (){
                focosicon(1);

              },
            ),
            ListTile(
              selected: select==2,
              leading: Icon(Icons.workspace_premium_outlined),
              title: Text("Premium Plan1",style:  TextStyle(fontSize: 20,color: Colors.black),),
              onTap: (){
                focosicon(2);

              },
            ),

            ListTile(
              selected: select==3,
              leading: Icon(Icons.monetization_on_sharp),
              title: Text("Add Product",style:  TextStyle(fontSize: 20,color: Colors.black),),
              onTap: (){
                focosicon(3);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => addproduct(),
                    ));

              },
            ),
            ListTile(
              selected: select==4,
              leading: Icon(Icons.search_off),
              title: Text("Add pin",style:  TextStyle(fontSize: 20,color: Colors.black),),
              onTap: (){
                focosicon(4);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => addpin(),
                    ));

              },
            ),

            ListTile(
              selected: select==5,
              leading: Icon(Icons.wallet_giftcard),
              title: Text("Payment",style:  TextStyle(fontSize: 20,color: Colors.black),),
              onTap: (){

                focosicon(5);

              },
            ),
            ListTile(
              selected: select==6,
              leading: Icon(Icons.production_quantity_limits_rounded),
              title: Text("Product",style:  TextStyle(fontSize: 20,color: Colors.black),),
              onTap: (){

                focosicon(6);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => productlist(),
                    ));

              },
            ),

            ListTile(
              selected: select==7,
              leading: Icon(Icons.group),
              title: Text("Groups",style:  TextStyle(fontSize: 20,color: Colors.black),),
              onTap: (){

                focosicon(7);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => chatscreen(),
                    ));
              },
            ),

            ListTile(
              selected: select==8,
              leading: Icon(Icons.inventory),
              title: Text("Manage Inventory",style:  TextStyle(fontSize: 20,color: Colors.black),),
              onTap: (){

                focosicon(8);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => maindashboard(),
                    ));
              },
            ),


            ListTile(
              selected: select==9,
              leading: Icon(Icons.markunread_mailbox_sharp),
              title: Text("Jar Report",style:  TextStyle(fontSize: 20,color: Colors.black),),
              onTap: (){
                focosicon(9);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Addstock(),
                    ));
         },
            ),
            ListTile(
              selected: select==10,
              leading: Icon(Icons.local_police_rounded),
              title: Text("Policy",style:  TextStyle(fontSize: 20,color: Colors.black),),
              onTap: (){
                focosicon(10);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => custreport(),
                    ));

              },
            ),

            ListTile(
              selected: select==11,
              leading: Icon(Icons.logout),
              title: Text("Logout",style:  TextStyle(fontSize: 20,color: Colors.black),),
              onTap: () async{
                focosicon(11);

                SharedPreferences prefs =await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              },
            ),


          ],
        ),


      ),
    );
  }
}
