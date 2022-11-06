import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../servise.dart';
import 'screens/productlist.dart';

class venderdetaills extends StatefulWidget {
  const venderdetaills({Key? key, required this.vid}) : super(key: key);
final String vid;
  @override
  _venderdetaillsState createState() => _venderdetaillsState();
}

class _venderdetaillsState extends State<venderdetaills> {



  void initState() {
    // TODO: implement initState
    super.initState();


    Timer(Duration(seconds: 1), () => allPerson());

  }

  _callNumber(number) async{

    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  String? vendername;
  String? Location;
var number;

  Serves serves=Serves();
  List<InkWell> state2=[];
  Future allPerson() async {

    state2=[];

    final uri = Uri.parse(serves.url+"singlevender.php");
    var response = await http.post(uri,body: {
      'showdata':widget.vid.toString(),

    });
    print((response.body));
    var state= json.decode(response.body);
setState(() {
  vendername=state[0]['name'];
  Location=state[0]['location'];
  number=state[0]['mobile'];
});



  }









  @override
  Widget build(BuildContext context) {
    return vendername==null?Center(child: CircularProgressIndicator()):  Scaffold(
      appBar: AppBar(
        title: Text(vendername.toString()),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: CarouselSlider(
                items: [

                  //1st Image of Slider
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage("assets/logofi.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //2nd Image of Slider
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage("assets/logofi.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //3rd Image of Slider
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage("assets/logofi.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //4th Image of Slider
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage("assets/logofi.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //5th Image of Slider
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage("assets/logofi.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                ],

                //Slider Container properties
                options: CarouselOptions(
                  height: 180.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
              ),
            ),

Card(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(vendername.toString(),style: TextStyle(color: Colors.lightBlueAccent,fontSize: 25,fontWeight: FontWeight.w600),),
        ),
        Row(
         children: [
           Icon(Icons.lock_clock,color: Colors.red,),
           SizedBox(width: 5,),
           Text('08:00 AM -08:00 PM',style: TextStyle(color: Colors.green),),
         ],
        ),

        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          color: Color(0xff99efe6),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Water Distributor Details',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
          ),

        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.delivery_dining_sharp,size: 30,),
              SizedBox(width: 5,),
              Text('Delivery Charges ₹10',style: TextStyle(fontSize: 15),),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.delivery_dining_sharp,size: 30,),
              SizedBox(width: 5,),
              Text('Delivery Charges For Subscription Free',style: TextStyle(fontSize: 15,color: Colors.green),),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.location_on,size: 30,),
              SizedBox(width: 5,),
              Text(Location.toString(),style: TextStyle(fontSize: 18,),),
            ],
          ),
        ),



        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.perm_contact_calendar,size: 30,),
              SizedBox(width: 5,),
              Text(number.toString(),style: TextStyle(fontSize: 18,),),
              SizedBox(width: 10,),
              ElevatedButton(onPressed: (){
                _callNumber(number);

              }, child: Row(
                children: [
                  Icon(Icons.call),
                  Text('Call')
                ],
              ))
            ],
          ),
        ),


    ],
  ),
),
SizedBox(height: 10,),
            Container(
               width: MediaQuery.of(context).size.width,
              height: 50,
              color: Color(0xff99efe6),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Reviews And Ratings',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
              ),

            ),

            SizedBox(

              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      RatingBar.builder(
                      initialRating: 3,
    minRating: 1,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemCount: 5,
    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
    itemBuilder: (context, _) => Icon(
    Icons.star,
    color: Colors.amber,size: 15,
    ),
    onRatingUpdate: (rating) {
    print(rating);
    },
    ),
SizedBox(width: MediaQuery.of(context).size.width/20,),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                            textStyle: MaterialStateProperty.all(TextStyle(fontSize: 15))),
                        onPressed: (){}, child: Text('FeedBack'),

                      )
                    ],
                  ),
                ),
              ),
            )

          ],
        ),
      ),
        bottomNavigationBar: BottomAppBar(

          color:Color(0xfff1f1f1),
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
              ElevatedButton(onPressed: (){
                // Navigator.push(
                //   context, MaterialPageRoute(
                //     builder: (context) => productlist(vid:widget.vid)),
                // );

              }, child: Text('Place Order')),
                    SizedBox(width: MediaQuery.of(context).size.width/15,),
                    ElevatedButton(onPressed: (){}, child: Text('Offers')),
Image.asset('assets/subs.png',width: MediaQuery.of(context).size.width/2.8,height: 70,)
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
