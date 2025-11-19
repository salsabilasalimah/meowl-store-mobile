import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/product.dart';
import '../widgets/left_drawer.dart';
import 'product_form.dart';
import 'product_entry_list.dart';

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String nama = "Salsabila Salimah";
  final String npm = "2406432734";
  final String kelas = "F";

  List<Product> products = [];

  final List<ItemHomepage> items = [
    ItemHomepage("All Products", Icons.shopping_bag, Colors.blue),
    ItemHomepage("My Products", Icons.store, Colors.green),
    ItemHomepage("Create Product", Icons.add_circle, Colors.red),
  ];

  Future<void> Function() getOnTap(ItemHomepage item, CookieRequest request) {
    if (item.name == "Create Product") {
      return () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductFormPage(
              onAddProduct: (product) {
                setState(() {
                  products.add(product);
                });
              },
            ),
          ),
        );
      };
    } else if (item.name == "All Products") {
      return () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductEntryListPage(filterByUser: false),
          ),
        );
      };
    } else if (item.name == "My Products") {
      return () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductEntryListPage(filterByUser: true),
          ),
        );
      };
    } else {
      return () async {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Unknown action')),
          );
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Meowl Store',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row InfoCard agar sejajar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InfoCard(title: "NPM", content: npm),
                  InfoCard(title: "Nama", content: nama),
                  InfoCard(title: "Kelas", content: kelas),
                ],
              ),
              const SizedBox(height: 30),

              // Teks sambutan besar
              const Text(
                "Selamat datang di Meowl Store",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // Tombol utama (3 item)
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                children: items.map((item) => ItemCard(item, onTap: getOnTap(item, request))).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width / 3.8,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  final Future<void> Function() onTap;

  const ItemCard(this.item, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: () async { await onTap(); },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 32.0),
                const SizedBox(height: 6),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

