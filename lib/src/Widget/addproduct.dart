import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../servise.dart';
class addproduct extends StatefulWidget {
  const addproduct({Key? key}) : super(key: key);

  @override
  State<addproduct> createState() => _addproductState();
}

class _addproductState extends State<addproduct> {


  String uid ='0';
  String button ='Save';

  final corcename=TextEditingController();
  final discription=TextEditingController();
  final corceprice=TextEditingController();



  void initState() {
    super.initState();
    allPerson();
  }

  bool imageshow=false;

  Savedata() async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    EasyLoading.show(status: 'loading...');
    final uri = Uri.parse(serves.url+"addproduct.php");
    var request = http.MultipartRequest('POST',uri);
    request.fields['corcename'] =  corcename.text;
    request.fields['discription']= discription.text;
    request.fields['corceprice'] = corceprice.text;
    request.fields['vid'] = prefs.getString('vid').toString();

    request.fields['uid'] = uid.toString();

    var videos = await http.MultipartFile.fromPath("video", image!.path);
    request.files.add(videos);

    var response = await request.send();
    var response1 = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      print('Image Uploded ${response1.body}');
      EasyLoading.showSuccess('Great Success!');

      corcename.text="";
      discription.text="";
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

    state2=[];
    final uri = Uri.parse(serves.url+"addproduct.php");
    var response = await http.post(uri,body: {
      'showdata':"",

    });

    var state= json.decode(response.body);
    setState(() {
      state.forEach((item) {
        state2.add( DataRow(

            cells: [

              DataCell(Text(item['id'])),
              DataCell(Text(item['pname'])),
              DataCell(Text(item['discription'])),
              DataCell(Text(item['pprice'])),
              DataCell(
                  IconButton(
                    icon: Icon(Icons.create,color: Colors.green,), onPressed: () {
                    Update(item['id'],item['pname'],item['discription'],item['pprice']);
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
  void Update(upid,value,did,price){
    print(upid);
    setState(() {
      button="Update";
      discription.text=did.toString();
      corcename.text=value.toString();
      corceprice.text=price.toString();

      uid=upid;
    });

  }



  File? image;


  final picker = ImagePicker();
  Future choiceImage() async{
    var pickedImage = await picker.pickImage(
      source: ImageSource.gallery,

    );
    setState(() {
      image = File(pickedImage!.path);
      print(image);
    });
    imageshow=true;
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
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(

                  child: TextFormField(

                    style: TextStyle(color: Colors.black,fontSize: 20,),
                    textAlign: TextAlign.start,
                    controller: corcename,
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
                      labelText: 'Product Name',
                      hoverColor: Colors.black12,
                      hintText: 'Product Name',

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
                    controller: discription,
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
                      labelText: 'Discription',
                      hoverColor: Colors.black12,
                      hintText: 'Discription',

                    ),
                    maxLines: 3,
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
                      labelText: 'Product Price',
                      hoverColor: Colors.black12,
                      hintText: 'Product Price',

                    ),
                    maxLines: 1,
                  ),
                ),
              ),


              SizedBox(
                height: 20,
              ),

              imageshow ? Image.file(image!,width: 100,height: 100,) :Container(),

              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: InkWell(
                  onTap: (){
                    choiceImage();

                  },
                  child: Container(

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
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
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    width:   200,
                    height:  50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.video_call_outlined,size: 30,color: Colors.blue,),
                          const Text('Choose Image',style: const TextStyle(fontSize: 20),),
                        ],
                      ),
                    ),
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
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Discription')),
                      DataColumn(label: Text('Price')),
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
