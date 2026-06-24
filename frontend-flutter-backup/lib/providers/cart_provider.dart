import 'dart:convert';
import 'dart:html' show window;

import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';
import '../models/models.dart';
import '../i18n/currency_util.dart';
class CartItem {
  final String itemType; // 'product' or 'design'
  final String itemId;
  final String name;
  final String imageUrl;
  final int unitPriceCents;
  int quantity;

  CartItem({
    required this.itemType,
    required this.itemId,
    required this.name,
    required this.imageUrl,
    required this.unitPriceCents,
    this.quantity = 1,
  });

  int get totalCents => unitPriceCents * quantity;
  String get priceStr => CurrencyUtil.format(totalCents);

  Map<String, dynamic> toJson() => {
        'itemType': itemType,
        'itemId': itemId,
        'name': name,
        'imageUrl': imageUrl,
        'unitPriceCents': unitPriceCents,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        itemType: json['itemType'] as String,
        itemId: json['itemId'] as String,
        name: json['name'] as String,
        imageUrl: json['imageUrl'] as String,
        unitPriceCents: json['unitPriceCents'] as int,
        quantity: json['quantity'] as int? ?? 1,
      );
}

/// Thin wrapper around dart:html localStorage for testability.
class _CartStorage {
  static String? get(String key) => window.localStorage[key];
  static void set(String key, String value) => window.localStorage[key] = value;
  static void remove(String key) => window.localStorage.remove(key);
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final ApiService _api = ApiService();

  static const String _storageKey = 'cart_items';

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);
  int get totalCents => _items.fold(0, (sum, i) => sum + i.totalCents);
  String get totalStr => '\$${(totalCents / 100).toStringAsFixed(2)}';

  CartProvider() {
    _loadItems();
  }

  void _loadItems() {
    final data = _CartStorage.get(_storageKey);
    if (data == null || data.isEmpty) return;
    try {
      final List<dynamic> jsonList = jsonDecode(data) as List<dynamic>;
      for (final j in jsonList) {
        _items.add(CartItem.fromJson(j as Map<String, dynamic>));
      }
      notifyListeners();
    } catch (_) {
      // Corrupt storage – silently discard and let the user re-add items.
      _CartStorage.remove(_storageKey);
    }
  }

  void _saveItems() {
    final jsonList = _items.map((i) => i.toJson()).toList();
    _CartStorage.set(_storageKey, jsonEncode(jsonList));
  }

  void addItem(CartItem item) {
    final idx = _items.indexWhere(
        (i) => i.itemType == item.itemType && i.itemId == item.itemId);
    if (idx >= 0) {
      _items[idx].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    _saveItems();
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      _saveItems();
      notifyListeners();
    }
  }

  void updateQuantity(int index, int qty) {
    if (index >= 0 && index < _items.length) {
      if (qty <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = qty;
      }
      _saveItems();
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    _CartStorage.remove(_storageKey);
    notifyListeners();
  }

  Future<String?> checkout({
    required Map<String, dynamic> shippingAddress,
    required String contactEmail,
  }) async {
    final res = await _api.post(ApiConfig.orders, body: {
      'items': _items
          .map((i) => {
                'item_type': i.itemType,
                'item_id': i.itemId,
                'quantity': i.quantity,
              })
          .toList(),
      'shipping_address': shippingAddress,
      'contact_email': contactEmail,
    });

    if (res.isOk && res.data != null) {
      final orderId = res.data['order_id'] as String;
      clear();
      return orderId;
    }
    return null;
  }
}
