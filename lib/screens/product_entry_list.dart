import 'package:flutter/material.dart';
import 'package:meowl_store/models/product_entry.dart';
import 'package:meowl_store/widgets/product_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:meowl_store/screens/product_detail.dart';
import 'package:meowl_store/widgets/left_drawer.dart';
import '../config.dart';

class ProductEntryListPage extends StatefulWidget {
  final bool filterByUser;
  final String? filterByCategory;
  
  const ProductEntryListPage({
    super.key, 
    this.filterByUser = false,
    this.filterByCategory,
  });

  @override
  State<ProductEntryListPage> createState() => _ProductEntryListPageState();
}

class _ProductEntryListPageState extends State<ProductEntryListPage> {
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    try {
      print('Fetching products from: ${Config.productEntryJson}');
      final response = await request.get(Config.productEntryJson);

      // Check if response is valid
      if (response == null) {
        print('Response is null');
        return [];
      }

      // Decode response to json format
      var data = response;
      
      // Check if response is HTML (error page)
      if (data is String && data.trim().startsWith('<!DOCTYPE')) {
        print('Server returned HTML instead of JSON. Check if Django server is running and endpoint exists.');
        throw Exception('Server returned HTML. Please check if Django server is running at ${Config.baseUrl}');
      }

      // Convert json data to ProductEntry objects
      List<ProductEntry> listProducts = [];
      if (data != null && data is List) {
        for (var d in data) {
          if (d != null) {
            try {
              listProducts.add(ProductEntry.fromJson(d));
            } catch (e) {
              print('Error parsing product: $e');
              // Skip invalid products
            }
          }
        }
      }
    
      // Filter by category if needed
      if (widget.filterByCategory != null && widget.filterByCategory!.isNotEmpty) {
        listProducts = listProducts.where((product) => 
          product.category.toLowerCase() == widget.filterByCategory!.toLowerCase()
        ).toList();
      }
      
      // Filter by user if needed
      if (widget.filterByUser && request.loggedIn) {
        try {
          // Try to get current user info from backend
          final userInfo = await request.get('${Config.baseUrl}/auth/user/');
          if (userInfo != null) {
            // Try to filter by user ID first
            if (userInfo['id'] != null) {
              int currentUserId = userInfo['id'];
              listProducts = listProducts.where((product) => product.userId == currentUserId).toList();
            } 
            // Fallback: filter by username
            else if (userInfo['username'] != null) {
              String currentUsername = userInfo['username'];
              listProducts = listProducts.where((product) => product.userUsername == currentUsername).toList();
            }
          }
        } catch (e) {
          // If /auth/user/ doesn't exist, try alternative approach
          // Check if backend provides filtered endpoint
          try {
            final filteredResponse = await request.get('${Config.productEntryJson}?user_only=true');
            if (filteredResponse != null && filteredResponse is List) {
              listProducts = [];
              for (var d in filteredResponse) {
                if (d != null) {
                  listProducts.add(ProductEntry.fromJson(d));
                }
              }
            }
          } catch (e2) {
            // Last resort: show all products with a message
            print('Could not filter by user: $e2');
            // Note: In production, you might want to show an error message to the user
          }
        }
      }
      
      return listProducts;
    } catch (e) {
      print('Error fetching products: $e');
      // Re-throw with more context for better error handling
      if (e.toString().contains('<!DOCTYPE') || e.toString().contains('FormatException')) {
        throw Exception('Cannot connect to Django server. Please ensure:\n1. Django server is running at ${Config.baseUrl}\n2. Endpoint ${Config.productEntryJson} exists\n3. CORS is configured correctly');
      }
      // Return empty list on other errors
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String getAppBarTitle() {
      if (widget.filterByCategory != null) {
        return '${widget.filterByCategory} Products';
      } else if (widget.filterByUser) {
        return 'My Products';
      } else {
        return 'All Products';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(getAppBarTitle()),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProducts(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            String errorMessage = snapshot.error.toString();
            bool isConnectionError = errorMessage.contains('<!DOCTYPE') || 
                                    errorMessage.contains('FormatException') ||
                                    errorMessage.contains('Cannot connect') ||
                                    errorMessage.contains('Server returned HTML');
            
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 24),
                    Text(
                      isConnectionError
                          ? 'Cannot Connect to Server'
                          : 'Error Loading Products',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isConnectionError
                          ? 'Please ensure:\n\n1. Django server is running\n2. Server is at: ${Config.baseUrl}\n3. Endpoint exists: /json/\n4. CORS is configured'
                          : errorMessage.length > 200
                              ? '${errorMessage.substring(0, 200)}...'
                              : errorMessage,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {}); // Refresh
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            List<ProductEntry> products = snapshot.data as List<ProductEntry>;
            if (products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.filterByUser ? Icons.store_outlined : Icons.shopping_bag_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.filterByCategory != null
                          ? 'No ${widget.filterByCategory} products found.'
                          : widget.filterByUser 
                              ? 'You haven\'t added any products yet.'
                              : 'There are no products in meowl store yet.',
                      style: const TextStyle(fontSize: 18, color: Color(0xff59A5D8)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (_, index) => ProductEntryCard(
                  product: products[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          product: products[index],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}