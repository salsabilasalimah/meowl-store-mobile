import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductListPage extends StatelessWidget {
  final List<Product> products;

  const ProductListPage({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        backgroundColor: Colors.blue,
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                'No products available.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text('Price: ${product.price}\nDescription: ${product.description}\nCategory: ${product.category}\nFeatured: ${product.isFeatured}'),
                  ),
                );
              },
            ),
    );
  }
}