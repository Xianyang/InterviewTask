import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    new CupertinoApp(
      home: new HomeScreen(),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    ),
  );
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            title: Text('QR Code'),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        if (index == 0) {
          return CupertinoTabView(
            navigatorKey: firstTabNavKey,
            builder: (BuildContext context) => FirstTab(),
          );
        } else if (index == 1) {
          return CupertinoTabView(
            navigatorKey: secondTabNavKey,
            builder: (BuildContext context) => SecondTab(),
          );
        }
      },
    );
  }
}

class FirstTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyTopBar(
        text: "Home",
        uniqueHeroTag: 'tab1',
        child: Scaffold(body: Center(child: Text('Purposely left empty'))));
  }
}

class SecondTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyTopBar(
      text: "QR Code",
      uniqueHeroTag: 'tab1',
      child: QRCodeView(),
    );
  }
}

class QRCodeView extends StatefulWidget {
  @override
  _QRCodeViewState createState() => _QRCodeViewState();
}

class _QRCodeViewState extends State<QRCodeView> {
  var qrContent = '';
  final httpClient = HttpClient();

  @override
  void initState() {
    // _generateNewQRCode();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _generateNewQRCode());
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: <Widget>[
      Container(
          margin: EdgeInsets.only(top: 100),
          child: QrImage(
            data: qrContent,
            version: QrVersions.auto,
            size: 300,
            gapless: false,
          )),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: _generateNewQRCode,
        ),
      ),
    ])));
  }

  _generateNewQRCode() async {
    String content = await httpClient.fetchRandomString();

    setState(() {
      qrContent = content;
    });
  }
}

class MyTopBar extends StatelessWidget {
  final String text;

  final TextStyle style;
  final String uniqueHeroTag;
  final Widget child;

  MyTopBar({
    this.text,
    this.style,
    this.uniqueHeroTag,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: uniqueHeroTag,
        transitionBetweenRoutes: false,
        middle: Text(
          text,
          style: style,
        ),
      ),
      child: child,
    );
  }
}

class HttpClient {
  Future<String> fetchRandomString() async {
    print('fetching a new random string from server');

    var url = 'http://192.168.1.10:8080/randomString';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('new random string ' + response.body);
      return response.body;
    } else {
      print('fail to retrieve random string');
      throw Exception(
          'Fail to fetch random string from server, please check you connection');
    }
  }
}

class Counter {
  int value = 0;

  void increment() => value++;

  void decrement() => value--;
}
