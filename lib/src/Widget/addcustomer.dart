import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../servise.dart';
import 'addcustform.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dashboard.dart';


class addcustomer extends StatefulWidget {
  const addcustomer({Key? key}) : super(key: key);

  @override
  State<addcustomer> createState() => _addcustomerState();
}

class _addcustomerState extends State<addcustomer> {


  List<Contact> contactstore=[];
  List<Contact> contactlistfilter=[];
  List<Contact> contactlist=[];
  void  chooseContact() async{

    if (await Permission.contacts.request().isGranted) {
      List<Contact> contacts = await ContactsService.getContacts(withThumbnails: false,photoHighResolution: false,);
      setState(() {
        contactlist=contacts;
        contactstore=contacts;
        // showMyDialog();
        // print(contactlist);
        // Searchcontroller.addListener(() {
        //   filterContacts();
        // });
      });
    }
  }

  TextEditingController Searchcontroller=TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    chooseContact();

  }
  String flattenPhoneNumber(String phoneStr)  {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }
  filterContacts() {

    List<Contact> _contacts = [];
    _contacts.addAll(contactstore);
    if (Searchcontroller.text.isNotEmpty) {

      _contacts.retainWhere((contact) {

        String searchTerm = Searchcontroller.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.displayName!.toLowerCase();



        bool nameMatches = contactName.contains(searchTerm);
        print(nameMatches);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.phones!.firstWhere((phn) {

          String phnFlattened = flattenPhoneNumber(phn.value!);
          return phnFlattened.contains(searchTermFlatten);
        }, );

        return phone != null;
      });
      setState(() {
        contactlist=[];
        contactlist = _contacts;
        // showMyDialog();
        print(contactlist);
      });
    }
  }

  Serves serves=Serves();


  void addcustomer(name,mobile) async{


    SharedPreferences prefs =await SharedPreferences.getInstance();
    var vid= prefs.getString('vid');
    var url2 = Uri.parse(serves.url+"savecontact.php");
    var response = await http.post(url2, body: {
      'mobile': mobile,
      'name':name,
      'vid': vid ,
    });
    print(vid);
    if (response.statusCode == 200) {
      Navigator.push(
         context,MaterialPageRoute(builder: (context)=> dashboard()),
      );
      var check =jsonDecode(response.body);

      if(check==1) {

      }
      }

  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ''
        ),
      ),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              Navigator.push(
                context,MaterialPageRoute(builder: (context)=> addcostform()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white70,
                child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    Icon(Icons.add_circle,size: 30,color: Colors.blueAccent,),

                    SizedBox(width: 10,),
                    Text('Add New Customer',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.blueAccent),),
                    SizedBox( width:MediaQuery.of(context).size.width/7),
                    Icon(Icons.arrow_forward_ios,size: 30,color: Colors.blueAccent,),

                  ],
                ),
              ),),
            ),
          ),

          Container(
            height: 30,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text('Select Customers',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.blueAccent)),
              )),



          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: TextField(
                controller: Searchcontroller,
                onChanged: (value) {
                  setState(() {
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),

                ),
              ),
            ),
          ),
SizedBox(
  height: MediaQuery.of(context).size.height/2,
  child:   ListView.builder(

    shrinkWrap: true,

    itemCount: contactlist.length,

    itemBuilder: (_,index){

      Contact contact=contactlist[index];

      return    InkWell(

        onTap: (){




          addcustomer(contact.displayName.toString(),contact.phones!.elementAt(0).value.toString());


        },

        child: ListTile(

          title:contact.displayName==null? Text(''):  Text(contact.displayName.toString()),

           subtitle:contact.phones!.elementAt(0).value ==null ? Text(''): Text(contact.phones!.elementAt(0).value.toString()),

          leading: CircleAvatar(

              child: Icon(Icons.contact_phone_rounded,size: 50,color: Colors.blueAccent,),

              backgroundColor: Colors.transparent),



        ),

      ) ;



    },

  ),
)
        ],
      ),
    );
  }
}
