import 'package:flutter/material.dart';


class checkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              print('go to cart');
            },
          )
        ],

      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 200,
            color: Colors.green,
          ),
        ],
      )
    );
  }

}