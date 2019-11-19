import 'dart:async';

import 'package:flutter/material.dart';
import 'package:golden_shoe/Checkout.dart';
import 'package:golden_shoe/men.dart';
import 'package:golden_shoe/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show Platform;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golden Shoe',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(new List<int>()),

    );
  }
}

class ChatBot extends StatelessWidget {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    try{
      if (Platform.isAndroid || Platform.isIOS) {
        print("****** ANDROID*******");
        // TODO: implement build
        return Scaffold(
          body: WebView(
            initialUrl: "https://mmj744.github.io/chatbothost/",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          ),
        );}
    } catch (e){
      return Scaffold(
      );
    }
  }

}
class MyHomePage extends StatefulWidget {


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  List<int> cart = new List();
  MyHomePage(this.cart);
  @override
  _MyHomePageState createState() => _MyHomePageState(cart);
}

class _MyHomePageState extends State<MyHomePage> {

  void _addToCart(int id) {
    setState(() {
      cart.add(id);
    });
  }

  List<int> cart = new List();
  _MyHomePageState(this.cart);
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final List<Image> shoes = [Image(image: AssetImage('images/0.jpg')),Image(image: AssetImage('images/1.jpg')),
      Image(image: AssetImage('images/2.jpg')),Image(image: AssetImage('images/3.jpg')),
      Image(image: AssetImage('images/4.jpg')),Image(image: AssetImage('images/5.jpg')),
      Image(image: AssetImage('images/6.jpg'))];
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              GestureDetector(
                child: Text('Golden Shoe'),
                onTap: () {},
              )
            ]
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout(cart)));
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: (){

            },
          )
        ],

      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Home"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {Navigator.of(context).pop();},
            ),
            ListTile(
              title: Text("Mens"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Men(cart)));},
            ),
            ListTile(
              title: Text("Cart"),
              leading: Icon(Icons.shopping_cart),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout(cart)));},
            ),
            ListTile(
              title: Text("Customer Support"),
              leading: Icon(Icons.chat),
                trailing: Icon(Icons.arrow_forward),
              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatBot()));},
            )
          ],
        ),
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            color: Colors.red,
            child: Text("Golden Shoe banner",style: TextStyle(fontSize: 40),),
          ),
          Text("Featured Shoes",textAlign: TextAlign.center, style: TextStyle(fontSize: 30,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),),
          Container(
            height: 255,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: shoes.length,itemBuilder:  (context, index){
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Product(product_id: index, cart: cart,)));
                },
                child: Container(
                  width: 255,
                  child: shoes[index],),
              );
            },
            ),
          ),
          Container(
            height: 200,
            color: Colors.red,
          ),
        ],
      ),

    );
  }
}
