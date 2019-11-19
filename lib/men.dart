import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:golden_shoe/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golden_shoe/product.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Checkout.dart';

class Men extends StatefulWidget {
  List<int> cart;
  Men(this.cart);
  @override
  State<StatefulWidget> createState() => men(cart);

}


class men extends State<Men> {
  List<int> cart;
  HashMap<int,String> names = new HashMap();
  HashMap<int,int> prices = new HashMap();
  HashMap<int,int> stocks = new HashMap();
  men(this.cart);
  final List<Image> shoes = [Image(image: AssetImage('images/0.jpg')),Image(image: AssetImage('images/1.jpg')),
    Image(image: AssetImage('images/2.jpg')),Image(image: AssetImage('images/3.jpg')),
    Image(image: AssetImage('images/4.jpg')),Image(image: AssetImage('images/5.jpg')),
    Image(image: AssetImage('images/6.jpg'))];

  void _addToCart(int id) {
    if(stocks[id] >0){
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

  Widget _buildProduct(int id) {
    String name = ' ';
    int price = 999;
    int stock = -1;
    try{
      name = names[id];
      price = prices[id];
      stock = stocks[id];
    } catch (e) {
      print(e.toString());
    }
      return Container(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Product(product_id: id, cart: cart,)));},
              child: shoes[id],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('$name', style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.blue),),
                  Text('£$price', style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w100,
                      color: Colors.blueGrey),)
                ]
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {},
                  child: Text(
                      'Buy Now',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                ),
                RaisedButton(
                  onPressed: () {_addToCart(id);},
                  child: Text(
                      'Add to cart',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            )
          ],
        ),
      );
  }
  @override
  Widget build(BuildContext context) {

    try{
      final db = Firestore.instance;
      db.collection("products").where('id',isGreaterThan:-1).snapshots().listen((data)=>{
        setState(() {
          for (var d in data.documents) {
            names.putIfAbsent(d['id'], () => d['name']);
            prices.putIfAbsent(d['id'], () => d['price']);
            stocks.putIfAbsent(d['id'], () => d['stock']);
          }
        }
      )});

    }catch (e){
      print(e.toString());
      print("FAIL");
    }
    Future.delayed(const Duration(milliseconds: 100), () {

      setState(() {

      });

    });
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
      body: Column(
      children: <Widget>[
        Container(
          width: 500,
          height: 600,
          child: ListView.builder(itemCount: shoes.length,itemBuilder:  (context, index){
            return _buildProduct(index);
          }),
        )
      ],
      ),
    );
  }
}

