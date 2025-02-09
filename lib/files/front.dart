import 'package:bakery_app/files/productDetails.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'cart_provider.dart';
import 'package:provider/provider.dart';// Ensure this import is correct
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}
class _FrontPageState extends State<FrontPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
     CartScreen(),
     ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',

          ),
        ],
      ),
    );
  }
}
// CartScreen
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: cart.cartItems.isEmpty
          ? Center(child: Text('Your Cart is Empty!', style: TextStyle(fontSize: 24)))
          : ListView.builder(
        itemCount: cart.cartItems.length,
        itemBuilder: (context, index) {
          final item = cart.cartItems[index];

          return ListTile(
            leading: Image.asset(item['image'], width: 50, height: 50),
            title: Text(item['name']),
            subtitle: Text('Rs. ${item['price']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => cart.removeFromCart(index),
            ),
          );
        },
      ),
      bottomNavigationBar: cart.cartItems.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            cart.clearCart();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Order Placed Successfully!')),
            );
          },
          child: Text('Checkout'),
        ),
      )
          : null,
    );
  }
}
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _userName = "User Name";
  String _email = "user@example.com";
  String _profilePic = "assets/profile.png"; // Default profile image

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc["name"] ?? "Guest";
          _email = userDoc["email"] ?? "guest@example.com";
          _profilePic = userDoc["profilePic"] ?? "assets/profile.png";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: _profilePic.startsWith("http")
                  ? NetworkImage(_profilePic)
                  : AssetImage(_profilePic) as ImageProvider,
            ),
            const SizedBox(height: 10),

            // Name and Email
            Text(
              _userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              _email,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildProfileButton("Promotion", Icons.card_giftcard),
                const SizedBox(width: 10),
                _buildProfileButton("Badges", Icons.verified),
              ],
            ),

            const SizedBox(height: 20),

            // Profile Options List
            _buildProfileOption("My Orders", Icons.shopping_bag),
            _buildProfileOption("Contact Us", Icons.support_agent),
            _buildProfileOption("Settings", Icons.settings),
            _buildProfileOption("Sign Out", Icons.logout, logout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton(String title, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon, {bool logout = false}) {
    return ListTile(
      leading: Icon(icon, color: logout ? Colors.red : Colors.brown),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: () {
        if (logout) {
          _logoutUser();
        }
      },
    );
  }

  Future<void> _logoutUser() async {
    await _auth.signOut(); // Sign out from Firebase Auth
    Navigator.pushReplacementNamed(context, "/login"); // Navigate to login
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Pragya"; // Change this dynamically if needed
  String location = "Fetching location...";
  TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  final List<Map<String, dynamic>> _items = [
    {"label": "Brownie", "image": "lib/images/brownie1.png", "price": null},
    {"label": "Cakes", "image": "lib/images/cake1.jpeg", "price": null},
    {"label": "Cupcakes", "image": "lib/images/cupcake.jpeg", "price": null},
    {"label": "Donuts", "image": "lib/images/donut.jpeg", "price": null},
    {"label": "Chocolate Brownie", "image": "lib/images/brownie.jpeg", "price": 23.9},
    {"label": "Chocolate Donuts", "image": "lib/images/donut.jpeg", "price": 23.9},
    {"label": "Black Forest Cake", "image": "lib/images/cake.jpeg", "price": 23.9},
    {"label": "Vanilla Cupcake", "image": "lib/images/cupcake.jpeg", "price": 23.9},
  ];

  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _items;
    _getLocation();
  }
  void _filterItems(String query) {
    setState(() {
      searchQuery = query;
      _filteredItems = _items
          .where((item) =>
          item["label"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }


  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => location = "Location disabled");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        setState(() => location = "Location denied");
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() => location = "${position.latitude}, ${position.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey.shade200,
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text(
                              "What would you want to eat?",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                  image: AssetImage('lib/images/bread.jpeg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Categories",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        CategoryBox(imagePath: 'lib/images/brownie1.png', label: 'Brownie',description:'',price: 23.9,ingredients: ['']),
                        CategoryBox(imagePath: 'lib/images/cake1.jpeg', label: 'Cakes',description: '', price:23.9,ingredients: [''],),
                        CategoryBox(imagePath: 'lib/images/cupcake.jpeg', label: 'Cupcakes',description: '', price:23.9,ingredients: [''],),
                        CategoryBox(imagePath: 'lib/images/donut.jpeg', label: 'Donuts',description: '',price:23.9,ingredients:[''],),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Popular Cakes",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        CategoryBox(imagePath: 'lib/images/brownie.jpeg', label: 'Chocolate Brownie',description:'A rich and decadent treat combining velvety chocolate with the nutty crunch of hazelnuts.',price:1200.0,ingredients: ['Dark Chocolate, Hazelnuts, Sugar, Butter, Eggs, Flour, Vanilla Extract, Baking Powder, Salt',]),
                        CategoryBox(imagePath: 'lib/images/donut.jpeg', label: 'Chocolate Donuts', description: 'Soft and fluffy chocolate donuts topped with chocolate glaze.', price:600.0,ingredients: ['Strawberries, Whipped Cream, Sugar, Butter, Eggs, Flour']),
                        CategoryBox(imagePath: 'lib/images/cake.jpeg', label: 'Black Forest Cake', description: 'A layered chocolate cake with cherries and whipped cream.', price:500.0,ingredients: ['Cocoa Powder, Buttermilk, Vinegar',]),
                        CategoryBox(imagePath: 'lib/images/cupcake.jpeg', label: 'Vanilla Cupcake', description: 'A classic vanilla cupcake with buttercream frosting',price:350.0,ingredients: ['Cream Cheese, Sugar, Butter, Eggs, Flour, Baking Powder, Salt',]),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryBox extends StatelessWidget {
  final String imagePath;
  final String label;
  final String description;
  final double price; // Price of the item
  final List<String> ingredients;

  const CategoryBox({
    super.key,
    required this.imagePath,
    required this.label,
    required this.description,
    required this.price,
    required this.ingredients,
    
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the next page
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                    imagePath: imagePath,
                    label: label,
                    description: description,
                    price: price,
                    ingredients: ingredients)));

        // Add item to the cart
        Provider.of<CartProvider>(context, listen: false)
            .addToCart(label: label, price: price,imagePath: imagePath);

        // Show snackbar confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label added to cart')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 125,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(image: AssetImage(imagePath)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
