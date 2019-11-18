import 'package:flutter/material.dart';
import 'package:golden_shoe/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Checkout.dart';

class Men extends StatefulWidget {
  List<int> cart;
  Men(this.cart);
  @override
  State<StatefulWidget> createState() => men(cart);

}


class men extends State<Men> {
  List<int> cart;

  men(this.cart);
  final List<Image> shoes = [Image(image: AssetImage('images/0.jpg')),Image(image: AssetImage('images/1.jpg')),
    Image(image: AssetImage('images/2.jpg')),Image(image: AssetImage('images/3.jpg')),
    Image(image: AssetImage('images/4.jpg')),Image(image: AssetImage('images/5.jpg')),
    Image(image: AssetImage('images/6.jpg'))];

  void _addToCart(int id) {
    setState(() {
      cart.add(id);
    });
  }

  Future<String> getValue(DocumentSnapshot d) async {
    String s = d['name'];
    return s;
  }
  Widget _buildProduct(int id) {
    String name;
    int price;
    try {
      final db = Firestore.instance;
      db.collection("products").where('id', isEqualTo: id).snapshots().listen((
          data) => (){
        setState(() {
          name = data.documents[0]['name'];
          price = data.documents[0]['price'];
        });

        });
    } catch (e) { };
    print('$name' + "  " + '$price');
      return Container(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            shoes[id],
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
              title: Text("Cart"),
              leading: Icon(Icons.shopping_cart),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout(cart)));},
            ),
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

