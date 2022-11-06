import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../servise.dart';
class expense extends StatefulWidget {
  const expense({Key? key}) : super(key: key);

  @override
  _expenseState createState() => _expenseState();
}

class _expenseState extends State<expense> with SingleTickerProviderStateMixin {
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



  final capsulejar=TextEditingController();
  final water=TextEditingController();



  bool imageshow=false;

  Savedata() async{
    print(uid);
    SharedPreferences prefs =await SharedPreferences.getInstance();
    EasyLoading.show(status: 'loading...');
    final uri = Uri.parse(serves.url+"expense.php");
    var request = http.MultipartRequest('POST',uri);


    request.fields['vid'] = prefs.getString('vid').toString();
    request.fields['capsulejar'] = capsulejar.text;
    request.fields['water'] = water.text;
    request.fields['uid'] = uid.toString();



    var response = await request.send();
    var response1 = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      print('Image Uploded ${response1.body}');
      EasyLoading.showSuccess('Great Success!');



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
    final uri = Uri.parse(serves.url+"expense.php");
    var response = await http.post(uri,body: {
      'showdata':prefs.getString('vid'),

    });

    var state= json.decode(response.body);

    setState(() {
      state.forEach((item) {
        state2.add( DataRow(

            cells: [

              DataCell(Text(item['date1'].toString())),
              DataCell(Text(item['remark'].toString())),
              DataCell(Text(item['totallos'.toString()])),



              DataCell(
                  IconButton(
                    icon: Icon(Icons.create,color: Colors.green,), onPressed: () {
                    Update(item['id'],item['totallos'],item['remark']);
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
  void Update(upid,capsulejar1,water1){

    setState(() {
      button="Update";



      capsulejar.text=water1;
      water.text=capsulejar1;

      uid=upid;
    });

  }









  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your expense'),

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
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SizedBox(
height: 40,
                  child: TextFormField(
                  //  keyboardType: TextInputType.numberWithOptions(),
                    style: TextStyle(color: Colors.black,fontSize: 15,),
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
                      labelText: ' Remark',
                      hoverColor: Colors.black12,
                      hintText: 'Remark',

                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SizedBox(
                  height: 40,
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
                      labelText: 'Amount',
                      hoverColor: Colors.black12,
                      hintText: 'Amount',

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
                      DataColumn(label: Text('Remark')),
                      DataColumn(label: Text('Amount')),

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
