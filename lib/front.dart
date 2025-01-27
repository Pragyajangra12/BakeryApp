import 'package:flutter/material.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
            actions: [
              IconButton( icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen()),);
                  },),
      ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
        const UserAccountsDrawerHeader(
        accountName: Text('Pragya'),
        accountEmail: Text('pragyajangra456@gmail.com'),
        ),
            ListTile(
              title: Text('home'),
              leading: Icon(Icons.home),
              onTap: (){
                Navigator.pushNamed(context,'/home');
              },

            ),
            ListTile(
              title: Text('Menu'),
              leading: Icon(Icons.menu),
              onTap: (){
                Navigator.pushNamed(context,'/Menu');
              },

            ),
            ListTile(
              title: Text('Order History'),
              leading: Icon(Icons.history),
              onTap: (){
                Navigator.pushNamed(context,'/history');
              },

            ),
            ListTile(
              title: Text('Contact'),
              leading: Icon(Icons.phone),
              onTap: (){
                Navigator.pushNamed(context,'/contact');
              },

            ),
            ListTile(
              title: Text('About us'),
              leading: Icon(Icons.info),
              onTap: (){
                Navigator.pushNamed(context,'/about-us');
              },

            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: (){
                Navigator.pushNamed(context,'/Settings');
              },

            ),
            ListTile(
              title: Text('Account'),
              leading: Icon(Icons.account_circle),
              onTap: (){
                Navigator.pushNamed(context,'/accounts');
              },

            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.exit_to_app),
              onTap: (){
                Navigator.pushNamed(context,'/log-out');
              },

            ),
          ],

        ),
      ),

    );
  }
}
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Center(
        child: Text(
          'Your Cart is Empty!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
