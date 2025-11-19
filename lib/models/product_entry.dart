
import 'dart:convert';

List<ProductEntry> productEntryFromJson(String str) => List<ProductEntry>.from(json.decode(str).map((x) => ProductEntry.fromJson(x)));

String productEntryToJson(List<ProductEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
    String id;
    String name;
    String description;
    String category;
    String? thumbnail;
    int views;
    bool isFeatured;
    int stock;
    int price;
    int userId;
    String userUsername;
    DateTime? createdAt;

    ProductEntry({
        required this.id,
        required this.name,
        required this.description,
        required this.category,
        required this.thumbnail,
        required this.views,
        required this.isFeatured,
        required this.stock,
        required this.price,
        required this.userId,
        required this.userUsername,
        required this.createdAt,
    });

    factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        category: json["category"],
        thumbnail: json["thumbnail"],
        views: json["views"],
        isFeatured: json["is_featured"],
        stock: json["stock"],
        price: json["price"],
        userId: json["user_id"],
        userUsername: json["user_username"],
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category,
        "thumbnail": thumbnail,
        "views": views,
        "is_featured": isFeatured,
        "stock": stock,
        "price": price,
        "user_id": userId,
        "user_username": userUsername,
        "created_at": createdAt?.toIso8601String(),
    };
}
