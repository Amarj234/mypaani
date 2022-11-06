import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../servise.dart';
class Addstock extends StatefulWidget {
  const Addstock({Key? key}) : super(key: key);

  @override
  _AddstockState createState() => _AddstockState();
}

class _AddstockState extends State<Addstock> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    allPerson();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  String uid ='0';
  String button ='Save';


  final chilledjar=TextEditingController();
  final capsulejar=TextEditingController();
  final water=TextEditingController();



  bool imageshow=false;

  Savedata() async{
    print(uid);
    SharedPreferences prefs =await SharedPreferences.getInstance();
    EasyLoading.show(status: 'loading...');
    final uri = Uri.parse(serves.url+"addstock.php");
    var request = http.MultipartRequest('POST',uri);

    request.fields['chilledjar'] = chilledjar.text;
    request.fields['vid'] = prefs.getString('vid').toString();
    request.fields['capsulejar'] = capsulejar.text;
    request.fields['water'] = water.text;
    request.fields['uid'] = uid.toString();



    var response = await request.send();
    var response1 = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      print('Image Uploded ${response1.body}');
      EasyLoading.showSuccess('Great Success!');


      chilledjar.text="";
      capsulejar.text="";
      water.text="";
      allPerson();
      setState(() {
        imageshow=false;
        uid='0';
        button="Save";
      });
      EasyLoading.dismiss();

      // Navigator.pop(context, 'OK');
    }else{
      EasyLoading.showError('Failed with Error');
    }
  }



  List<DataRow> state2=[];
  Serves serves=Serves();

  Future allPerson() async {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    state2=[];
    final uri = Uri.parse(serves.url+"addstock.php");
    var response = await http.post(uri,body: {
      'showdata':prefs.getString('vid'),

    });

    var state= json.decode(response.body);
    setState(() {
      state.forEach((item) {
        state2.add( DataRow(

            cells: [

              DataCell(Text(item['sdate'])),
              DataCell(Text(item['couldjar'])),
              DataCell(Text(item['capsulejar'])),
              DataCell(Text(item['water'])),


              DataCell(
                  IconButton(
                    icon: Icon(Icons.create,color: Colors.green,), onPressed: () {
                    Update(item['sid'],item['couldjar'],item['capsulejar'],item['water']);
                  },
                  )
              ),
            ]
        ),
        );
      }
      );
    });
  }
  void Update(upid,couldjar1,capsulejar1,water1){

    setState(() {
      button="Update";

      chilledjar.text=couldjar1;

      capsulejar.text=capsulejar1;
      water.text=water1;

      uid=upid;
    });

  }









  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your Stock'),

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(

            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(

                  child: Image.asset('assets/logofi.png',width: 200,),
                ),
              ),
              SizedBox(
                height: 20,
              ),




              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(

                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    style: TextStyle(color: Colors.black,fontSize: 20,),
                    textAlign: TextAlign.start,
                    controller: chilledjar,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border:  OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      labelText: 'Chilled Jar Stock',
                      hoverColor: Colors.black12,
                      hintText: 'Enter Chilled Jar qty',

                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(

                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    style: TextStyle(color: Colors.black,fontSize: 20,),
                    textAlign: TextAlign.start,
                    controller: capsulejar,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border:  OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      labelText: 'Capsule Jar Stock',
                      hoverColor: Colors.black12,
                      hintText: 'Enter Capsule Jar qty',

                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(

                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    style: TextStyle(color: Colors.black,fontSize: 20,),
                    textAlign: TextAlign.start,
                    controller: water,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border:  OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      labelText: 'Water Jar Stock',
                      hoverColor: Colors.black12,
                      hintText: 'Enter Water Jar qty',

                    ),
                    maxLines: 1,
                  ),
                ),
              ),



              SizedBox(
                height: 10,
              ),





              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: Card(
                  child: ElevatedButton(onPressed: (){
                    Savedata();
                  },
                      child: Text(button)),
                ),
              ),



              SizedBox(height: 10,),
              SizedBox(
                height:  MediaQuery.of(context).size.height/3,

                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(

                    decoration: BoxDecoration(
                      border:Border(

                          right: Divider.createBorderSide(context, width: 5.0),
                          left: Divider.createBorderSide(context, width: 5.0)
                      ),

                    ),
                    columns: [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Chilled jar')),
                      DataColumn(label: Text('Capsule jar')),
                      DataColumn(label: Text('Water')),
                      DataColumn(label: Text('Edit')),
                    ],
                    rows: state2,
                  ),
                ),
              ),
              SizedBox(height: 20,)

            ],
          ),
        ),
      ),
    );
  }
}
