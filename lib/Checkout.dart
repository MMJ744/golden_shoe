import 'package:flutter/material.dart';
import 'package:golden_shoe/main.dart';

import 'men.dart';

class Checkout extends StatefulWidget {
  List<int> cart;
  Checkout(this.cart);
  @override
  State<StatefulWidget> createState() => checkout(cart);

}


class checkout extends State<Checkout> {
  List<int> cart;
  checkout(this.cart);


  void _addToCart(int id) {
    setState(() {
      cart.add(id);
    });
  }
  final List<Image> shoes = [Image(image: AssetImage('images/0.jpg')),Image(image: AssetImage('images/1.jpg')),
    Image(image: AssetImage('images/2.jpg')),Image(image: AssetImage('images/3.jpg')),
    Image(image: AssetImage('images/4.jpg')),Image(image: AssetImage('images/5.jpg')),
    Image(image: AssetImage('images/6.jpg'))];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                Text("golden shoe"),
              ]
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {

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
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(cart)));}
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
              ),
            ],
          ),
        ),
      body: Column(
        children: <Widget>[
          Container(
            height: 200,
            color: Colors.green,
          ),
          Container(
            height: 500,
            child: ListView.builder(itemCount: cart.length, itemBuilder: (context, index){
              return Container(
                width: 255,
                child: shoes[index],
              );
            }),

          )
        ],
      )
    );
  }

}