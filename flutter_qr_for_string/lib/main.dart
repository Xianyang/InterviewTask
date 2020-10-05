import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(InterviewTask());
}

class InterviewTask extends StatefulWidget {
  @override

  _InterviewTaskState createState() => _InterviewTaskState();

}

class _InterviewTaskState extends State<InterviewTask> {
  var qrContent = '';

  @override
  void initState() {
    // _generateNewQRCode();
    super.initState();
    WidgetsBinding.instance
      .addPostFrameCallback((_) => _generateNewQRCode());
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.qr_code)),
              ],
            ),
            title: Text('Interview Task'),
          ),
          body: TabBarView(
            children: [
              Scaffold (
                body: Center(
                  child: Text('Purposely left empty')
                )
              ),
              Scaffold (
                body: Center(child: Column(children: <Widget>[  
                  Container(  
                    margin: EdgeInsets.all(10),  
                    child: QrImage(
                      data: qrContent,
                      version: QrVersions.auto,
                      size: 300,
                      gapless: false,
                    )
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text("String in the QR code: " + qrContent),
                  ),
                  Container(  
                    margin: EdgeInsets.all(10),  
                    child: FlatButton(  
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      splashColor: Colors.grey,
                      child: Text("Generate a new QR code"),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: _generateNewQRCode,  
                    ),  
                  ),
                ])) 
              ),
            ],
          ),
        ),
      ),
    );
  }

  _generateNewQRCode() async {
    print('retrieving a new random string from server');

    var url = 'http://192.168.1.10:8080/randomString';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('new random string ' + response.body);
      setState(() {
        qrContent = response.body;
      });
    } else {
      print('fail to retrieve random string');
    }
  }
}
