import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';


class searchplace extends StatefulWidget {
  const searchplace({Key? key}) : super(key: key);

  @override
  State<searchplace> createState() => _searchplaceState();
}

class _searchplaceState extends State<searchplace> {

  @override
  void initState() {
    String apiKey = 'AIzaSyDJGjsl0pDzx1q7_OWN49VWIXFDBAt0DaY';
   googlePlace = GooglePlace(apiKey);
    super.initState();
  }
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  final serch = TextEditingController();

serchlocation()async {
  var result = await googlePlace.autocomplete.get(serch.text);
  print(result?.predictions!.length);
  if (result != null && result.predictions != null && mounted) {
    setState(() {
      predictions = result.predictions!;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            TextFormField(
              controller: serch,
              onChanged: (val){
                serchlocation();
              },
            ),

            Expanded(
              child: ListView.builder(
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(predictions[index].description!),
                    onTap: () {
                      // debugPrint(predictions[index].placeId);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DetailsPage(
                      //       placeId: predictions[index].placeId,
                      //       googlePlace: googlePlace,
                      //     ),
                      //   ),
                      // );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
