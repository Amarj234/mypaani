import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../servise.dart';
class venderproduct extends StatefulWidget {
  const venderproduct({Key? key}) : super(key: key);

  @override
  _venderproductState createState() => _venderproductState();
}

class _venderproductState extends State<venderproduct> {

  Serves serves=Serves();

  List<String> allmonth =[];
  int? check;
  String? billmonthf;
  String? cid;
  String? cname;
  String? cmobile;
  String? caddress;
  final jdate = TextEditingController();

  final discount = TextEditingController();
  final additional = TextEditingController();
  final Paidamt = TextEditingController();



  initState(){
    setname();
    allPerson();
    jdate.text=DateFormat('dd-MM-yyyy').format(DateTime
        .now());
  }

  setname() async {
    final uri = Uri.parse(serves.url+"singlecust1.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
    cid =prefs.getString('cid');

    var response = await http.post(uri,body: {
      'cid':cid,
    });
    var state= json.decode(response.body);
    setState((){
      cname=state[0]['name'];
      cmobile=state[0]['mobile'];
      caddress=state[0]['address'];
    });
  }
  String dropdownValue = DateFormat.yMMMM().format(DateTime
      .now());
  late List<TextEditingController> controllers;

  bool? buy;

  List<int> totals=[];


  @override
  void dispose() {
    controllers.forEach((c) => c.dispose());
    super.dispose();
  }

  OrderNow(id,name,qty,price,image ) async{
    print(qty);
    if(qty!='') {
      EasyLoading.show(status: 'loading...');
      final uri = Uri.parse(serves.url + "myorder.php");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cid1 = prefs.getString('cid');
      var vid = prefs.getString('vid');
      var eid = prefs.getString('eid');
      var response = await http.post(uri, body: {
        'cid': cid1,
        'pid': id,
        'vid': vid,
        'eid': eid,
        'qty': qty,
        'proname': name,
        'proprice': price,
        'proimg': image,
        'date': jdate.text,
      });
      if (response.statusCode == 200) {
        print('success');
        EasyLoading.showSuccess('Order Success!');
      }
    }

  }




  List<ListTile> state2=[];
  Future allPerson() async {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    state2=[];
    print(prefs.getString('vid'));
    final uri = Uri.parse(serves.url+"product.php");
    var response = await http.post(uri,body: {
      'showdata':prefs.getString('vid').toString(),

    });

    var state= json.decode(response.body);
print(state);
    controllers = List.generate(state.length, (i) => TextEditingController());


    for (int i = 0; i < state.length; i++) {

      setState(() {
        state2.add( ListTile(
          onTap: () async{
            // Navigator.push(
            //   context, MaterialPageRoute(
            //     builder: (context) => ordernow()),
            //
            // );


          },
          title: Text(state[i]['pname'].toString(),
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

                  Text("₹ - ${state[i]['pprice']}".toString(),
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
                                  (amae - 1).toString();
                            }

                           // Timer(Duration(seconds: 1), () =>  totalfun(state[i]['vpprice'],i));


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
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            // print(totals[i]);


                            if(controllers[i].text==""){
                              controllers[i].text =1.toString();

                            }else {
                              controllers[i].text =
                                  (int.parse(controllers[i].text) + 1)
                                      .toString();
                            }
                          //  Timer(Duration(seconds: 1), () =>  totalfun(state[i]['vpprice'],i));


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
SizedBox(width: 5,),
                        ElevatedButton(onPressed: (){

                          OrderNow(state[i]['id'],state[i]['pname'],controllers[i].text,state[i]['pprice'],state[i]['pimage']);



                        }, child: Text('Order'))


                      ],
                    ),
                  ),
                ],
              ),


            ],
          ),

          leading: Image.network(serves.url+state[i]['pimage'],),

        ),


        );
      });



    }


  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(child: cname==null? CircularProgressIndicator():
    SafeArea(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Color(0xff74eedc),
            // height: MediaQuery
            //     .of(context)
            //     .size
            //     .height / 4.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(

                  children: [
                    IconButton(
                      onPressed: () {},

                      icon: Icon(
                        Icons.arrow_back_ios, size: 30, color: Colors.white,),

                    ),

                    Expanded(child: Center(
                      child: Text(cname.toString(), style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 25,
                          fontFamily: 'RobotoMono'
                      ),),
                    )),

                    IconButton(
                      onPressed: () {},

                      icon: Icon(Icons.arrow_forward_ios, size: 30,
                        color: Colors.white,),

                    ),
                  ],

                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Row(

                          children: [
                            SizedBox(width: 50,),
                            Center(child: Icon(Icons.home_filled, size: 30,
                              color: Colors.blue,)),
                            SizedBox(width: 20,),
                            Expanded(
                              child: Text('Our Product', style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 23,
                                  fontFamily: 'RobotoMono'
                              ),),
                            ),
                            SizedBox(width: 20,),
                            Icon(Icons.edit, size: 30, color: Colors.blue,)
                          ],
                        ),

                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(

                          children: [
                            SizedBox(height: 50,
                              width: 40,),
                            Icon(Icons.copy_outlined, size: 25,
                              color: Colors.lightBlueAccent,),
                            SizedBox(width: 0,),
                            Text('Daily Sheet', style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                                fontSize: 25,
                                fontFamily: 'RobotoMono'
                            ),),
                            SizedBox(width: 30,),
                            IconButton(
                              onPressed: (){

                               //   getmonth();

                                _showMyDialog();




                              },
                              icon: Icon(Icons.backup_sharp, size: 25,
                                color: Colors.lightBlueAccent,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),

          ),
          SizedBox(height: 5,),

          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width/2,
              height: 35,
              child: TextField(
                onChanged: (v){
                  // allcorce();
                  print('fcgvhj');
                },
                controller: jdate, //editing controller of this TextField
                decoration: InputDecoration(

                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                    fillColor: Color(0xfff3f3f4),
                    filled: true),
                readOnly: true,  //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context, initialDate: DateTime.now(),
                      firstDate: DateTime(1950), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101)
                  );

                  if(pickedDate != null ){
                    print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                    print(formattedDate); //formatted date output using intl package =>  2021-03-16
                    //you can implement different kind of Date Format here according to your requirement

                    setState(() {
                      jdate.text = formattedDate; //set output date to TextField value.
                    });
                  //  Timer(Duration(seconds: 1), () => allcorce());

                  }else{
                    print("Date is not selected");
                  }
                },
              ),
            ),
          ),

          SizedBox(height: 5,),

          Container(
            child:Column(
              children: state2,
            ) ,
          ),


  ]
    )

    ),

    );

  }




  Future<void> main() async {
    final pdf = pw.Document();
    SharedPreferences prefs =await SharedPreferences.getInstance();



    var assetImage = pw.MemoryImage(
      (await rootBundle.load('assets/logofi1.png'))
          .buffer
          .asUint8List(),
    );


    var vname=prefs.getString('name');
    var mobile=prefs.getString('mobile');
    pdf.addPage(
      pw.Page(
          build: (pw.Context context) => pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(

                ),
                borderRadius: pw.BorderRadius.circular(10),

              ),

              height: 150,
              child: pw.Padding(
                padding: pw.EdgeInsets.all(10),
                child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                          children: [
                            pw.Text(vname.toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Text(mobile.toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Text('Name-  $cname',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Text('Mobile-  $cmobile',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Text('Address-  $caddress',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

                          ]
                      ),
                      pw.SizedBox(width: 50),
                      pw.SizedBox(width: 100,
                        child: pw.Image(assetImage),

                      ),
                      pw.Expanded(
                          child: pw.BarcodeWidget(
                            width: 100,
                            height: 100,
                            color: PdfColor.fromHex("#000000"),
                            data: cid.toString(),
                            barcode: pw.Barcode.qrCode(),
                          )
                      ),



                    ]
                ),
              )
          )
      ),
    );

    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/amar.pdf');
    await file.writeAsBytes(bytes);


    final url = file.path;

    await OpenFile.open(url);

    await file.writeAsBytes(await pdf.save());
  }




  discountAdd()async{

    SharedPreferences prefs =await SharedPreferences.getInstance();
    var vid =prefs.getString('vid');
    var cid =prefs.getString('cid');
    final uri = Uri.parse(serves.url+"myprodicount.php");

    var response = await http.post(uri,body: {
      'report':"",
      'cid':cid,
      'vid':vid.toString(),
      'date':jdate.text,
      'additional':additional.text,
      'paidamt':Paidamt.text,
      'discount':discount.text,

    });
   if(response.statusCode==200){
     billmonth();
   }

  }






  List<pw.TableRow> pdfdata2=[];
  List<pw.TableRow> pdfdata=[];

  Future<void> billmonth() async {
    final pdf = pw.Document();
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var vid =prefs.getString('vid');
    var cid =prefs.getString('cid');
    final uri = Uri.parse(serves.url+"mybilling.php");

    var response = await http.post(uri,body: {
      'report':"",
      'cid':cid,
      'vid':vid.toString(),
      'date':jdate.text,
      'check':check.toString(),

    });
    print('pdf create $cid+$vid+');
    var state= json.decode(response.body);
    print(state);
    pdfdata2=[];
    pdfdata=[];

    var  totalpaid=0;
    var  totalamount=0;
    var  totaldic=0;
    var  totaladnsl=0;
    var  totalpay=0;


    pdfdata.add(pw.TableRow( children: [

      // color: PdfColor.fromHex('0xFFf1b0ea'),

      pw.Container(
        //  color: PdfColor.fromHex('#6cffff'),
        child: pw.Column(children:[pw.Text('Item'),], ),
      ),


      pw.Container(
        // color: PdfColor.fromHex('#6cffff'),
        child: pw.Column(children:[pw.Text('Quantity'),], ),
      ),

      pw.Container(
        // color: PdfColor.fromHex('#6cffff'),
        child: pw.Column(children:[pw.Text('Unit_Cost '),], ),
      ),

      pw.Container(
        // color: PdfColor.fromHex('#6cffff'),
        child: pw.Column(children:[pw.Text('Total'),], ),
      ),


    ]),);





    for (int i = 0; i < state.length; i++) {



//      var a2= state[i.toString()]['capprice'];

//totalpaid=state[i.toString()]['paymentdone']+totalpaid;

// print(state[i.toString()]['in']+totaljarin);

      if(state[i]['totale'] !='') {
        totalamount=int.parse(state[i]['totale'])+totalamount;
      }
      if(state[i]['paidamount'] !=null) {
        totalpaid=int.parse(state[i]['paidamount'])+totalpaid;
      }

      if(state[i]['Additional'] !=null) {
        totaladnsl=int.parse(state[i]['Additional'])+totaladnsl;
      }
      if(state[i]['discount1'] !=null) {
        totaldic=int.parse(state[i]['discount1'])+totaldic;
      }
     totalpay= (totalamount+totaladnsl)-(totaldic+totalpaid);
// print(int.parse(state[i.toString()]['paymentdone'])+1);

      setState((){

pdfdata.add(pw.TableRow( children: [

  // color: PdfColor.fromHex('0xFFf1b0ea'),

  pw.Container(
  //  color: PdfColor.fromHex('#6cffff'),
    child: pw.Column(children:[pw.Text(state[i]['productname']),], ),
  ),


  pw.Container(
   // color: PdfColor.fromHex('#6cffff'),
    child: pw.Column(children:[pw.Text(state[i]['qty']),], ),
  ),

  pw.Container(
    // color: PdfColor.fromHex('#6cffff'),
    child: pw.Column(children:[pw.Text(" ${state[i]['price']}"),], ),
  ),

  pw.Container(
    // color: PdfColor.fromHex('#6cffff'),
    child: pw.Column(children:[pw.Text("  ${state[i]['totale']}"),], ),
  ),


]),);




      });


    }










    var assetImage = pw.MemoryImage(
      (await rootBundle.load('assets/logofi1.png'))
          .buffer
          .asUint8List(),
    );


    var vname=prefs.getString('name');
    var mobile=prefs.getString('mobile');
    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
          build: (pw.Context context) => [ pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(

                    ),
                    borderRadius: pw.BorderRadius.circular(10),

                  ),

                  height: 150,
                  child:
                  pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Column(
                              children: [
                                pw.Text(vname.toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 5),
                                pw.Text(mobile.toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

                              ]
                          ),
                          pw.SizedBox(width: 50),
                          pw.SizedBox(width: 100,
                            child: pw.Image(assetImage),

                          ),
                          pw.Expanded(
                              child: pw.BarcodeWidget(
                                width: 100,
                                height: 100,
                                color: PdfColor.fromHex("#000000"),
                                data: cid.toString(),
                                barcode: pw.Barcode.qrCode(),
                              )
                          ),



                        ]
                    ),
                  ),



                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(15.0),
                    child: pw.Column(children: [
                      pw.Row(
                          children: [
                            pw.Text('Name- ',style: pw.TextStyle(fontSize: 18,)),
                            pw.Text(cname.toString(),style: pw.TextStyle(fontSize: 16,)),
                            pw.SizedBox(width: 100),
                            pw.Text('Mobile- ',style: pw.TextStyle(fontSize: 18,)),
                            pw.Text(cmobile.toString(),style: pw.TextStyle(fontSize: 16,)),
                          ]
                      ),
                      pw.Row(
                          children: [
                          //  pw.Text('Bal- ',style: pw.TextStyle(fontSize: 18,)),
                            pw.Text('Name',style: pw.TextStyle(fontSize: 16,)),

                          ]
                      ),
                      pw.Row(
                          children: [
                            pw.Text('Address- ',style: pw.TextStyle(fontSize: 18,)),
                            pw.Text(caddress.toString(),style: pw.TextStyle(fontSize: 16,)),

                          ]
                      ),

                    ]),
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    borderRadius: pw.BorderRadius.circular(10),

                  ),
                ),



                pw.SizedBox(height: 20,),
                pw.SizedBox(
                  width: 400,
                  child:     pw.Row(
                      children: [

                        pw.Container(
                          // color:  PdfColor.fromHex('#00cfcf'),
                          child:       pw.Table(
                            defaultColumnWidth: pw.FixedColumnWidth(130.0),
                            border: pw.TableBorder.all(
                                color: PdfColor.fromHex('#f6d056'),
                                style: pw.BorderStyle.solid,
                                width: 1),


                            children: pdfdata,








                          ),
                        ),





                      ]
                  ),
                ),



pw.Row(
  children: [
pw.SizedBox(
  width: 260,
),
    pw.Container(
      //color:  PdfColor.fromHex('#00cfcf'),
      child:   pw.Table(
        defaultColumnWidth: pw.FixedColumnWidth(130.0),
        border: pw.TableBorder.all(
          //color: PdfColor.fromHex('#f6d056'),
            style: pw.BorderStyle.solid,
            width: 1),


        children: [

          pw.TableRow( children: [

            // color: PdfColor.fromHex('0xFFf1b0ea'),






            pw.Container(
              //  color: PdfColor.fromHex('#6cffff'),
              child: pw.Column(children:[pw.Text('Subtotal '),], ),
            ),

            pw.Container(
              //  color: PdfColor.fromHex('#6cffff'),
              child: pw.Column(children:[pw.Text(" $totalamount"),], ),
            ),


          ]),


          pw.TableRow( children: [

            // color: PdfColor.fromHex('0xFFf1b0ea'),

            pw.Container(
              //  color: PdfColor.fromHex('#6cffff'),
              child: pw.Column(children:[pw.Text('Discount '),], ),
            ),

            pw.Container(
              //  color: PdfColor.fromHex('#6cffff'),
              child: pw.Column(children:[pw.Text("- $totaldic"),], ),
            ),



          ]),


          pw.TableRow( children: [

            // color: PdfColor.fromHex('0xFFf1b0ea'),

            pw.Container(
              //  color: PdfColor.fromHex('#6cffff'),
              child: pw.Column(children:[pw.Text('Additional Charges '),], ),
            ),

            pw.Container(
              //  color: PdfColor.fromHex('#6cffff'),
              child: pw.Column(children:[pw.Text(" $totaladnsl"),], ),
            ),



          ]),

          pw.TableRow( children: [

            // color: PdfColor.fromHex('0xFFf1b0ea'),

            pw.Container(
              //  color: PdfColor.fromHex('#6cffff'),
              child: pw.Column(children:[pw.Text('Paid Amt. '),], ),
            ),

            pw.Container(
              //  color: PdfColor.fromHex('#6cffff'),
              child: pw.Column(children:[pw.Text(" - $totalpaid"),], ),
            ),



          ]),

          pw.TableRow( children: [

            // color: PdfColor.fromHex('0xFFf1b0ea'),

            pw.Container(
              //  color: PdfColor.fromHex('#6cffff'),
              child: pw.Column(children:[pw.Text('Amount To Pay '),], ),
            ),

            pw.Container(
              //  color: PdfColor.fromHex('#6cffff'),
              child: pw.Column(children:[pw.Text(" $totalpay"),], ),
            ),



          ]),


        ],
      ),
    )
  ]
)


              ]
          ),
          ]
      ),
    );

    final bytes = await pdf.save();

    String filename="amarjeet+${Random().nextInt(100)}";

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename.pdf');
    await file.writeAsBytes(bytes);


    final url = file.path;

    await OpenFile.open(url);

    await file.writeAsBytes(await pdf.save());
  }






bool isshow=false;





  Future<void> _showMyDialog() async {
    return showDialog<void>(

        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Card(
                child: AlertDialog(
                  title: Row(
                    children: [
                      const Text('Download Invoice  ',
                        style: TextStyle(fontWeight: FontWeight.w800),),

                      IconButton(onPressed: (){
                        setState((){
                          if( isshow==false) {
                            isshow = true;
                          }else{
                            isshow = false;
                          }
                        });

                      }, icon: Icon(Icons.edit,size: 25,color: Colors.greenAccent,)),
                    ],
                  ),
                  // content: SingleChildScrollView(
                  // //   child: ListBody(
                  // //     children: const <Widget>[
                  // //
                  // //     ],
                  // //   ),
                  // // ),
                  actions: <Widget>[


                    Visibility(
                      visible: isshow,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text('Additional Charges   '),

                              Container(
                                child: SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: TextFormField(
                                     controller: additional,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                                      hintText: ' Additional ',
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(color: Colors.blue)
                                      ),
                                    //  label: Text(' Discount'),

                                    ),
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),

                                  ),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),

                                ),
                              ),





                            ],
                          ),

                          SizedBox(height:5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text('Discount   '),
                              SizedBox(width:MediaQuery
                                  .of(context)
                                  .size
                                  .width/6,),
                              Container(
                                child: SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: TextFormField(
                                     controller: discount,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                                      hintText: ' Discount ',
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(color: Colors.blue)
                                      ),
                                      //   label: Text(' Discount'),

                                    ),
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),

                                  ),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),

                                ),
                              ),





                            ],
                          ),
                          SizedBox(height:5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text('Recived Amount  '),
                              SizedBox(width:MediaQuery
                                  .of(context)
                                  .size
                                  .width/15,),
                              Container(
                                child: SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: TextFormField(
                                     controller: Paidamt,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                                      hintText: ' Recived Amount ',
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(color: Colors.blue)
                                      ),
                                      //   label: Text(' Discount'),

                                    ),
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),

                                  ),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),

                                ),
                              ),





                            ],
                          ),
                          InkWell(
                            onTap: () {
                              discountAdd();
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text('Update And Create Invoice'),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10),

                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
SizedBox(height: 5,),
                    Container(
                      // height: 100,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue)
                      ),
                    ),



                    Row(
                      children: [

                        SizedBox(width:MediaQuery
                            .of(context)
                            .size
                            .width/20,),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Cencel'),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),

                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width:MediaQuery
                            .of(context)
                            .size
                            .width/12,),
                        InkWell(
                          onTap: () {
                            billmonth();
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Create Invoice'),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),

                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),


                  ],
                ),
              );
            },
          );
        }
    );
  }

}
