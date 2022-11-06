import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../servise.dart';
class addpin extends StatefulWidget {
  const addpin({Key? key}) : super(key: key);

  @override
  State<addpin> createState() => _addpinState();
}

class _addpinState extends State<addpin> {

  String uid ='0';
  String button ='Save';


  final corceprice=TextEditingController();



  void initState() {
    super.initState();
    allPerson();
  }

  bool imageshow=false;

  Savedata() async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    EasyLoading.show(status: 'loading...');
    final uri = Uri.parse(serves.url+"addpin.php");
    var request = http.MultipartRequest('POST',uri);

    request.fields['pincode'] = corceprice.text;
    request.fields['vid'] = prefs.getString('vid').toString();

    request.fields['uid'] = uid.toString();



    var response = await request.send();
    var response1 = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      print('Image Uploded ${response1.body}');
      EasyLoading.showSuccess('Great Success!');


      corceprice.text="";

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
    final uri = Uri.parse(serves.url+"addpin.php");
    var response = await http.post(uri,body: {
      'showdata':prefs.getString('vid'),

    });

    var state= json.decode(response.body);
    setState(() {
      state.forEach((item) {
        state2.add( DataRow(

            cells: [

              DataCell(Text(item['id'])),
              DataCell(Text(item['pin'])),

              DataCell(
                  IconButton(
                    icon: Icon(Icons.create,color: Colors.green,), onPressed: () {
                    Update(item['id'],item['pin']);
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
  void Update(upid,value){

    setState(() {
      button="Update";

      corceprice.text=value.toString();

      uid=upid;
    });

  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your Product'),
      ),
      body:  SafeArea(
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
                    controller: corceprice,
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
                      labelText: 'Delivery PinCode',
                      hoverColor: Colors.black12,
                      hintText: 'Enter Delivery Pin',

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
                      DataColumn(label: Text('Id')),
                      DataColumn(label: Text('PinCode')),
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
