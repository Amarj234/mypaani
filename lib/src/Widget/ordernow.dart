import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../servise.dart';

class ordernow extends StatefulWidget {
  const ordernow({Key? key}) : super(key: key);

  @override
  State<ordernow> createState() => _ordernowState();
}

class _ordernowState extends State<ordernow> {

  int cartcount=0;
  int totalsv=0;

alltotal(){
  totalsv=0;
  setState((){
  for(int i=0;i<(controllers1.length);i++){


    totalsv+=int.parse(controllers1[i].text);



  }
  });
}


  remove(pid) async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    final uri = Uri.parse(serves.url+"deletecart.php");
    var response = await http.post(uri,body: {
      'delete':"",
      'pid':pid.toString(),
      'cid':prefs.getString('cid'),


    });
    print(response.hashCode);
if(response.statusCode==200) {

  allPerson();

}
  }

  late List<TextEditingController> controllers;
  late List<TextEditingController> controllers1;
  bool? buy;

  List<int> totals=[];


  @override
  void dispose() {
    controllers.forEach((c) => c.dispose());
    super.dispose();
  }


  void initState() {
    // TODO: implement initState
    super.initState();


    Timer(Duration(seconds: 1), () => allPerson());

  }
  void totalfun(price,i){
    setState((){
      totals[i]= int.parse( controllers[i].text)*int.parse(price);

    });
  }


  Serves serves=Serves();
  List<Card> state2=[];
  Future allPerson() async {

    print('amarjeet');

    final uri = Uri.parse(serves.url+"addtocart.php");
    var response = await http.post(uri,body: {
      'showdata':"",

    });

    var state= json.decode(response.body);
    if(state.length==0){
      Navigator.pop(context);
    }
    setState((){
      cartcount=state.length;


    });

    controllers = List.generate(state.length, (i) => TextEditingController());
    controllers1 = List.generate(state.length, (i) => TextEditingController());
    state2=[];
    for (int i = 0; i < state.length; i++) {
      totals.add(0);
      setState(() {
        state2.add( Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(state[i]['pname'].toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'RobotoMono'
                  ),),
              ),

              Row(
                children: [

                  Text("₹ - ${state[i]['pprice']}".toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w200,
                        fontSize: 15
                    ),),
                  // Text("Total - ${totals[i]}".toString(),
                  //   overflow: TextOverflow.ellipsis,
                  //   maxLines: 1,
                  //   style: TextStyle(
                  //       color: Colors.black87,
                  //       fontWeight: FontWeight.w200,
                  //       fontSize: 15
                  //   ),),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5),
                    child: Row(
                      children: [


                        SizedBox(width: MediaQuery
                            .of(context)
                            .size
                            .width / 8.5),
                        InkWell(
                          onTap: () {

                            if (controllers[i].text != "0") {
                              int amae = int.parse(
                                  controllers[i].text);
                              controllers[i].text =
                                  (amae - 1).toString();
                              controllers1[i].text=(int.parse(controllers[i].text)*int.parse(state[i]['pprice'])).toString();
                              alltotal();
                            }

                            totalfun(state[i]['pprice'],i);
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
                          width: 40,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xff5abbad))
                            ),
                            child: TextFormField(
// initialValue: '0',
                              controller: controllers[i],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: '0',

                              ),


                            ),
                          )
                          ,),

                        InkWell(
                          onTap: () {
                            // print(totals[i]);


                            if(controllers[i].text==""){
                              controllers[i].text =1.toString();

                            }else {
                              controllers[i].text =
                                  (int.parse(controllers[i].text) + 1)
                                      .toString();
                              controllers1[i].text=(int.parse(controllers[i].text)*int.parse(state[i]['pprice'])).toString();
                            }
                            Timer(Duration(seconds: 1), () =>  totalfun(state[i]['pprice'],i));
                            alltotal();

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
                ],
              ),
              SizedBox(height: 1,),
              Row(
                children: [
                  Text("Total-₹ ".toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        fontSize: 18
                    ),),


                  SizedBox(
                    width: 40,
                    child: TextField(
                      decoration: InputDecoration(
                      border: InputBorder.none,

        ),
                      style: TextStyle(color: Colors.red),
                      readOnly: true,
                      controller: controllers1[i],
                    ),
                  ),
                  SizedBox(width: 10,),
                  Flexible(
                    child: InkWell(
                      onTap: (){
                        remove(state[i]['pid']);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(

                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('Remove',style: TextStyle(color: Colors.black),),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xfff5f5f5),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Image.network(serves.url+state[i]['pimage'],height: 100,width: 150,),
                ],
              )

            ],
          ),
        ),


        );
      });
      controllers1[i].text=state[i]['total'];
      controllers[i].text=state[i]['qty'];
    }
    await alltotal();

  }






  @override
  Widget build(BuildContext context) {
    return state2.length==0? Center(child: CircularProgressIndicator()): Scaffold(
      appBar: AppBar(
        title: Text('Product Order'),
        actions: [ Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Badge(
                badgeContent: Text(cartcount.toString()),
                child:  Icon(Icons.shopping_cart),


              ),
            ),
          ),
        ) ],
      ),
      body:  ListView(
        children: state2,
      ),
      bottomNavigationBar: BottomAppBar(

        color:Color(0xfff1f1f1),
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: SizedBox(
            height: 90,
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //   child: SizedBox(
                //     height: 60,
                //     child: DropdownButtonFormField(
                //       hint: Text('Select Floor'),
                //       decoration: const InputDecoration(
                //         border: OutlineInputBorder(),
                //       ), onChanged: (value) {
                //  //     floor=value.toString();
                //     },
                //       items: [
                //         DropdownMenuItem(child: Text("Ground Floor"), value: "0"),
                //         DropdownMenuItem(child: Text("1st Floor"), value: "1"),
                //         DropdownMenuItem(child: Text("2st Floor"), value: "2"),
                //         DropdownMenuItem(child: Text("3st Floor"), value: "3"),
                //         DropdownMenuItem(child: Text("4st Floor"), value: "4"),
                //         DropdownMenuItem(child: Text("5st Floor"), value: "5"),
                //
                //       ],
                //     ),
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: <Widget>[
                      Text('Delevery Charge'),
                      SizedBox(width: MediaQuery.of(context).size.width/1.8,),
                      Expanded(child: Text('₹ 10')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Text("₹ $totalsv".toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 30
                        ),),
                      SizedBox(width: MediaQuery.of(context).size.width/3,),
                    ElevatedButton(onPressed: (){}, child: Text('Confirm Order'))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );

  }
}



