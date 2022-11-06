import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/Setting.dart';
import 'screens/daliyapp.dart';
import 'screens/profileupdae.dart';
import 'screens/vendeproduct.dart';

class Singlecustomer extends StatefulWidget {
   Singlecustomer({Key? key,required this.name,required this.cid}) : super(key: key);

   final String cid ;
   final String name ;



   @override
  State<Singlecustomer> createState() => _SinglecustomerState();
}

class _SinglecustomerState extends State<Singlecustomer> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 1), () =>print(widget.name));
name1=widget.name;
cid1=widget.cid;

  }
  String? name1;
  String? cid1;

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [dailyapp(), venderproduct(), Setting(),profileupdate()];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff5abbad),
        title: Text('Customer information'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black12,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_sharp),
            label: ('Daily Sheet'),
            //backgroundColor: Color(0xffffaa00),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: ('Our Product'),
           // backgroundColor: Color(0xff6548ec),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.clean_hands_outlined),
         //   backgroundColor: Color(0xffecbd02),
            label: 'Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts_rounded),
            label: 'Profile',
           // backgroundColor: Color(0xff16fc2d),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:  Color(0xff62d3d5),

        onTap: _onItemTapped,
      ),

    );
  }



}
