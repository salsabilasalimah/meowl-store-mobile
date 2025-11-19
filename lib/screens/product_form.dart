import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/product.dart';
import '../config.dart';
import 'menu.dart';

class ProductFormPage extends StatefulWidget {
  final Function(Product) onAddProduct;

  const ProductFormPage({super.key, required this.onAddProduct});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int _price = 0;
  int _stock = 0;
  String _description = "";
  String _thumbnail =
      "https://contents.mediadecathlon.com/p2571247/k\$848103e1194da4ca59b9ab6b60c81418/bola-sepak-jahit-untuk-latihan-ukuran-4-putih-kipsta-8789908.jpg?f=1920x0&format=auto";
  String _category = "";
  bool _isFeatured = false;

  // Category choices matching Django CATEGORY_CHOICES
  final List<Map<String, String>> _categoryChoices = [
    {'value': 'accessories', 'label': 'Accessories'},
    {'value': 'jersey', 'label': 'Jersey'},
    {'value': 'sepatu', 'label': 'Sepatu'},
    {'value': 'bola', 'label': 'Bola'},
    {'value': 'kaos kaki', 'label': 'Kaos kaki'},
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Product Name",
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _name = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Name cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Product Price",
                    labelText: "Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String? value) {
                    setState(() {
                      _price = int.tryParse(value ?? "") ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Price cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Price must be a number!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Product Stock",
                    labelText: "Stock",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String? value) {
                    setState(() {
                      _stock = int.tryParse(value ?? "") ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Stock cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Stock must be a number!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Product Description",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    // Description is optional
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Product Thumbnail URL",
                    labelText: "Thumbnail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _thumbnail = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value != null && value.isNotEmpty) {
                      // Basic URL validation if provided
                      if (!Uri.parse(value).isAbsolute) {
                        return "Thumbnail must be a valid URL!";
                      }
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Category",
                    hintText: "Select Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  value: _category.isEmpty ? null : _category,
                  items: _categoryChoices.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['value'],
                      child: Text(category['label']!),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _category = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a category!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CheckboxListTile(
                  title: const Text('Is Featured'),
                  value: _isFeatured,
                  onChanged: (bool? value) {
                    setState(() {
                      _isFeatured = value ?? false;
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Show loading indicator
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        try {
                          final requestData = {
                            "name": _name,
                            "price": _price,  // Send as integer, not string
                            "stock": _stock,  // Stock field required by Django
                            "description": _description,
                            "thumbnail": _thumbnail,
                            "category": _category,
                            "is_featured": _isFeatured,  // Send as boolean, not string
                          };
                          
                          print(
                            'Submitting product to: ${Config.baseUrl}/create-flutter/',
                          );
                          print(
                            'Data: ${jsonEncode(requestData)}',
                          );

                          final response = await request.postJson(
                            "${Config.baseUrl}/create-flutter/",
                            jsonEncode(requestData),
                          );

                          // Close loading dialog
                          if (context.mounted) {
                            Navigator.pop(context);
                          }

                          // Check if response is HTML (error page from Django)
                          if (response is String &&
                              response.trim().startsWith('<!DOCTYPE')) {
                            throw Exception(
                              'Server returned HTML instead of JSON. Please check:\n1. Django server is running at ${Config.baseUrl}\n2. Endpoint /create-flutter/ exists\n3. CORS is configured correctly',
                            );
                          }

                          if (context.mounted) {
                            if (response != null &&
                                response['status'] == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Product successfully saved!"),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyHomePage(),
                                ),
                              );
                            } else {
                              // Show detailed error message from server
                              String errorMsg = "Something went wrong, please try again.";
                              
                              // Try to extract error message from Django response
                              if (response != null) {
                                // Check for common Django error formats
                                if (response['detail'] != null) {
                                  errorMsg = response['detail'].toString();
                                } else if (response['message'] != null) {
                                  errorMsg = response['message'].toString();
                                } else if (response['error'] != null) {
                                  errorMsg = response['error'].toString();
                                } else {
                                  // Check for field-specific errors
                                  List<String> fieldErrors = [];
                                  response.forEach((key, value) {
                                    if (value is List && value.isNotEmpty) {
                                      fieldErrors.add("$key: ${value.join(', ')}");
                                    } else if (value is String) {
                                      fieldErrors.add("$key: $value");
                                    }
                                  });
                                  if (fieldErrors.isNotEmpty) {
                                    errorMsg = fieldErrors.join('\n');
                                  }
                                }
                              }
                              
                              print('Server error response: $response');
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMsg),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 6),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          // Close loading dialog if still open
                          if (context.mounted) {
                            Navigator.pop(context);
                          }

                          String errorMessage = "Failed to create product";

                          // Check for specific error types
                          String errorStr = e.toString();
                          if (errorStr.contains('<!DOCTYPE') ||
                              errorStr.contains('FormatException')) {
                            errorMessage =
                                "Cannot connect to Django server.\n\nPlease ensure:\n1. Django server is running at ${Config.baseUrl}\n2. Endpoint /create-product/ exists\n3. CORS is configured correctly";
                          } else if (errorStr.contains('400')) {
                            errorMessage =
                                "Bad Request (400). Please check:\n1. All required fields are filled\n2. Data format is correct\n3. Server endpoint accepts this data";
                          } else if (errorStr.contains('401') ||
                              errorStr.contains('403')) {
                            errorMessage =
                                "Authentication required. Please login first.";
                          } else if (errorStr.contains('404')) {
                            errorMessage =
                                "Endpoint not found (404). Please check if /create-product/ exists in Django.";
                          } else if (errorStr.contains('500')) {
                            errorMessage =
                                "Server error (500). Please check Django server logs.";
                          } else {
                            errorMessage = "Error: ${e.toString()}";
                          }

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 6),
                              ),
                            );
                          }

                          print('Error creating product: $e');
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
