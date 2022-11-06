import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../servise.dart';
import '../ordernow.dart';

class productlist extends StatefulWidget {
  const productlist({Key? key, }) : super(key: key);


  @override
  State<productlist> createState() => _productlistState();
}

class _productlistState extends State<productlist> {
  late List<TextEditingController> controllers;

  bool? buy;

  List<int> totals=[];


  @override
  void dispose() {
    controllers.forEach((c) => c.dispose());
    super.dispose();
  }

  int cartcount=0;

  getcart() async{

    final uri = Uri.parse(serves.url+"addtocart.php");
    var response = await http.post(uri,body: {
      'showdata':"",

    });

    var state= json.decode(response.body);

    setState((){
      cartcount=state.length;


    });

  }




  void totalfun(price,i){
    setState((){
      totals[i]= int.parse( controllers[i].text)*int.parse(price);

    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    getcart();
    Timer(Duration(seconds: 1), () => allPerson());

  }


  addtocart(id,pname,price,qty,total,image,vid) async{


    SharedPreferences prefs =await SharedPreferences.getInstance();
    EasyLoading.show(status: 'loading...');
    final uri = Uri.parse(serves.url+"addtocart.php");
    var request = http.MultipartRequest('POST',uri);
    request.fields['pid'] =  id.toString();
    request.fields['price']= price;
    request.fields['pname']= pname;
    request.fields['qty'] = qty;
    request.fields['image'] = image;
    request.fields['total'] = total.toString();
    request.fields['cid'] = prefs.getString('vid').toString();




    var response = await request.send();
    var response1 = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      print('Image Uploded ${response1.body}');


if(buy==true){
  Navigator.push(
    context, MaterialPageRoute(
      builder: (context) => ordernow()),
  );
}else{
  EasyLoading.showSuccess('Add Success!');
}



      EasyLoading.dismiss();

      // Navigator.pop(context, 'OK');
    }else{
      EasyLoading.showError('Failed with Error');
    }




  }



  List<ListTile> state2=[];
  Serves serves=Serves();

  Future allPerson() async {

    state2=[];
    final uri = Uri.parse(serves.url+"showproduct1.php");
    var response = await http.post(uri,body: {
      'showdata':'',

    });

    var state= json.decode(response.body);

    controllers = List.generate(state.length, (i) => TextEditingController());


      for (int i = 0; i < state.length; i++) {
        totals.add(0);
        setState(() {
        state2.add( ListTile(
          onTap: () async{
            // Navigator.push(
            //   context, MaterialPageRoute(
            //     builder: (context) => ordernow()),
            //
            // );


          },
          title: Text(state[i]['vpname'].toString(),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'RobotoMono'
            ),),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Row(
                children: [

                  Text("₹ - ${state[i]['vpprice']}".toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w200,
                        fontSize: 15
                    ),),
                  // Text("Total - ${totals[i]}".toString(),
                  //   overflow: TextOverflow.ellipsis,
                  //   maxLines: 1,
                  //   style: TextStyle(
                  //       color: Colors.black87,
                  //       fontWeight: FontWeight.w200,
                  //       fontSize: 15
                  //   ),),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5),
                    child: Row(
                      children: [


                        SizedBox(width: MediaQuery
                            .of(context)
                            .size
                            .width / 8.5),
                        InkWell(
                          onTap: () {

                              if (controllers[i].text != "0") {
                                int amae = int.parse(
                                    controllers[i].text);
                                controllers[i].text =
                                    (amae - int.parse(state[i]['minqty'])).toString();
                              }

                              Timer(Duration(seconds: 1), () =>  totalfun(state[i]['vpprice'],i));


                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xff5abbad),
                                borderRadius: BorderRadius.only(

                                    topLeft: Radius.circular(
                                        10.0),
                                    bottomLeft: Radius.circular(
                                        10.0)),

                              ),
                              height: 40,
                              width: 30,

                              child: Icon(
                                Icons.remove, color: Colors.white,
                                size: 22,)),
                        ),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xff5abbad))
                            ),
                            child: TextFormField(
// initialValue: '0',
                              controller: controllers[i],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: '0',

                              ),


                            ),
                          )
                          ,),

                        InkWell(
                          onTap: () {
                           // print(totals[i]);


                              if(controllers[i].text==""){
                                controllers[i].text =int.parse(state[i]['minqty']).toString();

                              }else {
                                controllers[i].text =
                                    (int.parse(controllers[i].text) + int.parse(state[i]['minqty']))
                                        .toString();
                              }
                            Timer(Duration(seconds: 1), () =>  totalfun(state[i]['vpprice'],i));


                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xff5abbad),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  bottomRight: Radius.circular(
                                      10.0),
                                ),
                              ),
                              height: 40,
                              width: 30,

                              child: Icon(
                                Icons.add, color: Colors.white,
                                size: 22,)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1,),
              Row(
                children: [
                  InkWell(

                    onTap: (){
                      buy=false;
                      if(controllers[i].text != "") {

                        addtocart(
                            state[i]['vpid'],
                            state[i]['vpname'],
                            state[i]['vpprice'],
                            controllers[i].text,
                            totals[i],
                            state[i]['vpimage'],
                            state[i]['vpid']);
                        Timer(Duration(seconds: 1), () => getcart());

                      }else{
                        EasyLoading.showToast('Please Order min 1 Qty');

                      }

                      },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Add to cart'),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),

                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      buy=true;
                      if(controllers[i].text !="") {
                        addtocart(
                            state[i]['vpid'],
                            state[i]['vpname'],
                            state[i]['vpprice'],
                            controllers[i].text,
                            totals[i],
                            state[i]['vpimage'],
                            state[i]['vpid']);
                        Timer(Duration(seconds: 1), () => getcart());
                      }else{
                        EasyLoading.showToast('Please Order min 1 Qty');
                        //EasyLoading.dismiss();
                      }


                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Order Now',style: TextStyle(color: Colors.white),),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xff5dd9c6),
                        ),
                      ),
                    ),
                  )

                ],
              ),

            ],
          ),

          leading: Image.network(serves.url+state[i]['vpimage'],),

        ),


        );
        });



      }


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product'),
        actions: [ InkWell(
          onTap: (){
            Navigator.push(
              context, MaterialPageRoute(
                builder: (context) => ordernow()),
            );
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: Badge(
                  badgeContent: Text(cartcount.toString()),
                  child:  Icon(Icons.shopping_cart),


                ),
              ),
            ),
          ),
        ) ],
      ),
      body:state2.length==0?Center(child: CircularProgressIndicator()): ListView(
        children: state2
    ),
    );
  }
}
