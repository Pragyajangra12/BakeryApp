import 'package:flutter/material.dart';

class BrowniePage extends StatefulWidget {
  const BrowniePage({super.key});

  @override
  State<BrowniePage> createState() => _BrowniePageState();
}

class _BrowniePageState extends State<BrowniePage> {
  // List of brownie types, you can customize this list or fetch it from a database
  final List<Map<String, String>> brownies = [
    {
      'name': 'Chocolate Brownie',
      'price': 'Rs. 400',
      'image': 'lib/images/brownie1.png',
    },
    {
      'name': 'Peanut Butter Brownie',
      'price': 'Rs. 450',
      'image': 'lib/images/brownie1.png',
    },
    {
      'name': 'Caramel Brownie',
      'price': 'Rs. 500',
      'image': 'lib/images/brownie1.png',
    },
    {
      'name': 'Red Velvet Brownie',
      'price': 'Rs. 450',
      'image': 'lib/images/brownie1.png',
    },
    {
      'name': 'Nutella Brownie',
      'price': 'Rs. 900',
      'image': 'lib/images/brownie1.png',
    },
    {
      'name': 'White Chocolate Brownie',
      'price': 'Rs. 450',
      'image': 'lib/images/brownie1.png',
    },
    {
      'name': 'S’mores Brownie',
      'price': 'Rs. 350',
      'image': 'lib/images/brownie1.png',
    },
    {
      'name': 'Espresso Brownie',
      'price': 'Rs. 470',
      'image': 'lib/images/brownie1.png',
    },
    {
      'name': 'Mint Chocolate Brownie',
      'price': 'Rs. 490',
      'image': 'lib/images/brownie1.png',
    },
    {
      'name': 'Oreo Brownie',
      'price': 'Rs. 530',
      'image': 'lib/images/brownie1.png',
    },
    {
      'name': 'Cherry Almond Brownie',
      'price': 'Rs. 750',
      'image': 'lib/images/brownie1.png',
    },
    {
      'name': 'Salted Caramel Pretzel',
      'price': 'Rs. 350',
      'image': 'lib/images/brownie1.png',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Brownies',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: brownies.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
            child: Container(
            height: 120, // Increase the height of the card here
            color: Colors.grey.shade200,
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: Image.asset(
                  brownies[index]['image']!, // Replace with correct image path
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  brownies[index]['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  'Price: ${brownies[index]['price']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        // Navigate to more details page (you can create a new page for more details)
                        print('More details for ${brownies[index]['name']}');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: () {
                        // Add the item to the cart (you can implement cart functionality here)
                        print('Added ${brownies[index]['name']} to cart');
                      },
                    ),
                  ],
                ),
              ),
            )
            );
          },
        ),
      ),
    )
    );
  }
}
