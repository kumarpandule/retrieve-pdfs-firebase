import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/ShowDataPage.dart';

void main() => runApp(new MaterialApp(home: new MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete((){
      print('Connected to firebase.');
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color.fromRGBO(111, 194, 173, 1.0),
      title: Text(
          'Pdfs'
      ),
    ),
    body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('path').snapshots(),
          builder: (context, snapshot){
            if(snapshot.hasError){
              return Center(child:  Text('Error: ${snapshot.error}'),);
            }
            else{
              switch(snapshot.connectionState){
                case(ConnectionState.waiting):{
                  return Center(child: CircularProgressIndicator(),);
                }
                default: return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index){
                    DocumentSnapshot data = snapshot.data.docs[index];
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          String passData = data['url'].toString();
                          print(passData);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewPdf(),
                                  settings: RouteSettings(
                                    arguments: passData,
                                  )));
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(7.0),
                          elevation: 5.0,
                          child: Container(
                            height: 100.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Colors.white10),
                            child: Row(
                              children: <Widget>[
                                // SizedBox(width: 10.0),
                                Container(
                                  height: 80.0,
                                  width: 90.0,
                                SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 30.0),
                                    Container(
                                      width: 200,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        data['title'],
                                        textAlign: TextAlign.justify,
                                        // textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                            fontFamily: 'Comfortaa',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    SizedBox(height: 7.0),
                                    Text(
                                      data['subject'],
                                      style: TextStyle(
                                          fontFamily: 'Comfortaa',
                                          color: Colors.redAccent,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(height: 7.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                );
              }
            }
          }
    ),
  );
  }
}

class ViewPdf extends StatelessWidget {
  // PDFDocument doc;

  @override
  Widget build(BuildContext context) {
    String data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(111, 194, 173, 1.0),
        title: Text("PDFs"),
      ),
      body: data != null ? SfPdfViewer.network(data) : CircularProgressIndicator(),
    );
  }
}