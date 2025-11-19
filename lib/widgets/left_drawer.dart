import 'package:flutter/material.dart';
import 'package:meowl_store/config.dart';
import 'package:meowl_store/screens/login.dart';
import 'package:meowl_store/screens/menu.dart';
import 'package:meowl_store/screens/product_entry_list.dart';
import 'package:meowl_store/screens/product_form.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CookieRequest>(
      builder: (context, request, child) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Meowl Store',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your Shopping Companion',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Halaman Utama'),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: const Text('All Products'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductEntryListPage(filterByUser: false),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.store),
                title: const Text('My Products'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductEntryListPage(filterByUser: true),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_circle),
                title: const Text('Tambah Produk'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductFormPage(
                        onAddProduct: (product) {
                          // Product added callback
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  Navigator.pop(context); // Close drawer
                  try {
                    await request.logout(Config.authLogout);
                  } catch (e) {
                    // If logout fails (e.g., server error), still proceed with local logout
                    print('Logout server call failed: $e');
                  }
                  // Always navigate to login after attempting logout
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logged out successfully")),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
 }
}
