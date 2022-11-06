import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../servise.dart';


class chatscreen extends StatefulWidget {
  @override
  _chatscreenState createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {

  TextEditingController _inputMessageController = new TextEditingController();

  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  void initState() {
    super.initState();
    allPerson();
    Future.delayed(Duration.zero, () async {

    });
  }

final Message =TextEditingController();


  bool imageshow=false;

  Savedata() async{

    SharedPreferences prefs =await SharedPreferences.getInstance();

    final uri = Uri.parse(serves.url+"chatapp.php");
    var request = http.MultipartRequest('POST',uri);

    request.fields['message'] = Message.text;
    request.fields['vid'] = prefs.getString('vid').toString();
    request.fields['name'] = prefs.getString('name').toString();



    var response = await request.send();
    var response1 = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      print('Image Uploded ${response1.body}');
      EasyLoading.showSuccess('Great Success!');



      Message.text="";
      allPerson();
      setState(() {

      });


      // Navigator.pop(context, 'OK');
    }else{
      EasyLoading.showError('Failed with Error');
    }
  }



  List<Container> state2=[];
  Serves serves=Serves();

  Future allPerson() async {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    state2=[];
    final uri = Uri.parse(serves.url+"chatapp.php");
    var response = await http.post(uri,body: {
      'showdata':prefs.getString('vid'),

    });

    var state= json.decode(response.body);
    setState(() {
      state.forEach((item) {
        state2.add(
            Container(
              padding: EdgeInsets.only(
                  left: 14, right: 14, top: 10, bottom: 10),
              child: Align(
                alignment: (item['outgoingid']==prefs.getString('vid')
                    ? Alignment.topRight
                    : Alignment.topLeft),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (item['outgoingid']==prefs.getString('vid')
                        ? Colors.grey.shade200
                        : Colors.blue[200]),
                  ),
                  padding: EdgeInsets.all( item['outgoingid']==prefs.getString('vid') ? 16:10 ),
                  child:item['outgoingid']==prefs.getString('vid') ? Text(
                    item['massege'].toString(),
                    style: TextStyle(fontSize: 15),
                  ): Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       item['name'].toString(),
                       style: TextStyle(fontSize: 12,color: Colors.red),
                     ),
                     Text(
                       item['massege'].toString(),
                       style: TextStyle(fontSize: 15),
                     )
                   ],
                  ),
                ),
              ),
            )

        );
      }
      );
    });
  }







  @override
  Widget build(BuildContext context) {
    _scrollToBottom();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Amarjeet kushwaha",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            chatSpaceWidget(),
            Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.blueGrey,
            ),
            bottomChatView()
          ],
        ),
      ),
    );
  }

  Widget chatSpaceWidget() {
    return Flexible(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: state2,
        ),
      ),
    );
  }

  Widget bottomChatView() {
    return Container(
      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
      height: 60,
      width: double.infinity,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              controller: Message,
              onSubmitted: (String str) {
                Savedata();
              },
              decoration: InputDecoration(
                  hintText: "Write message...",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: () {
              Savedata();
            },
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 18,
            ),
            backgroundColor: Colors.blue,
            elevation: 0,
          ),
        ],
      ),
    );
  }

  _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }


}
