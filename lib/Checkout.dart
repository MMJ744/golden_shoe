import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:golden_shoe/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  HashMap<int,String> names = new HashMap();
  HashMap<int,int> prices = new HashMap();

  int discount = 0;
  int cartTotal(){
    int total = 0;
    for(int i in cart){
      total+=prices[i];
    }
    return total-discount;
  }
  TextEditingController codeController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    try{
      final db = Firestore.instance;
      db.collection("products").where('id',isGreaterThanOrEqualTo: 0).snapshots().listen((data)=>{
        setState(() {
          for (var d in data.documents) {
            names.putIfAbsent(d['id'], () => d['name']);
            prices.putIfAbsent(d['id'], () => d['price']);
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
    void _applyCode() {
      setState(() {
        try{
          if(codeController.text.substring(0,1)=='D'){
            discount += int.parse(codeController.text.substring(1));
            print("disount is now " + discount.toString());
          }else {
            print("invalid code *******************************************");
          }
        } catch (e) {
          print("error in applying code");
          print(codeController.text);
          print(e.toString());
        }
      });
    }

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
            height: 100,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Text("Checkout banner",style: TextStyle(fontSize: 40),),
            color: Colors.green,
          ),
          Container(
            height: 250,
            alignment: Alignment.center,
            child: ListView.builder(itemCount: cart.length, itemBuilder: (context, index){
              String name = "";
              int price = 999;
              try{
                name = names[cart[index]];
                price = prices[cart[index]];
              } catch (e) {}
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('$name', style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.blue),),
                            Text('£$price', style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.w100,
                                color: Colors.blueGrey),),
                          ],
                        ),
                      ),
                      IconButton(icon: Icon(Icons.highlight_off),onPressed: (){
                        cart.removeAt(index);
                      },)
                    ]
                ),
              );
            }),

          ),
          Container(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  height: 64,
                  width: 200,
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Text("Apply a voucher code"),
                      TextField(
                        controller: codeController,
                        textAlign: TextAlign.center,
                      )
                    ],

                  ),
                ),
                Container(
                  width: 100,
                  height: 50,
                child: RaisedButton(
                  child: Text('Apply'),
                  onPressed: () {_applyCode();},
                ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Total : ' + cartTotal().toString() + '     ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              RaisedButton(child: Text("Checkout"),)
            ],
          )

        ],
      )
    );
  }

}