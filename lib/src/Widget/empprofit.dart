import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../servise.dart';
import 'singleemp.dart';
class empprofit extends StatefulWidget {
  const empprofit({Key? key}) : super(key: key);

  @override
  _empprofitState createState() => _empprofitState();
}

class _empprofitState extends State<empprofit> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allcorce();

  }

  final search = TextEditingController();

  List<Container> costmer=[];
  Serves serves=Serves();

  Future allcorce() async {

    final uri = Uri.parse(serves.url+"showemp.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var vid =prefs.getString('vid');

    var response = await http.post(uri,body: {
      'showdata':vid,
      'search':search.text,

    });
    print('fechdata+$uri');
    var state= json.decode(response.body);
    costmer=[];
    if(state.length==0){
      costmer.add(Container(
        child :Center(child: Text('Employee Not Found')),)
      );
    }

    setState(() {
      state.forEach((item)async {
        costmer.add(            Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
            topLeft: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0)),
        ),

          child: ListTile(
            onTap: (){

              Navigator.push(
                context,MaterialPageRoute(builder: (context)=> singleEmployee(eid:item['empid'],name:item['ename'].toString())),
              );


            },
            title : Text(item['ename'].toString(),style: TextStyle(
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  title: Text('Employee'),
),
      body: SafeArea(
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
                        Text('Your Employee ',style: TextStyle(
                            fontWeight: FontWeight.w800,fontSize: 20,
                            fontFamily:'RobotoMono'
                        )),
                        // Text(' (2 Customer)',style: TextStyle(
                        //     fontSize: 15,
                        //     fontFamily:'RobotoMono'
                        // )),
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

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [








                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: costmer,
                      ),
                    ),

                  ],
                ),




            ],
          ),
        ),
      ),
    );
  }
}
