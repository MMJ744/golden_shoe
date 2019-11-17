import 'package:flutter/material.dart';
import 'package:golden_shoe/Checkout.dart';

class product extends StatelessWidget {
  final int product_id;

  const product({Key key, this.product_id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Text("Golden Shoe"),
            ]
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => checkout()));
            },
          )
        ],

      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              child:  Text(product_id.toString()),
            )
          ],
        ),
      ),
    );
  }

}