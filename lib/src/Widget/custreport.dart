import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../servise.dart';

class custreport extends StatefulWidget {
  const custreport({Key? key}) : super(key: key);

  @override
  _custreportState createState() => _custreportState();
}

class _custreportState extends State<custreport> {

  Serves serves=Serves();
  String dropdownValue = DateFormat.yMMMM().format(DateTime
      .now());
  String? billmonthf;
  int? check;
  String? cid;
  String? vname;
  String? vmobile;
  String? vaddress;

  setname() async {
    final uri = Uri.parse(serves.url+"custvender.php");
    SharedPreferences prefs =await SharedPreferences.getInstance();
    cid =prefs.getString('cid');


    var response = await http.post(uri,body: {
      'cid':cid,
    });
    var state= json.decode(response.body);
    setState((){
      vname=state[0]['name'];
      vmobile=state[0]['mobile'];
      vaddress=state[0]['location'];
    });

  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getmonth();
    setname();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('See Your Report'),
      ),
      body: SafeArea(child: Column(
        children: [
SizedBox(height: 20),
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

                          //  getmonth();




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
      )),
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


    var cname=prefs.getString('name');
    var cmobile=prefs.getString('mobile');
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
                            pw.Text(vmobile.toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Text('Name-  $cname',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Text('Mobile-  $cmobile',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Text('Address-  $vaddress',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

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


  List<pw.TableRow> pdfdata2=[];
  List<pw.TableRow> pdfdata=[];

  Future<void> billmonth() async {
    final pdf = pw.Document();
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var cid1 =prefs.getString('cid');

    final uri = Uri.parse(serves.url+"custreport.php");

    var response = await http.post(uri,body: {
      'report':"",
      'cid':cid1,

      'billmonthf':billmonthf.toString(),
      'check':check.toString(),

    });
    print('pdf create $cid');
    var state= json.decode(response.body);
    pdfdata2=[];
    pdfdata=[];
    pdfdata.add(

      pw.TableRow( children: [

        // color: PdfColor.fromHex('0xFFf1b0ea'),

        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Date'),], ),
        ),


        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('In'),], ),
        ),

        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Out'),], ),
        ),

        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Bal'),], ),
        ),

        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Paid A.'),], ),
        ),




      ]),



    );


    pdfdata2.add(

      pw.TableRow( children: [

        // color: PdfColor.fromHex('0xFFf1b0ea'),

        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Date'),], ),
        ),


        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('In'),], ),
        ),

        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Out'),], ),
        ),

        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Bal'),], ),
        ),

        pw.Container(
          color: PdfColor.fromHex('#6cffff'),
          child: pw.Column(children:[pw.Text('Paid A.'),], ),
        ),




      ]),



    );



    var  totalpaid=0;
    var  totalamount=0;
    var  totaljarin=0;


    for (int i = 1; i < state.length+1; i++) {



//      var a2= state[i.toString()]['capprice'];

//totalpaid=state[i.toString()]['paymentdone']+totalpaid;

// print(state[i.toString()]['in']+totaljarin);
      if(state[i.toString()]['in'] !='') {
        totaljarin=state[i.toString()]['in']+totaljarin;
      }
      if(state[i.toString()]['capprice'] !='') {
        totalamount=state[i.toString()]['capprice']+totalamount;
      }
      if(state[i.toString()]['paymentdone'] !='') {
        totalpaid=int.parse(state[i.toString()]['paymentdone'])+totalpaid;
      }
// print(int.parse(state[i.toString()]['paymentdone'])+1);

      setState((){



        if(i<17) {
          pdfdata.add(

            pw.TableRow(children: [

              // color: PdfColor.fromHex('0xFFf1b0ea'),

              pw.Container(
                // color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children: [
                  pw.Text(state[i.toString()]['onelydate'].toString()),
                ],),
              ),


              pw.Container(
                // color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(
                  children: [pw.Text(state[i.toString()]['in'].toString()),],),
              ),

              pw.Container(
                //  color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(
                  children: [pw.Text(state[i.toString()]['out'].toString()),],),
              ),

              pw.Container(
                //color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children: [
                  pw.Text(state[i.toString()]['capprice'].toString()),
                ],),
              ),

              pw.Container(
                // color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children: [pw.Text(state[i.toString()]['paymentdone'].toString()),],),
              ),


            ]),


          );
        }else{

          pdfdata2.add(

            pw.TableRow( children: [

              // color: PdfColor.fromHex('0xFFf1b0ea'),

              pw.Container(
                // color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children:[pw.Text(state[i.toString()]['onelydate'].toString()),], ),
              ),


              pw.Container(
                // color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children:[pw.Text(state[i.toString()]['in'].toString()),], ),
              ),

              pw.Container(
                //  color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children:[pw.Text(state[i.toString()]['out'].toString()),], ),
              ),

              pw.Container(
                //color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children:[pw.Text(state[i.toString()]['capprice'].toString()),], ),
              ),

              pw.Container(
                // color: PdfColor.fromHex('#6cffff'),
                child: pw.Column(children:[pw.Text(state[i.toString()]['paymentdone'].toString()),], ),
              ),




            ]),



          );



        }



      });


    }










    var assetImage = pw.MemoryImage(
      (await rootBundle.load('assets/logofi1.png'))
          .buffer
          .asUint8List(),
    );


    var cname=prefs.getString('name');
    var cmobile=prefs.getString('mobile');
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
                                pw.Text(cmobile.toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

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
                            pw.Text(vname.toString(),style: pw.TextStyle(fontSize: 16,)),
                            pw.SizedBox(width: 100),
                            pw.Text('Mobile- ',style: pw.TextStyle(fontSize: 18,)),
                            pw.Text(vmobile.toString(),style: pw.TextStyle(fontSize: 16,)),
                          ]
                      ),
                      pw.Row(
                          children: [
                            pw.Text('Bal- ',style: pw.TextStyle(fontSize: 18,)),
                            pw.Text('Name',style: pw.TextStyle(fontSize: 16,)),

                          ]
                      ),
                      pw.Row(
                          children: [
                            pw.Text('Address- ',style: pw.TextStyle(fontSize: 18,)),
                            pw.Text(vaddress.toString(),style: pw.TextStyle(fontSize: 16,)),

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
                            defaultColumnWidth: pw.FixedColumnWidth(45.0),
                            border: pw.TableBorder.all(
                                color: PdfColor.fromHex('#f6d056'),
                                style: pw.BorderStyle.solid,
                                width: 1),


                            children: pdfdata,








                          ),
                        ),



                        pw.SizedBox(
                            width: 20
                        ),
                        pw.Container(
                          //color:  PdfColor.fromHex('#00cfcf'),
                          child:   pw.Table(
                            defaultColumnWidth: pw.FixedColumnWidth(45.0),
                            border: pw.TableBorder.all(
                                color: PdfColor.fromHex('#f6d056'),
                                style: pw.BorderStyle.solid,
                                width: 1),


                            children: pdfdata2,
                          ),
                        )

                      ]
                  ),
                ),


                pw.SizedBox(
                    height: 20
                ),

                pw.Container(
                  //color:  PdfColor.fromHex('#00cfcf'),
                  child:   pw.Table(
                    defaultColumnWidth: pw.FixedColumnWidth(45.0),
                    border: pw.TableBorder.all(
                        color: PdfColor.fromHex('#f6d056'),
                        style: pw.BorderStyle.solid,
                        width: 1),


                    children: [

                      pw.TableRow( children: [

                        // color: PdfColor.fromHex('0xFFf1b0ea'),




                        pw.Container(
                          color: PdfColor.fromHex('#6cffff'),
                          child: pw.Column(children:[pw.Text('Total Delivered'),], ),
                        ),



                        pw.Container(
                          color: PdfColor.fromHex('#6cffff'),
                          child: pw.Column(children:[pw.Text('Amount'),], ),
                        ),

                        pw.Container(
                          color: PdfColor.fromHex('#6cffff'),
                          child: pw.Column(children:[pw.Text('Received '),], ),
                        ),
                        pw.Container(
                          color: PdfColor.fromHex('#6cffff'),
                          child: pw.Column(children:[pw.Text('Balance'),], ),
                        ),
                      ]),


                      pw.TableRow( children: [

                        // color: PdfColor.fromHex('0xFFf1b0ea'),

                        pw.Container(

                          child: pw.Column(children:[pw.Text(totaljarin.toString()),], ),
                        ),


                        pw.Container(

                          child: pw.Column(children:[pw.Text(totalamount.toString()),], ),
                        ),

                        pw.Container(

                          child: pw.Column(children:[pw.Text(totalpaid.toString()),], ),
                        ),

                        pw.Container(

                          child: pw.Column(children:[pw.Text((totalamount-totalpaid).toString()),], ),
                        ),

                      ]),




                    ],
                  ),
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





  List<String> allmonth =[];

  getmonth(){
    for(int i=0;i<12;i++) {
      DateTime firstDayCurrentMonth = DateTime.utc(DateTime
          .now()
          .year, DateTime
          .now()
          .month - i,);
      var hosre = DateFormat.yMMMM().format(firstDayCurrentMonth);
      allmonth.add(hosre);
    }
    print(allmonth);
  }







  Future<void> _showMyDialog() async {
    return showDialog<void>(

      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Card(
          child: AlertDialog(
            title: const Text('Download Empty Sheet',style: TextStyle(fontWeight: FontWeight.w800),),
            // content: SingleChildScrollView(
            // //   child: ListBody(
            // //     children: const <Widget>[
            // //
            // //     ],
            // //   ),
            // // ),
            actions: <Widget>[



              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  InkWell(
                    onTap: (){
                      main();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Qr Code'),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),

                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      billmonth();
                      check=1;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Full Dailt Sheet'),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),

                        ),
                      ),
                    ),
                  ),


                ],
              ),

              Container(
                // height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue)
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Download Filled Sheet',style: TextStyle(fontWeight: FontWeight.w800),),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                    child: DropdownButton<String>(
                      underline: SizedBox(),
                      value: dropdownValue,
                      icon: const Icon(
                        Icons.arrow_drop_down, size: 30, color: Colors.blue,),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),

                      onChanged: (String? newValue) {
                        // dropdownValue=newValue;
                        print(newValue);
                        setState(() {

                          billmonthf=newValue;
                        });
                      },
                      items: allmonth
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),

                    ),
                  ),
                  InkWell(
                    onTap: (){
                      billmonth();
                      check=2;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(width:100,child: Text('Filled Entry Sheet',maxLines: 2,)),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),

                        ),
                      ),
                    ),
                  ),


                ],
              ),
              SizedBox(height: 50,),

              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
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

              SizedBox(height: 20,),



            ],
          ),
        );
      },
    );
  }



}
