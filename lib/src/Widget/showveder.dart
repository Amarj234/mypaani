import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mypaani/src/Widget/venderdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../servise.dart';
import '../loginPage.dart';
import 'custreport.dart';




class showvender extends StatefulWidget {
  const showvender({Key? key}) : super(key: key);

  @override
  State<showvender> createState() => _showvenderState();
}

class _showvenderState extends State<showvender> {




  void initState() {
    // TODO: implement initState
    super.initState();
    chechnane();

    Timer(Duration(seconds: 1), () => allPerson());

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


  final searchcotroller=TextEditingController();

  Serves serves=Serves();
  List<InkWell> state2=[];
  Future allPerson() async {

    state2=[];

    final uri = Uri.parse(serves.url+"showvendr.php");
    var response = await http.post(uri,body: {
      'showdata':searchcotroller.text,

    });
print((response.body));
    var state= json.decode(response.body);


    for (int i = 0; i < state.length; i++) {

      setState(() {
        state2.add(
          InkWell(
            onTap: (){
              // Navigator.push(
              //   context, MaterialPageRoute(
              //     builder: (context) => productlist(vid:state[i]['vid'])),
              // );
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => venderdetaills(vid:state[i]['vid'])),
              );
            },
            child: Container(
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
              height:  MediaQuery.of(context).size.height/5,
              width:   MediaQuery.of(context).size.width/2.2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset('assets/logofi1.png',width: 100,height: 80,),

                    Text(state[i]['name'].toString(),style: TextStyle(fontSize: 20,),),

                  ],

                ),
              ),

            ),
          ),

        );
      });

    }


  }


  int select=0;

  void focosicon(int index){
    setState(() {
      select=index;
    });
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
    return Scaffold(
      drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
                children: <Widget>[
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
                  SizedBox(height: 20),
                  ListTile(
                    selected: select==1,

                    leading: Icon(Icons.report),
                    title: Text('Report'),
                    onTap: (){
                      focosicon(1);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => custreport(),
                          ));
                    },
                  ),
                  ListTile(
                    selected: select==2,
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),

                      onTap: () async{
                        focosicon(2);

                        SharedPreferences prefs =await SharedPreferences.getInstance();
                        prefs.clear();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));

                    },
                  ),
                ]
            ),
          )
      ),

      appBar: AppBar(
        backgroundColor: Color(0xff66938b),
        actions: [
          // Navigate to the Search Screen
          SizedBox(
            width: MediaQuery.of(context).size.width/1.2,
            child: TextField(
              onChanged: (v){
                Timer(Duration(seconds: 1), () => allPerson());
                allPerson();
                setState(() {

                });
              },
              controller: searchcotroller,
              decoration: InputDecoration(
                  //prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      allPerson();                    },
                  ),
                  hintText: 'Search PinCode...',
                  border: InputBorder.none),
            ),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: onWillPop ,
        child: SafeArea(child: state2.length==0? Center(child: CircularProgressIndicator()): GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children:state2,
        )),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // Navigator.push(
      //     //   context,MaterialPageRoute(builder: (context)=> addcustomer()),
      //     // );
      //
      //   },
      //   backgroundColor: Colors.red,
      //   icon: const Icon(Icons.logout),
      //   label: Text('Logout'),
      //
      // ),
    );


  }

}
