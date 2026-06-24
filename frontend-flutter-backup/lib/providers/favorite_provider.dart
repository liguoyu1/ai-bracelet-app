import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class FavoriteProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  final Set<String> _favoriteIds = {};
  List<Product> _favorites = [];
  bool _loading = false;

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
  List<Product> get favorites => _favorites;
  bool get loading => _loading;

  Future<void> fetchFavorites() async {
    _loading = true;
    notifyListeners();

    try {
      final res = await _api.get(ApiConfig.favorites);

      if (res.isOk && res.data != null) {
        final list = res.data as List<dynamic>;
        _favoriteIds.clear();
        _favorites.clear();
        for (final item in list) {
          final f = item as Map<String, dynamic>;
          _favoriteIds.add(f['item_id'] as String);
        }
      }
    } catch (_) {}

    _loading = false;
    notifyListeners();
  }

  Future<bool> toggle(String productId) async {
    try {
      final res = await _api.post(ApiConfig.toggleFavorite, body: {
        'item_id': productId,
        'item_type': 'product',
      });

      if (res.isOk && res.data != null) {
        final newState = res.data['favorited'] as bool? ?? !_favoriteIds.contains(productId);
        if (newState) {
          _favoriteIds.add(productId);
        } else {
          _favoriteIds.remove(productId);
          _favorites.removeWhere((p) => p.id == productId);
        }
        notifyListeners();
        return newState;
      }
    } catch (_) {}

    return _favoriteIds.contains(productId);
  }

  bool isFavorite(String productId) => _favoriteIds.contains(productId);
}
