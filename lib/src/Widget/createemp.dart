import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../servise.dart';
class createemp extends StatefulWidget {
  const createemp({Key? key}) : super(key: key);

  @override
  _createempState createState() => _createempState();
}

class _createempState extends State<createemp> with SingleTickerProviderStateMixin {
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


  final empname=TextEditingController();
  final empmobile=TextEditingController();
  final addsess=TextEditingController();
  final pincode=TextEditingController();



  bool imageshow=false;

  Savedata() async{

    SharedPreferences prefs =await SharedPreferences.getInstance();
    EasyLoading.show(status: 'loading...');
    final uri = Uri.parse(serves.url+"addemp.php");
    var request = http.MultipartRequest('POST',uri);

    request.fields['ename'] = empname.text;
    request.fields['emobile'] = empmobile.text;
    request.fields['eaddress'] = addsess.text;
    request.fields['epincode'] = pincode.text;
    request.fields['uid'] = uid.toString();
    request.fields['vid'] = prefs.getString('vid').toString();


    var response = await request.send();
    var response1 = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      print('Image Uploded ${response1.body}');
      EasyLoading.showSuccess('Great Success!');


      empname.text="";
      empmobile.text="";
      addsess.text="";
      pincode.text="";
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
    final uri = Uri.parse(serves.url+"addemp.php");
    var response = await http.post(uri,body: {
      'showdata':prefs.getString('vid'),

    });

    var state= json.decode(response.body);
    setState(() {
      state.forEach((item) {
        state2.add( DataRow(

            cells: [

              DataCell(Text(item['date1'])),
              DataCell(Text(item['ename'])),
              DataCell(Text(item['mobile'])),
              DataCell(Text(item['address'])),
              DataCell(Text(item['pincode'])),

              DataCell(
                  IconButton(
                    icon: Icon(Icons.create,color: Colors.green,), onPressed: () {
                    Update(item['eid'],item['ename'],item['mobile'],item['address'],item['pincode']);
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
  void Update(eid,name,mobile,address, pin){

    setState(() {
      button="Update";

      empname.text=name;
      empmobile.text=mobile;
      addsess.text=address;
      pincode.text=pin;

      uid=eid;
    });

  }









  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your Employee'),

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

                    style: TextStyle(color: Colors.black,fontSize: 20,),
                    textAlign: TextAlign.start,
                    controller: empname,
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
                      labelText: 'Employee Name',
                      hoverColor: Colors.black12,
                      hintText: 'Employee Name',

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
                    controller: empmobile,
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
                      labelText: 'Employee Mobile',
                      hoverColor: Colors.black12,
                      hintText: 'Employee Mobile',

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

                    style: TextStyle(color: Colors.black,fontSize: 20,),
                    textAlign: TextAlign.start,
                    controller: addsess,
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
                      labelText: 'Employee address',
                      hoverColor: Colors.black12,
                      hintText: 'Employee address',

                    ),
                    maxLines: 2,
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
                    controller: pincode,
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
                      labelText: 'Employee Pincode',
                      hoverColor: Colors.black12,
                      hintText: 'Employee Pincode',

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
                      DataColumn(label: Text('Employee Name')),
                      DataColumn(label: Text('Employee Mobile')),
                      DataColumn(label: Text('Employee Address')),
                      DataColumn(label: Text('Employee PinCode')),
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
