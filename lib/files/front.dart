import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'brownie.dart';
import 'cart_provider.dart';
import 'package:provider/provider.dart';// Ensure this import is correct

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
    const ProfileScreen(),
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
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text(
          'User Profile Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
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
                        CategoryBox(imagePath: 'lib/images/brownie1.png', label: 'Brownie', text: "", nextPage: BrowniePage(),price: 23.9,),
                        CategoryBox(imagePath: 'lib/images/cake1.jpeg', label: 'Cakes', text: "", nextPage: BrowniePage(),price:23.9),
                        CategoryBox(imagePath: 'lib/images/cupcake.jpeg', label: 'Cupcakes', text: "", nextPage: BrowniePage(),price:23.9),
                        CategoryBox(imagePath: 'lib/images/donut.jpeg', label: 'Donuts', text: "", nextPage: BrowniePage(),price:23.9),
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
                        CategoryBox(imagePath: 'lib/images/brownie.jpeg', label: 'Chocolate Brownie', text: '', nextPage: BrowniePage(),price:23.9),
                        CategoryBox(imagePath: 'lib/images/donut.jpeg', label: 'Chocolate Donuts', text: '', nextPage: BrowniePage(),price:23.9),
                        CategoryBox(imagePath: 'lib/images/cake.jpeg', label: 'Black Forest Cake', text: '', nextPage: BrowniePage(),price:23.9),
                        CategoryBox(imagePath: 'lib/images/cupcake.jpeg', label: 'Vanilla Cupcake', text: '', nextPage: BrowniePage(),price:23.9),
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
  final String text;
  final double price; // Price of the item
  final Widget nextPage;

  const CategoryBox({
    super.key,
    required this.imagePath,
    required this.label,
    required this.text,
    required this.price,
    required this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the next page
        Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage));

        // Add item to the cart
        Provider.of<CartProvider>(context, listen: false)
            .addToCart(label, imagePath, price);

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
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (text.isNotEmpty)
              Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(
              'Rs. ${price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
