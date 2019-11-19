import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:golden_shoe/Checkout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golden_shoe/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io';

import 'men.dart';
//import 'package:firebase/firebase.dart';
//import 'package:firebase/firestore.dart' as fs;
class Product extends StatefulWidget {
  final int product_id;
  List<int> cart = new List();
  Product({Key key, this.product_id, this.cart}) : super(key: key);

  @override
  State<StatefulWidget> createState() => productState(product_id, cart);

}
class productState extends State<Product> with TickerProviderStateMixin{
  final int product_id;
  List<int> cart = new List();
  String name = "";
  int price = 0;
  int stock = 0;
  String desc = "placeholder \n more stuff \n and more";
  productState(this.product_id, this.cart);

  void _addToCart(int id) {
    if(stock >0){
      setState(() {
        cart.add(id);
        Alert(
          context: context,
          type: AlertType.none,
          title: "Added to cart",
          buttons: [
            DialogButton(
              child: Text(
                "Continue Shopping", textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
              height: 50,
            ),
            DialogButton(
                height: 50,
                width: 120,
              child: Text(
                "Go to checkout",textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 20)
              ), onPressed: () => {Navigator.pop(context),Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout(cart)))}
            )
          ],
        ).show();
      });
    }else{
      Alert(
          context: context,
          type: AlertType.none,
          title: "Sorry Item is out of stock",
          buttons: [
            DialogButton(
              child: Text(
                "Continue Shopping", textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
              height: 50,
            ),
          ]
      ).show();
    }
  }
  final List<Image> shoes = [Image(image: AssetImage('images/0.jpg')),Image(image: AssetImage('images/1.jpg')),
    Image(image: AssetImage('images/2.jpg')),Image(image: AssetImage('images/3.jpg')),
    Image(image: AssetImage('images/4.jpg')),Image(image: AssetImage('images/5.jpg')),
    Image(image: AssetImage('images/6.jpg'))];
  @override
  Widget build(BuildContext context) {

    try{
      final db = Firestore.instance;
      db.collection("products").where('id',isEqualTo:product_id).snapshots().listen((data)=> {
        setState(() {
          name = data.documents[0]['name'];
          price = data.documents[0]['price'];
          stock = data.documents[0]['stock'];
        })});
    }catch (e){
      /*initializeApp(  apiKey: "AIzaSyDCeqO4KPYwOnKDLuiKKK1_QWGkKmx4vO0",
          authDomain: "goldenshoemj.firebaseapp.com",
          databaseURL: "https://goldenshoemj.firebaseio.com",
          projectId: "goldenshoemj",
          storageBucket: "goldenshoemj.appspot.com",
          messagingSenderId: "365930182765");
      print("2");
      fs.Firestore store = firestore();
      print("3");
      fs.CollectionReference ref = store.collection("products");
      print("4");
      ref.where('id', "==", product_id).get().then((data)=> {
        setState((){
          name = data.docs[0].get('name');
          price = data.docs[0].get('price');
          stock = data.docs[0].get('stock');
        })
      });*/
    }

    var description = Container(child: Text(
      "$desc",
      textAlign: TextAlign.justify,
      style: TextStyle(height: 1.5, color: Color(0xFF6F8398)),
    ),
        padding: EdgeInsets.all(13)
    );
    var nameItem = Container(child: Text(
      "$name",
      textAlign: TextAlign.center,
      style: TextStyle(height: 1.5, color: Colors.blue,fontSize: 30, fontWeight: FontWeight.bold),
    ),);

    return new Scaffold(
    appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              GestureDetector(
                child: Text('Golden Shoe'),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(cart)));},
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
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(cart)));},
            ),
            ListTile(
              title: Text("Mens"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Men(cart)));},
            ),
            ListTile(
              title: Text("Women"),
              trailing: Icon(Icons.arrow_forward),
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
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            nameItem,
            shoes[product_id],
            description,
            Text( 'stock: $stock'),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(child: Text("ADD TO CART +",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ), color: Colors.transparent,
                    onPressed: (){_addToCart(product_id);},),
                  Text('£$price',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w100,
                        color: Colors.blueGrey
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        )
      ),
    );
  }

}