import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../servise.dart';


class stockreport extends StatefulWidget {
  const stockreport({Key? key}) : super(key: key);

  @override
  _stockreportState createState() => _stockreportState();
}

class _stockreportState extends State<stockreport> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setname();

  }

  int capstock=0;
  int coolstock=0;
  int capsum=0;
  int coolsum=0;
  Serves serves=Serves();


  List<ListTile> state2=[];
  setname()async {
    final uri = Uri.parse(serves.url+"stockreport.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
  var  vid =prefs.getString('vid');

    var response = await http.post(uri,body: {
      'showdata':vid,

    });
    var state= json.decode(response.body);
    print(state);
    setState((){
      coolstock=int.parse(state[0]['chill']);
      capstock=(int.parse(state[0]['cap']));
    state.forEach((item){

      capsum=int.parse(item['cap2'])+capsum;
     coolsum=int.parse(item['chill2'])+coolsum;


      state2.add(ListTile(
        onTap: (){
          prefs.setString('cid', item['cid']);


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
        trailing: Column(
          children: [
            Text("Cooljar- ${item['chill2']}"),
            Text("Capjar- ${item['cap2']}"),
          ],
        ),
      ));
    });



    });


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Report'),
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                        Text('${(coolstock-coolsum)} ×', style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            fontSize: 25,
                            fontFamily: 'RobotoMono'
                        ),),
                        Image.asset('assets/cjar.png', height: 60,),
                        Text('+ ${(capstock-capsum)}× ', style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            fontSize: 25,
                            fontFamily: 'RobotoMono'
                        ),),

                        Image.asset('assets/jar.png', height: 40,),
                        SizedBox(width: 20,),
                        Text('=  ${((coolstock-coolsum)+(capstock-capsum))} ', style: TextStyle(
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
              child: SingleChildScrollView(
                child: Column(
                  children: state2,
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
