import 'dart:convert';
import '../i18n/currency_util.dart';

class User {
  final String id;
  final String email;
  final String displayName;
  final String avatarUrl;
  final String bio;
  final String role;
  final String? stripeAccountId;
  final String createdAt;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.avatarUrl,
    required this.bio,
    required this.role,
    this.stripeAccountId,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] ?? '',
        email: json['email'] ?? '',
        displayName: json['display_name'] ?? '',
        avatarUrl: json['avatar_url'] ?? '',
        bio: json['bio'] ?? '',
        role: json['role'] ?? 'user',
        stripeAccountId: json['stripe_account_id'],
        createdAt: json['created_at'] ?? '',
      );

  bool get isAdmin => role == 'admin';
  bool get isDesigner => role == 'designer' || role == 'admin';

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'display_name': displayName,
        'avatar_url': avatarUrl,
        'bio': bio,
        'role': role,
        'stripe_account_id': stripeAccountId,
        'created_at': createdAt,
      };
}

class Product {
  final String id;
  final String name;
  final String slug;
  final String description;
  final int priceCents;
  final List<String> images;
  final String category;
  final List<String> tags;
  final int stock;
  final int salesCount;
  final String createdAt;
  final String materials;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.priceCents,
    required this.images,
    required this.category,
    required this.tags,
    required this.stock,
    required this.salesCount,
    required this.createdAt,
    this.materials = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        slug: json['slug'] ?? '',
        description: json['description'] ?? '',
        priceCents: json['price_cents'] ?? 0,
        images: (json['images'] as List?)?.cast<String>() ?? [],
        category: json['category'] ?? '',
        tags: (json['tags'] as List?)?.cast<String>() ?? [],
        stock: json['stock'] ?? 0,
        salesCount: json['sales_count'] ?? 0,
        createdAt: json['created_at'] ?? '',
        materials: json['materials']?.toString() ?? '',
      );

  String get priceStr => CurrencyUtil.format(priceCents);
}

class DesignElement {
  final String id;
  final String name;
  final String type;
  final String color;
  final String material;
  final String shape;
  final double sizeMm;
  final String imageUrl;
  final int priceCents;
  final int stock;
  final bool isActive;

  DesignElement({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
    required this.material,
    required this.shape,
    required this.sizeMm,
    required this.imageUrl,
    required this.priceCents,
    required this.stock,
    required this.isActive,
  });

  factory DesignElement.fromJson(Map<String, dynamic> json) => DesignElement(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        type: json['type'] ?? '',
        color: json['color'] ?? '',
        material: json['material'] ?? '',
        shape: json['shape'] ?? '',
        sizeMm: (json['size_mm'] ?? 8).toDouble(),
        imageUrl: json['image_url'] ?? '',
        priceCents: json['price_cents'] ?? 0,
        stock: json['stock'] ?? 0,
        isActive: json['is_active'] ?? true,
      );
}

class UserDesign {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String designData;
  final List<String> previewImages;
  final int priceCents;
  final bool isPublished;
  final int salesCount;
  final int totalEarningsCents;
  final String createdAt;
  final String? designerName;

  UserDesign({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.designData,
    required this.previewImages,
    required this.priceCents,
    required this.isPublished,
    required this.salesCount,
    required this.totalEarningsCents,
    required this.createdAt,
    this.designerName,
  });

  factory UserDesign.fromJson(Map<String, dynamic> json) => UserDesign(
        id: json['id'] ?? '',
        userId: json['user_id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        designData: json['design_data'] is Map
            ? jsonEncode(json['design_data'])
            : (json['design_data'] ?? '{}'),
        previewImages:
            (json['preview_images'] as List?)?.cast<String>() ?? [],
        priceCents: json['price_cents'] ?? 0,
        isPublished: json['is_published'] ?? false,
        salesCount: json['sales_count'] ?? 0,
        totalEarningsCents: json['total_earnings_cents'] ?? 0,
        createdAt: json['created_at'] ?? '',
        designerName: json['designer_name'],
      );

  String get priceStr => CurrencyUtil.format(priceCents);
}

class Order {
  final String id;
  final String userId;
  final int totalCents;
  final String status;
  final String? shippingAddress;
  final String? contactEmail;
  final String createdAt;
  final List<OrderItem>? items;

  Order({
    required this.id,
    required this.userId,
    required this.totalCents,
    required this.status,
    this.shippingAddress,
    this.contactEmail,
    required this.createdAt,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] ?? '',
        userId: json['user_id'] ?? '',
        totalCents: json['total_cents'] ?? 0,
        status: json['status'] ?? '',
        shippingAddress: json['shipping_address'],
        contactEmail: json['contact_email'],
        createdAt: json['created_at'] ?? '',
        items: (json['items'] as List?)
            ?.map((i) => OrderItem.fromJson(i))
            .toList(),
      );

  String get totalStr => CurrencyUtil.format(totalCents);
  String get statusLabel {
    switch (status) {
      case 'pending': return 'Pending Payment';
      case 'paid': return 'Paid';
      case 'processing': return 'Processing';
      case 'shipped': return 'Shipped';
      case 'delivered': return 'Delivered';
      case 'cancelled': return 'Cancelled';
      case 'refunded': return 'Refunded';
      default: return status;
    }
  }
}

class OrderItem {
  final String id;
  final String itemType;
  final String itemId;
  final int quantity;
  final int unitPriceCents;
  final int totalCents;
  final String? designerId;
  final int designerCommissionCents;

  OrderItem({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.quantity,
    required this.unitPriceCents,
    required this.totalCents,
    this.designerId,
    required this.designerCommissionCents,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['id'] ?? '',
        itemType: json['item_type'] ?? '',
        itemId: json['item_id'] ?? '',
        quantity: json['quantity'] ?? 1,
        unitPriceCents: json['unit_price_cents'] ?? 0,
        totalCents: json['total_cents'] ?? 0,
        designerId: json['designer_id'],
        designerCommissionCents: json['designer_commission_cents'] ?? 0,
      );
}

class EnergyRecommendation {
  final String element;
  final String explanation;
  final List<String> recommendedColors;
  final List<String> recommendedMaterials;
  final String energyFocus;
  final List<String> crystalSuggestions;

  EnergyRecommendation({
    required this.element,
    required this.explanation,
    required this.recommendedColors,
    required this.recommendedMaterials,
    required this.energyFocus,
    required this.crystalSuggestions,
  });

  factory EnergyRecommendation.fromJson(Map<String, dynamic> json) =>
      EnergyRecommendation(
        element: json['element'] ?? '',
        explanation: json['explanation'] ?? '',
        recommendedColors:
            (json['recommended_colors'] as List?)?.cast<String>() ?? [],
        recommendedMaterials:
            (json['recommended_materials'] as List?)?.cast<String>() ?? [],
        energyFocus: json['energy_focus'] ?? '',
        crystalSuggestions:
            (json['crystal_suggestions'] as List?)?.cast<String>() ?? [],
      );
}
